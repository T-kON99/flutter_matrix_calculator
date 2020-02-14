import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrix_calculator/classes/matrix.dart';
import 'package:numberpicker/numberpicker.dart';

typedef void MatrixCallback(Matrix matrix, String name);

class MatrixAddForm extends StatefulWidget {
  final Matrix matrix;
  final MatrixCallback callback;

  MatrixAddForm({Key key, this.matrix, this.callback}) : super(key: key);
  @override
  _MatrixAddFormState createState() => _MatrixAddFormState();
}

class _MatrixAddFormState extends State<MatrixAddForm> {
  final _formKey = GlobalKey<FormState>();
  final matrixNameController = TextEditingController();
  int _minSize = 1;
  int _maxSize = 20;
  int _curCol, _curRow;

  @override
  void dispose() {
    matrixNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppBar(
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
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          this.widget.callback(
                              this.widget.matrix, matrixNameController.text);
                          Navigator.pop(context);
                        }
                      },
                    );
                  },
                )
              ],
            ),
            ListTile(
              title: TextFormField(
                controller: matrixNameController,
                decoration: InputDecoration(
                    icon: Icon(Icons.text_fields),
                    labelText: 'Matrix Name',
                    hintText: 'Enter a Unique variable name'),
                maxLength: 10,
                validator: (name) {
                  if (name.isEmpty) {
                    return 'Please enter matrix name';
                  }
                  return null;
                },
              ),
              subtitle: ListTile(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    NumberPicker.integer(
                      initialValue: this.widget.matrix.col,
                      minValue: _minSize,
                      maxValue: _maxSize,
                      onChanged: (value) => this.setState(() {
                        _curCol = value;
                      }),
                    ),
                    Text('X'),
                    NumberPicker.integer(
                      initialValue: this.widget.matrix.row,
                      minValue: _minSize,
                      maxValue: _maxSize,
                      onChanged: (value) =>
                          this.setState(() => _curRow = value),
                    )
                  ],
                ),
                subtitle: DataTable(
                    columns: List.from(
                        List.generate(this.widget.matrix.col, (index) => index)
                            .map<DataColumn>((index) {
                      return DataColumn(
                          numeric: true,
                          tooltip: 'Column ${index.toString()}',
                          label: Text('Column ${index.toString()}'));
                    })),
                    rows: widget.matrix.data
                        .asMap()
                        .map((int colIndex, List<double> row) {
                          return MapEntry(
                            colIndex,
                            DataRow(
                                selected: false,
                                cells: row
                                    .asMap()
                                    .map((int rowIndex, double value) {
                                      return MapEntry(
                                          rowIndex,
                                          DataCell(
                                            TextFormField(
                                              initialValue: value.toString(),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Enter a value';
                                                } else if (double.tryParse(
                                                        value) ==
                                                    null) {
                                                  return 'Enter a valid number';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                if(_formKey.currentState.validate()) {
                                                  this.widget.matrix.data[rowIndex][colIndex] = double.parse(value);
                                                }
                                              },
                                            ),
                                            showEditIcon: true,
                                            placeholder: true,
                                            onTap: () {
                                              print('Editing');
                                            },
                                          ));
                                    })
                                    .values
                                    .toList()),
                          );
                        })
                        .values
                        .toList()),
              ),
            ),
          ],
        ));
  }
}
