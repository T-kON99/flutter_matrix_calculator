import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrix_calculator/dialog/matrix_calculate.dart';
import '../classes/matrix.dart';
import '../presentation/custom_icon_icons.dart' show CustomIcon;

//  TODO: Finish this form. HALFWAY
class MatrixOperation {
  const MatrixOperation(this.title, this.icon, this.color, this.bgColor,
      this.singleOperation, this.needMatrix, this.name, this.description);
  final String title;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final bool singleOperation;
  final bool needMatrix;
  final String name;
  final String description;
}

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
    MatrixOperation widget,
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
                    needMatrix: widget.needMatrix,
                    data: data
                  );
                })
          },
        )
      ],
    ),
  );
}

//  TODO: Give appropriate icons
final List<MatrixOperation> MatrixOperations = <MatrixOperation>[
  MatrixOperation(
      'Addition',
      CustomIcon.plus,
      Colors.yellow,
      Colors.green,
      false,
      true,
      'add',
      'Perform addition of Matrix 1 + Matrix 2. Dimension of both Matrixes must be exactly the same'),
  MatrixOperation(
      'Substraction',
      CustomIcon.minus,
      Colors.yellow,
      Colors.blue,
      false,
      true,
      'sub',
      'Perform subtraction of Matrix 1 - Matrix 2. Dimension of both Matrixes must be exactly the same'),
  MatrixOperation(
      'Matrix Multiplication',
      CustomIcon.asterisk,
      Colors.green[200],
      Colors.red,
      false,
      true,
      'mmult',
      'Perform multiplication of a Matrix 1 * Matrix 2. Dimension of both Matrixes must obey m x n * n x k.'),
  MatrixOperation(
      'Scalar Multiplication',
      CustomIcon.cancel,
      Colors.green[200],
      Colors.cyan,
      false,
      false,
      'smult',
      'Perform scalar multiplication of Matrix * Decimal Number'),
  MatrixOperation(
      'Power',
      CustomIcon.angle_up,
      Colors.blue[300],
      Colors.yellow[700],
      false,
      false,
      'pow',
      'Perform power operation. Example would be (Matrix 1)^(Integer Power). A power of -1 will be calculating its inverse.'),
  MatrixOperation(
      'Determinant',
      CustomIcon.eject,
      Colors.blue[300],
      Colors.orange,
      true,
      false,
      'det',
      'Calculate the determinant of the given Matrix. Given Matrix must be a square Matrix'),
  MatrixOperation(
      'Inverse',
      CustomIcon.info,
      Colors.green[100],
      Colors.pink,
      true,
      false,
      'inv',
      'Calculate the inverse of the given Matrix. Given Matrix must be a square Matrix'),
  MatrixOperation(
      'Row Echelon Form',
      CustomIcon.yandex,
      Colors.teal[200],
      Colors.teal,
      true,
      false,
      'RE',
      'Calculate the Row Echelon Form (RE) of the given Matrix.'),
  MatrixOperation(
      'Reduced Row Echelon Form',
      CustomIcon.calc,
      Colors.deepPurple[200],
      Colors.purple,
      true,
      false,
      'RRE',
      'Calculate the Reduced Row Echelon Form (RRE) of the given Matrix')
];
