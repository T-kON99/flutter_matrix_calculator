import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrix_calculator/dialog/matrix_calculate.dart';
import '../classes/matrix.dart';
import '../operation.dart';
import '../dialog/matrix_latex.dart';

//  TODO: Finish this form. HALFWAY

class OperationFormView extends StatefulWidget {
  const OperationFormView({Key key, this.operation, this.data})
      : super(key: key);
  final MatrixOperation operation;
  final Map<String, Matrix> data;
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
        data: widget.data);
  }

  @override
  void dispose() {
    super.dispose();
  }
}

void calculate() {

}

//  TODO: FINISH THIS
void showResult(String matrix_1, String matrix_2, double scalar_2, String operation, Map<String, Matrix> data, BuildContext parentContext) {
  Matrix m1 = matrix_1 == null ? null : data[matrix_1];
  Matrix m2 = matrix_2 == null ? null : data[matrix_2];
  double s = scalar_2;
  print('From matrix_operation.dart');
  Map<String, Function> calculateHandler = {
    Operations.ADD.shortName: (Matrix m1, Matrix m2, double s) => m1 + m2,
    Operations.SUB.shortName: (Matrix m1, Matrix m2, double s) => m1 - m2,
    Operations.MATRIX_MULT.shortName: (Matrix m1, Matrix m2, double s) => m1 * m2,
    Operations.SCALAR_MULT.shortName: (Matrix m1, Matrix m2, double s) => m1 * s,
    Operations.POW.shortName: (Matrix m1, Matrix m2, double s) => m1 ^ s.toInt(),
    Operations.DET.shortName: (Matrix m1, Matrix m2, double s) => m1.det(),
    Operations.INV.shortName: (Matrix m1, Matrix m2, double s) => m1.inv(),
    Operations.RE.shortName: (Matrix m1, Matrix m2, double s) => m1.getRE(),
    Operations.RRE.shortName: (Matrix m1, Matrix m2, double s) => m1.getRRE(),
  };
  print('Performing calculation of: Matrix $matrix_1 {$operation} Matrix $matrix_2 | double $scalar_2 or int ${scalar_2?.toInt()}');
  Matrix result = calculateHandler[operation](m1, m2, s);
  print(result?.data);
  print(result?.historyMessage);
  showDialog(
    context: parentContext,
    builder: (BuildContext context) {
      return MatrixLatex(label: operation, latexText: result.getMathJexText(parentheses: "square"));
    }
  );
}

//  TODO
Card buildCard({Key key, MatrixOperation widget, BuildContext parentContext, Map<String, Matrix> data}) {
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
              tooltip: widget.title,
              onPressed: () => print('pressed'),
            );
          }),
          backgroundColor: widget.bgColor,
          title: Text(widget.title),
        ),
        ListTile(
          title: Text(widget.name),
          subtitle: Text('${widget.description}'),
          onTap: () => {
            showDialog(
                context: parentContext,
                builder: (BuildContext context) {
                  print('Operation ${widget.name} called');
                  print(data);
                  return CalculateFormView(
                    title: widget.title,
                    name: widget.name,
                    singleOperation: widget.singleOperation,
                    needMatrix: widget.needMatrix,
                    data: data,
                    callback: (String matrix_1, String matrix_2, double scalar_2, String operation) {
                      //  TODO: Chain this up back to calculator.dart(?) FINISH THIS TO SHOW RESULT OF OPERATION!
                      Navigator.pop(context);
                      showResult(matrix_1, matrix_2, scalar_2, operation, data, parentContext);
                    },
                  );
                })
          },
        )
      ],
    ),
  );
}
