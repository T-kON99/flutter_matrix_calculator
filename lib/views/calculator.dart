import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../classes/matrix.dart';
import '../form/matrix_operation.dart';
import '../operation.dart';

class CalculatorPage extends StatefulWidget {
  final Map<String, Matrix> data;
  final int precision;
  const CalculatorPage({Key key, this.data, this.precision}) : super(key: key);
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

//  TODO: FINISH IMPLEMENTING CALCULATOR PAGE
//  1.  Have preset of functions available which user can select (Ex: Add, Multiplication, Inverse, GE, RE, RRE)
//  2.  If (1) finishes, maybe let another field which is "Custom". This will behave like MATLAB (Ex: Users able to input: det(mat(A)*mat(B))
class _CalculatorPageState extends State<CalculatorPage> {
  final List<MatrixOperation> operations = MatrixOperations;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: this.operations.length,
          itemBuilder: (BuildContext context, i) {
            return Center(
              child: Card(
                child: OperationFormView(
                  data: widget.data,
                  operation: this.operations[i],
                  precision: widget.precision,
                ),
              ),
            );
          }),
    );
  }
}
