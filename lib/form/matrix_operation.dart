import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrix_calculator/dialog/matrix_calculate.dart';
import '../classes/matrix.dart';

//  TODO: Finish this form. HALFWAY
class MatrixOperationForm {
  const MatrixOperationForm(this.title, this.icon, this.color, this.bgColor,
      this.singleOperation, this.name, this.description);
  final String title;
  final IconData icon;
  final MaterialColor color;
  final MaterialColor bgColor;
  final bool singleOperation;
  final String name;
  final String description;
}

class OperationFormView extends StatefulWidget {
  const OperationFormView({Key key, this.operation, this.data})
      : super(key: key);
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
    return buildCard(
        key: _formKey,
        widget: widget.operation,
        context: context,
        data: widget.data);
  }

  @override
  void dispose() {
    super.dispose();
  }
}

//  TODO
Card buildCard(
    {Key key,
    MatrixOperationForm widget,
    BuildContext context,
    Map<String, Matrix> data}) {
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
          //  TODO: BUILD DIALOG
          onTap: () => {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  print('Operation ${widget.name} called');
                  print(data);
                  return CalculateFormView(
                    title: widget.title,
                    name: widget.name,
                    singleOperation: widget.singleOperation,
                    data: data
                  );
                })
          },
        )
      ],
    ),
  );
}

const List<MatrixOperationForm> MatrixOperations = <MatrixOperationForm>[
  MatrixOperationForm(
      'Addition',
      Icons.add_box,
      Colors.green,
      Colors.green,
      false,
      'add',
      'Perform addition of Matrix 1 + Matrix 2. Dimension of both Matrixes must be exactly the same'),
  MatrixOperationForm(
      'Substraction',
      Icons.question_answer,
      Colors.green,
      Colors.blue,
      false,
      'sub',
      'Perform subtraction of Matrix 1 - Matrix 2. Dimension of both Matrixes must be exactly the same'),
  MatrixOperationForm(
      'Matrix Multiplication',
      Icons.question_answer,
      Colors.green,
      Colors.red,
      false,
      'mmult',
      'Perform multiplication of a Matrix 1 * Matrix 2. Dimension of both Matrixes must obey m x n * n x k.'),
  MatrixOperationForm(
      'Scalar Multiplication',
      Icons.question_answer,
      Colors.green,
      Colors.cyan,
      false,
      'smult',
      'Perform scalar multiplication of Matrix * Decimal Number'),
  MatrixOperationForm(
      'Power',
      Icons.question_answer,
      Colors.green,
      Colors.yellow,
      true,
      'pow',
      'Perform power operation. Example would be (Matrix 1)^(Integer Power). A power of -1 will be calculating its inverse.'),
  MatrixOperationForm(
      'Determinant',
      Icons.question_answer,
      Colors.green,
      Colors.orange,
      true,
      'det',
      'Calculate the determinant of the given Matrix. Given Matrix must be a square Matrix'),
  MatrixOperationForm(
      'Inverse',
      Icons.question_answer,
      Colors.green,
      Colors.pink,
      true,
      'inv',
      'Calculate the inverse of the given Matrix. Given Matrix must be a square Matrix'),
  MatrixOperationForm(
      'Row Echelon Form',
      Icons.question_answer,
      Colors.green,
      Colors.teal,
      true,
      'RE',
      'Calculate the Row Echelon Form (RE) of the given Matrix.'),
  MatrixOperationForm(
      'Reduced Row Echelon Form',
      Icons.question_answer,
      Colors.green,
      Colors.purple,
      true,
      'RRE',
      'Calculate the Reduced Row Echelon Form (RRE) of the given Matrix')
];
