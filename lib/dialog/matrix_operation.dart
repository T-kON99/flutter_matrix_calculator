import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrix_calculator/form/matrix_calculate.dart';
import '../classes/matrix.dart';
import '../operation.dart';
import 'matrix_latex.dart';
import '../utils.dart';

class OperationFormView extends StatefulWidget {
  const OperationFormView({Key key, this.operation, this.data, this.precision, this.resultMatrixName}) : super(key: key);
  final MatrixOperation operation;
  final Map<String, Matrix> data;
  final int precision;
  final String resultMatrixName;
  @override
  _OperationFormViewState createState() => _OperationFormViewState();
}

class _OperationFormViewState extends State<OperationFormView> {
  final _formKey = GlobalKey<FormState>();

  Map<Operation, Function> calculateHandler = {
    Operation.ADD: (Matrix m1, Matrix m2, double s) => m1 + m2,
    Operation.SUB: (Matrix m1, Matrix m2, double s) => m1 - m2,
    Operation.MATRIX_MULT: (Matrix m1, Matrix m2, double s) => m1 * m2,
    Operation.SCALAR_MULT: (Matrix m1, Matrix m2, double s) => m1 * s,
    Operation.POW: (Matrix m1, Matrix m2, double s) => m1 ^ s.toInt(),
    Operation.DET: (Matrix m1, Matrix m2, double s) => m1.gaussElimination(),
    Operation.INV: (Matrix m1, Matrix m2, double s) => m1.inv(),
    Operation.RE: (Matrix m1, Matrix m2, double s) => m1.getRE(),
    Operation.RRE: (Matrix m1, Matrix m2, double s) => m1.getRRE(),
    Operation.COFACTOR: (Matrix m1, Matrix m2, double s) => m1.getCofactor(),
    Operation.ADJOINT: (Matrix m1, Matrix m2, double s) => m1.getAdjoint(),
    Operation.TRANSPOSE: (Matrix m1, Matrix m2, double s) => m1.getTranspose()
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildCard(
      key: _formKey,
      matrixOperation: widget.operation,
      parentContext: context,
      data: widget.data,
      precision: widget.precision,
    );
  }

  Card buildCard({Key key, MatrixOperation matrixOperation, BuildContext parentContext, Map<String, Matrix> data, int precision}) {
    return Card(
      elevation: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppBar(
            leading: Builder(builder: (BuildContext context) {
              return IconButton(
                icon: Icon(matrixOperation.icon),
                color: matrixOperation.color,
                tooltip: matrixOperation.operation.fullName,
                onPressed: () => buildOperationDialog(parentContext, matrixOperation, data, precision),
              );
            }),
            backgroundColor: matrixOperation.bgColor,
            title: Text(matrixOperation.operation.fullName),
          ),
          ListTile(
            title: Text(matrixOperation.operation.shortName),
            subtitle: Text('${matrixOperation.description}'),
            onTap: () => {
              buildOperationDialog(parentContext, matrixOperation, data, precision)
            },
          )
        ],
      ),
    );
  }

  Future buildOperationDialog(BuildContext parentContext, MatrixOperation matrixOperation, Map<String, Matrix> data, int precision) {
    return showDialog(
        context: parentContext,
        builder: (BuildContext context) {
          print('Operation ${matrixOperation.operation.shortName} called');
          print(data);
          return CalculateFormView(
            operation: matrixOperation.operation,
            singleOperation: matrixOperation.singleOperation,
            needMatrix: matrixOperation.needMatrix,
            data: data,
            callback: (String matrix_1, String matrix_2, double scalar_2, Operation operation, bool showSteps) {
              Navigator.pop(context);
              showResult(matrix_1, matrix_2, scalar_2, operation, data, showSteps, precision, parentContext);
            },
          );
        }
    );
  }

  /// Calculate the result of the operation and then save it to our default resultMatrix ("ans" by default).
  String calculate(String matrix_1, String matrix_2, double scalar_2, Operation operation, Map<String, Matrix> data, int precision) {
    Matrix m1 = matrix_1 == null ? null : data[matrix_1];
    Matrix m2 = matrix_2 == null ? null : data[matrix_2];
    double s = scalar_2;
    print('Performing calculation of: Matrix $matrix_1 {$operation} Matrix $matrix_2 | double $scalar_2 or int ${scalar_2?.toInt()}');
    /// Calculate matrix result. Contains the matrix needed to display the history state as well.
    /// Meanwhile output contains the relevant result (Needed in case of determinant because the output is a number).
    /// This also helps in the implementation for displaying it to user.
    String output;
    Matrix result = this.calculateHandler[operation](m1, m2, s);
    if (operation == Operation.DET) {
      output = r"$$\textbf{Multiplying Diagonals}$$ $$""${result.det().toStringAsPrecision(precision)}"r"$$";
    }
    else {
      output = r"$$\textbf{Final Result}$$" + result.getMathJexText(parentheses: "square", precision: precision);
    }
    //  Save intermediate result to a matrix called result just like in matlab.
    this.setState(() {
      data[widget.resultMatrixName] = result;
    });
    return output;
  }

  void showResult(String matrix_1, String matrix_2, double scalar_2, Operation operation, Map<String, Matrix> data, bool showSteps, int precision, BuildContext parentContext) {
    String output = calculate(matrix_1, matrix_2, scalar_2, operation, data, precision);
    Matrix result = data[widget.resultMatrixName];
    String label = '${operation.fullName} ($matrix_1' + (matrix_2 == null ? (scalar_2 == null ? '' : ', $scalar_2') : ', $matrix_2') + ')';
    print(result.historyMessage);
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        if (!showSteps)
          return MatrixLatex(
            label: label, 
            latexText: output,
            matrixRow: data[widget.resultMatrixName].row,
            actions: <Widget>[
              FlatButton(
                child: Text('Save'),
                onPressed: () {
                  showNewDialog(
                    parentContext: parentContext, 
                    context: context, 
                    builder: (BuildContext context) => saveMatrixDialog(this._formKey, result, context)
                  );
                }
              )
            ],
          );
        return MatrixLatex(
          label: label, 
          latexText: result.getHistoryText(stepsOnly: true, precision: widget.precision) + output,
          matrixRow: data[widget.resultMatrixName].row,
          actions: <Widget>[
            FlatButton(
              child: Text('Save'),
              onPressed: () {
                showNewDialog(
                  parentContext: parentContext, 
                  context: context, 
                  builder: (BuildContext context) => saveMatrixDialog(this._formKey, result, context)
                );
              }
            )
          ]
        );
      }
    );
  }

  Widget saveMatrixDialog(GlobalKey<FormState> key, Matrix out, BuildContext context) {
    return AlertDialog(
      actions: <Widget>[
        FlatButton(
          child: Text('Confirm'),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              Navigator.pop(context);
            }
          },
        )
      ],
      content: SingleChildScrollView(
        child: Form(
          key: key,
          child: Column(
            children: <Widget>[
              Text('Matrix Name'),
              TextFormField(
                maxLength: 10,
                keyboardType: TextInputType.text,
                validator: (String name) {
                  if (name.isEmpty) 
                    return 'Please enter new matrix name';
                  else if (widget.data.containsKey(name)) 
                    return 'Matrix $name already exists';
                  return null;
                },
                onSaved: (String name) {
                  if (_formKey.currentState.validate()) {
                    this.setState(() {
                      widget.data[name] = out;
                    });
                  }
                },
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}