import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../classes/matrix.dart';
import '../form/matrix_form.dart';

class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  Map<String, Matrix> data = {};

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
                          title: Text('${key}'),
                          subtitle: Text('${data[key].row}x${data[key].col}'),
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
                  content: SingleChildScrollView(
                    child: MatrixAddForm(
                      matrix: Matrix(data: [
                        [0]
                      ]),
                      callback: (Matrix matrix, String name) {
                        this.setState(() => this.data[name] = matrix);
                        print('Added to MatrixMap: ${this.data[name].data}');
                      },
                    ),
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
