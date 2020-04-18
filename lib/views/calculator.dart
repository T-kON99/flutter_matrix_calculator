import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../classes/matrix.dart';

class CalculatorPage extends StatefulWidget {
  final Map<String, Matrix> data;
  const CalculatorPage({Key key, this.data}) : super(key: key);
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

//  TODO: IMPLEMENT CALCULATOR PAGE
//  1.  Have preset of functions available which user can select (Ex: Add, Multiplication, Inverse, GE, RE, RRE)
//  2.  If (1) finishes, maybe let another field which is "Custom". This will behave like MATLAB (Ex: Users able to input: det(mat(A)*mat(B))
class _CalculatorPageState extends State<CalculatorPage> {
  List<String> actions = ["add"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: this.actions.length,
        itemBuilder: (BuildContext context, i) {
          return Center(
            child: Card(
              child: Text(this.actions[i]),
            ),
          );
      }),
    );
  }
}
