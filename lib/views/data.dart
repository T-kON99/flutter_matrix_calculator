import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../classes/matrix.dart';
import '../form/matrix_form.dart';
import '../dialog/matrix_latex.dart';

class DataPage extends StatefulWidget {
  final Map<String, Matrix> data;
  final int precision;
  const DataPage({Key key, this.data, this.precision}) : super(key: key);
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  //  Helper function to show matrix dialog
  void showMatrixDialog({BuildContext context, Matrix matrix, String matrixName, BuildContext scaffoldContext}) {
    Matrix oldMatrix = Matrix.copyFrom(matrix);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.all(0),
            content: SingleChildScrollView(
              child: MatrixAddForm(
                matrix: matrix,
                matrixName: matrixName,
                callback: (Matrix matrix, String name) {
                  this.setState(() {
                    //  TODO: SNACKBAR HERE
                    if (name != matrixName) {
                      print('Updated Matrix $matrixName to $name');
                      this.widget.data.remove(matrixName);
                    }
                    this.widget.data[name] = matrix;
                  });
                  if (scaffoldContext != null) {
                    Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
                      content: Text('Updated Matrix $name'),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                        label: "Undo",
                        onPressed: () => this.setState(() {
                          this.widget.data.remove(name);
                          if (matrixName.isNotEmpty && matrixName != null)
                            this.widget.data[matrixName] = oldMatrix;
                        }),
                      ),
                      // backgroundColor: Colors.blue,
                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                    ));
                  }
                  print('Added to MatrixMap Matrix $name: ${this.widget.data[name].data}');
                },
              ),
            ),
            contentPadding: EdgeInsets.all(0),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        BuildContext scaffoldContext = context;
        if (widget.data.length == 0)
          return Center(
            child: Text('Add matrix by tapping [+] below'),
          );
        else
          return ListView.builder(
            itemCount: widget.data.length,
            itemBuilder: (BuildContext context, i) {
              String key = this.widget.data.keys.elementAt(i);
              return Center(
                child: Card(
                  elevation: 3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.add_box),
                        title: Text(key),
                        subtitle: Text(
                            '${widget.data[key].row}x${widget.data[key].col}'),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                String matrixLatexText = this
                                  .widget
                                  .data[key]
                                  .getMathJexText(
                                      parentheses: "square",
                                      precision: widget.precision);
                                return MatrixLatex(
                                  label: "Matrix $key",
                                  latexText: matrixLatexText
                                );
                              });
                        },
                        onLongPress: () {
                          showLongPressDialog(context, key, scaffoldContext);
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMatrixDialog(
            context: context,
            matrix: Matrix(
              data: [
                [0]
              ],
            ),
          );
        },
        elevation: 5,
        child: Icon(Icons.add),
        tooltip: "Add a new Matrix",
      ),
    );
  }

  void showLongPressDialog(BuildContext context, String key, BuildContext scaffoldContext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Matrix $key'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Edit'),
              onPressed: () {
                Navigator.pop(context);
                showMatrixDialog(
                    context: context,
                    matrix: this.widget.data[key],
                    matrixName: key,
                    scaffoldContext: scaffoldContext
                );
              },
            ),
            SimpleDialogOption(
              child: Text('Delete'),
              onPressed: () {
                Navigator.pop(context);
                confirmDeleteDialog(context, key, scaffoldContext);
              },
            )
          ],
        );
      },
    );
  }

  void confirmDeleteDialog(BuildContext context, String key, BuildContext scaffoldContext) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Delete'),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Matrix toDelete = this.widget.data[key];
                  this.setState(() => this.widget.data.remove(key));
                  //  Display snackbar informing user, allowing user to undo
                  Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
                    content: Text('Deleted Matrix $key'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () => this.setState(() => this.widget.data[key] = toDelete),
                    ),
                    // backgroundColor: Colors.blue,
                    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  ));
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }
}
