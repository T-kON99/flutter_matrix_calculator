import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../classes/matrix.dart';
import '../form/matrix_form.dart';

class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  List<Matrix> data = [];
  final _formKey = GlobalKey<FormState>();
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
                return Center(
                  child: Card(
                    elevation: 3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.add_box),
                          title: Text('Matrix ${i + 1}'),
                          subtitle: Text('${data[i].row}x${data[i].col}'),
                          // TODO onLongPress
                          onLongPress: () => print('Editing Matrix'),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
      // TODO floatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  titlePadding: EdgeInsets.all(0),
                  title: AppBar(
                    leading: Builder(
                      builder: (BuildContext context) {
                        return IconButton(
                          icon: Icon(Icons.arrow_back),
                          tooltip: 'Back',
                          onPressed: () => Navigator.pop(context),
                        );
                      },
                    ),
                    title: Text('Add Matrix'),
                    centerTitle: true,
                    actions: <Widget>[
                      Builder(
                        builder: (BuildContext context) {
                          return IconButton(
                            icon: Icon(Icons.save),
                            tooltip: 'Save Matrix',
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          );
                        },
                      )
                    ],
                  ),
                  content: SingleChildScrollView(        
                    child: MatrixAddForm(
                        matrix: Matrix(data: [
                      [0]
                    ])),
                  ),
                  contentPadding: EdgeInsets.all(0),
                );
              });
        },
        elevation: 5,
        child: Icon(Icons.add),
      ),
    );
  }
}
