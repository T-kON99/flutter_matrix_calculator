import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../classes/matrix.dart';

//  TODO: Finish this form.
class MatrixOperationForm {
  const MatrixOperationForm(this.title, this.icon, this.color, this.singleOperation, this.name);
  final String title;
  final IconData icon;
  final MaterialColor color;
  final bool singleOperation;
  final String name;
}

class OperationFormView extends StatefulWidget {
  const OperationFormView({Key key, this.operation, this.data}) : super(key: key);
  final MatrixOperationForm operation;
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
    //  TODO: Implement below operators:
    //  Add, Multiplication, Power, Inverse, Determinant, GE/RE, RRE
    switch(widget.operation.name) {
      case "add":
        return Form(
          key: _formKey,
          child: Column(),
        );
      case "mult":
        return Text('Mult');
      case "pow":
        return Text('Pow');
      case "det":
        return Text('Det');
      case "inv":
        return Text('Inv');
      case "RE":
        return Text('Row Echelon');
      case "RRE":
        return Text('Reduced Row Echelon');
      default:
        return Text('Default');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

//  TODO
Form buildForm({Key key}) {
  return Form(
    key: key,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppBar(),
        Card()
      ],
    ),
  );
}