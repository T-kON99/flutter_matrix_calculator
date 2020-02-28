import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../classes/matrix.dart';

class CalculatorPage extends StatefulWidget {
  final Map<String, Matrix> data;
  const CalculatorPage({Key key, this.data}) : super(key: key);
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: this.widget.data.length,
        itemBuilder: (BuildContext context, i) {
        return Text('ASDF');
      }),
    );
  }
}
