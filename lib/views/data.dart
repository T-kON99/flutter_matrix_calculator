import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import '../classes/matrix.dart';
import '../form/matrix_form.dart';

class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  Map<String, Matrix> data = {};

  //  Helper function to show matrix dialog
  void showMatrixDialog(
      {BuildContext context, Matrix matrix, String matrixName}) {
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
                    if (name != matrixName) {
                      print('Updated Matrix $matrixName to $name');
                      this.data.remove(matrixName);
                    }
                    this.data[name] = matrix;
                  });
                  print(
                      'Added to MatrixMap Matrix $name: ${this.data[name].data}');
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
      body: data.length == 0
          ? Center(
              child: Text('Add matrix by tapping [+] below'),
            )
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, i) {
                String key = this.data.keys.elementAt(i);
                return Center(
                  child: Card(
                    elevation: 3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.add_box),
                          title: Text(key),
                          subtitle: Text('${data[key].row}x${data[key].col}'),
                          //  TODO: Add onTap function to display matrix content in latex form.
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Matrix $key'),
                                    content: TeXView(
                                      teXHTML:
                                          this.data[key].getMathJexText(parentheses: "square"),
                                      renderingEngine: RenderingEngine
                                          .Katex, // Katex for fast render and MathJax for quality render.
                                      onRenderFinished: (height) {
                                        print("Widget Height is : $height");
                                      },
                                      onPageFinished: (string) {
                                        print("Page Loading finished");
                                      },
                                    ),
                                  );
                                });
                          },
                          onLongPress: () {
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
                                            matrix: this.data[key],
                                            matrixName: key);
                                      },
                                    ),
                                    SimpleDialogOption(
                                      child: Text('Delete'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Confirm Delete'),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text('Yes'),
                                                    onPressed: () {
                                                      this.setState(() => this
                                                          .data
                                                          .remove(key));
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                              );
                                            });
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
      // TODO:  Fully implement adding matrix dialog
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMatrixDialog(
              context: context,
              matrix: Matrix(data: [
                [0]
              ]));
        },
        elevation: 5,
        child: Icon(Icons.add),
      ),
    );
  }
}
