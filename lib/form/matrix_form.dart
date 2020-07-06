import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matrix_calculator/classes/matrix.dart';
import 'package:numberpicker/numberpicker.dart';

typedef void MatrixCallback(Matrix matrix, String name);

class MatrixAddForm extends StatefulWidget {
  final Matrix matrix;
  final MatrixCallback callback;
  final String matrixName;

  MatrixAddForm({Key key, this.matrix, this.callback, this.matrixName})
      : super(key: key);
  @override
  _MatrixAddFormState createState() => _MatrixAddFormState();
}

class _MatrixAddFormState extends State<MatrixAddForm> {
  final _formKey = GlobalKey<FormState>();
  final matrixNameController = TextEditingController();
  int _minSize = 1;
  int _maxSize = 20;

  @override
  void dispose() {
    matrixNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    matrixNameController.text = widget.matrixName;
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
              title: this.widget.matrixName == null
                  ? Text('Add Matrix')
                  : Text('Editing Matrix'),
              centerTitle: true,
              actions: <Widget>[
                Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: Icon(Icons.save),
                      tooltip: 'Save Matrix',
                      onPressed: () {
                        print('Validating...');
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          print('Saving Matrix ${matrixNameController.text}');
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
                  title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Size',
                          textScaleFactor: 0.9,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //  TODO: Better UI
                            Theme(
                                data: theme.copyWith(
                                    //  Highlighted text color
                                    accentColor: Colors.blue,
                                    textTheme: theme.textTheme.copyWith(
                                      headline5: theme.textTheme.headline5
                                          .copyWith(), //  Other styles for highlighted
                                      bodyText2: theme.textTheme.headline5.copyWith(
                                        fontSize: 10,
                                      ), // Not highlighted styles
                                    )),
                                child: NumberPicker.integer(
                                  initialValue: this.widget.matrix.row,
                                  minValue: _minSize,
                                  maxValue: _maxSize,
                                  itemExtent: 25,
                                  onChanged: (value) => this.setState(() {
                                    this.widget.matrix.zeroFillResize(
                                        row: value,
                                        col: this.widget.matrix.col);
                                  }),
                                )),
                            Text('X'),
                            Theme(
                                data: theme.copyWith(
                                    //  Highlighted text color
                                    accentColor: Colors.blue,
                                    textTheme: theme.textTheme.copyWith(
                                      headline5: theme.textTheme.headline5
                                          .copyWith(), //  Other styles for highlighted
                                      bodyText2: theme.textTheme.headline5.copyWith(
                                        fontSize: 10,
                                      ), // Not highlighted styles
                                    )),
                                child: NumberPicker.integer(
                                  initialValue: this.widget.matrix.col,
                                  minValue: _minSize,
                                  maxValue: _maxSize,
                                  itemExtent: 25,
                                  onChanged: (value) => this.setState(() {
                                    this.widget.matrix.zeroFillResize(
                                        row: this.widget.matrix.row,
                                        col: value);
                                  }),
                                )),
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                        )
                      ]),
                  subtitle: SingleChildScrollView(
                      padding: EdgeInsets.all(0),
                      scrollDirection: Axis.horizontal,
                      child: Center(
                        child: buildMatrixDataTable(),
                      ))),
            ),
          ],
        ));
  }

  DataTable buildMatrixDataTable() {
    return DataTable(
        columnSpacing: 10,
        columns: List.from(
            List.generate(this.widget.matrix.col, (index) => index)
                .map<DataColumn>((index) {
          return DataColumn(
              numeric: true,
              //  Show it in 1-index based for human readability
              tooltip: 'Column ${(index + 1).toString()}',
              label: Text(
                'Column ${(index + 1).toString()}',
                textScaleFactor: 1.25,
              ));
        })),
        rows: this
            .widget
            .matrix
            .data
            .asMap()
            .map((int rowIndex, List<double> row) {
              return MapEntry(
                rowIndex,
                DataRow(
                    selected: false,
                    cells: row
                        .asMap()
                        .map((int colIndex, double value) {
                          var _controller = TextEditingController(text: value.toString());
                          return MapEntry(
                              colIndex,
                              DataCell(
                                TextFormField(
                                  controller: _controller,
                                  keyboardType: TextInputType.number,
                                  // initialValue: value.toString(),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Enter a value';
                                    } else if (double.tryParse(value) == null) {
                                      return 'Enter a valid number';
                                    }
                                    return null;
                                  },
                                  onTap: () => {
                                    _controller.clear()
                                  },
                                  onChanged: (value) => {
                                    _formKey.currentState.validate()
                                  },
                                  onSaved: (value) {
                                    if (_formKey.currentState.validate()) {
                                      this.setState(() =>
                                          this.widget.matrix.data[rowIndex]
                                              [colIndex] = double.parse(value));
                                    }
                                  },
                                ),
                                showEditIcon: true,
                                placeholder: true,
                              ));
                        })
                        .values
                        .toList()),
              );
            })
            .values
            .toList());
  }
}
