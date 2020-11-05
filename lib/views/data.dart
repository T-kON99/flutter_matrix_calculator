import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../classes/matrix.dart';
import '../form/matrix_form.dart';
import '../dialog/matrix_latex.dart';

class MatrixItem {
  final String name;
  final Matrix matrix;
  MatrixItem({this.name, this.matrix});
}

class DataPage extends StatefulWidget {
  final Map<String, Matrix> data;
  final int precision;
  const DataPage({Key key, this.data, this.precision}) : super(key: key);
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  final GlobalKey<AnimatedListState> _matrixListKey = GlobalKey();
  final int _animateDuration_ms = 300;
  List<MatrixItem> matrixList;

  @override
  void initState() {
    super.initState();
    this.matrixList = widget.data.entries.map((entry) => MatrixItem(name: entry.key, matrix: entry.value)).toList();
  }

  int addMatrix(Matrix matrix, String name) {
    print('Before adding....');
    print(widget.data);
    int index;
    this.setState(() {
      index = this.widget.data.length;
      this.widget.data[name] = matrix;
      print('Added to MatrixMap Matrix $name: ${this.widget.data[name].data}');
      _matrixListKey.currentState.insertItem(index, duration: Duration(milliseconds: _animateDuration_ms));
    });
    return index;
  }

  void deleteMatrix(String key, int index, BuildContext parentContext) {
    this.setState(() {
      _matrixListKey.currentState.removeItem(index, 
        (context, animation) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Interval(0.5, 1.0)),
            child: SizeTransition(
              sizeFactor: CurvedAnimation(parent: animation, curve: Interval(0.0, 1.0)),
              axisAlignment: 0.0,
              child: _buildItem(key, index, parentContext),
            ),
          );
        },
        duration: Duration(milliseconds: _animateDuration_ms)
      );
      this.widget.data.remove(key);
    });
  }

  void editMatrix(String oldName, String name, Matrix matrix, int index, BuildContext parentContext) {
    deleteMatrix(oldName, index, parentContext);
    addMatrix(matrix, name);
  }

  Widget _buildItem(String key, int index, BuildContext parentContext) {
    return Center(
      child: Card(
        elevation: 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              key: ValueKey<String>(key),
              leading: Icon(Icons.add_box),
              title: Text(key),
              subtitle: Text(
                  '${widget.data[key]?.row}x${widget.data[key]?.col}'),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String matrixLatexText = this
                        .widget
                        .data[key]
                        .getMathJexText(
                            parentheses: "square",
                            precision: widget.precision
                        );
                      return MatrixLatex(
                        label: "Matrix $key",
                        latexText: matrixLatexText,
                        matrixRow: this.widget.data[key].row,
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Close'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      );
                    });
              },
              onLongPress: () {
                showLongPressDialog(context, key, parentContext, index);
              },
            )
          ],
        ),
      ),
    );
  }

  //  Helper function to show matrix dialog
  void showMatrixDialog({BuildContext context, Matrix matrix, String matrixName, BuildContext scaffoldContext, bool isNew, int index}) {
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
                existingMatrixNames: widget.data.keys,
                callback: (Matrix matrix, String name) {
                  if(isNew)
                    addMatrix(matrix, name);
                  else
                    editMatrix(matrixName, name, matrix, index, scaffoldContext);
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
        // if (widget.data.length == 0)
        //   return Center(
        //     child: Text('Add matrix by tapping [+] below'),
        //   );
        // else
          return AnimatedList(
            key: _matrixListKey,
            initialItemCount: widget.data.length,
            itemBuilder: (BuildContext context, int index, Animation animation) {
              String key = this.widget.data.keys.elementAt(index);
              return SizeTransition(
                axis: Axis.vertical,
                sizeFactor: animation,
                child: _buildItem(key, index, scaffoldContext)
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
            isNew: true
          );
        },
        elevation: 5,
        child: Icon(Icons.add),
        tooltip: "Add a new Matrix",
      ),
    );
  }

  void showLongPressDialog(BuildContext context, String key, BuildContext scaffoldContext, int index) {
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
                    scaffoldContext: scaffoldContext,
                    isNew: false,
                    index: index
                );
              },
            ),
            SimpleDialogOption(
              child: Text('Show History'),
              onPressed: () {
                Navigator.pop(context);
                showHistoryDialog(context, key, scaffoldContext, this.widget.data, index);
              }
            ),
            SimpleDialogOption(
              child: Text('Duplicate'),
              onPressed: () {
                Navigator.pop(context);
                duplicateDialog(context, key, scaffoldContext, this.widget.data, index);
              },
            ),
            SimpleDialogOption(
              child: Text('Delete'),
              onPressed: () {
                Navigator.pop(context);
                confirmDeleteDialog(context, key, scaffoldContext, index);
              },
            )
          ],
        );
      },
    );
  }

  void duplicateDialog(BuildContext context, String key, BuildContext scaffoldContext, Map<String, Matrix> data, int index) {
    String newMatrixName = key;
    while (data.containsKey(newMatrixName)) {
      newMatrixName = 'Copy_$newMatrixName';
    }
    this.setState(() {
      int newIndex = addMatrix(Matrix.copyFrom(data[key]), newMatrixName);
      Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
        content: Text('Duplicated Matrix $key to Matrix $newMatrixName'),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => this.setState(() => deleteMatrix(newMatrixName, newIndex, scaffoldContext)),
        ),
      ));
    });
  }

  void confirmDeleteDialog(BuildContext context, String key, BuildContext scaffoldContext, int index) {
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
                  deleteMatrix(key, index, scaffoldContext);
                  //  Display snackbar informing user, allowing user to undo
                  Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
                    content: Text('Deleted Matrix $key'),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () => this.setState(() => addMatrix(toDelete, key)),
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

  void showHistoryDialog(BuildContext context, String key, BuildContext scaffoldContext, Map<String, Matrix> data, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MatrixLatex(
          label: 'History of Matrix $key', 
          latexText: data[key].getHistoryText(),
          matrixRow: widget.data[key].row,
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.pop(context);
              }
            )
          ]
        );
      }
    );
  }
}