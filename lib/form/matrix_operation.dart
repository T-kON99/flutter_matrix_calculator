import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrix_calculator/dialog/matrix_calculate.dart';
import '../classes/matrix.dart';
import '../operation.dart';
import '../dialog/matrix_latex.dart';

//  TODO: Finish this form. HALFWAY

class OperationFormView extends StatefulWidget {
  const OperationFormView({Key key, this.operation, this.data, this.precision})
      : super(key: key);
  final MatrixOperation operation;
  final Map<String, Matrix> data;
  final int precision;
  @override
  _OperationFormViewState createState() => _OperationFormViewState();
}

class _OperationFormViewState extends State<OperationFormView> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildCard(
      key: _formKey,
      widget: widget.operation,
      parentContext: context,
      data: widget.data,
      precision: widget.precision,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

void calculate() {

}

//  TODO: FINISH THIS
void showResult(String matrix_1, String matrix_2, double scalar_2, Operation operation, Map<String, Matrix> data, bool showSteps, int precision, BuildContext parentContext) {
  Matrix m1 = matrix_1 == null ? null : data[matrix_1];
  Matrix m2 = matrix_2 == null ? null : data[matrix_2];
  double s = scalar_2;
  print('From matrix_operation.dart');
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
  };
  print('Performing calculation of: Matrix $matrix_1 {$operation} Matrix $matrix_2 | double $scalar_2 or int ${scalar_2?.toInt()}');
  /// Calculate matrix result. Contains the matrix needed to display the history state as well.
  /// Meanwhile output contains the relevant result (Needed in case of determinant because the output is a number).
  /// This also helps in the implementation for displaying it to user.
  String output;
  Matrix result = calculateHandler[operation](m1, m2, s);
  if (operation == Operation.DET) {
    output = r"$$" "${result.det().toStringAsPrecision(precision)}" r"$$";
  }
  else {
    output = result.getMathJexText(parentheses: "square", precision: precision);
  }
  showDialog(
    context: parentContext,
    builder: (BuildContext context) {
      return MatrixLatex(label: '${operation.shortName}($matrix_1, $matrix_2 | $scalar_2)', latexText: output);
    }
  );
}

//  TODO
Card buildCard({Key key, MatrixOperation widget, BuildContext parentContext, Map<String, Matrix> data, int precision}) {
  return Card(
    elevation: 3,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppBar(
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
              icon: Icon(widget.icon),
              color: widget.color,
              tooltip: widget.operation.fullName,
              onPressed: () => print('pressed'),
            );
          }),
          backgroundColor: widget.bgColor,
          title: Text(widget.operation.fullName),
        ),
        ListTile(
          title: Text(widget.operation.shortName),
          subtitle: Text('${widget.description}'),
          onTap: () => {
            showDialog(
                context: parentContext,
                builder: (BuildContext context) {
                  print('Operation ${widget.operation.shortName} called');
                  print(data);
                  return CalculateFormView(
                    operation: widget.operation,
                    singleOperation: widget.singleOperation,
                    needMatrix: widget.needMatrix,
                    data: data,
                    callback: (String matrix_1, String matrix_2, double scalar_2, Operation operation, bool showSteps) {
                      //  TODO: Chain this up back to calculator.dart(?) FINISH THIS TO SHOW RESULT OF OPERATION!
                      Navigator.pop(context);
                      showResult(matrix_1, matrix_2, scalar_2, operation, data, showSteps, precision, parentContext);
                    },
                  );
                })
          },
        )
      ],
    ),
  );
}
