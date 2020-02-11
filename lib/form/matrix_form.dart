import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrix_calculator/classes/matrix.dart';
import 'package:numberpicker/numberpicker.dart';

class MatrixAddForm extends StatefulWidget {
  final Matrix matrix;
  MatrixAddForm({Key key, this.matrix}): super(key: key);
  @override
  _MatrixAddFormState createState() => _MatrixAddFormState();
}

class _MatrixAddFormState extends State<MatrixAddForm> {
  final _formKey = GlobalKey<FormState>();
  int _minSize = 1;
  int _maxSize = 20;
  int _curCol, _curRow;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
                title: TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.text_fields),
                      labelText: 'Matrix Name',
                      hintText: 'Enter a Unique variable name'
                  ),
                  maxLength: 10,
                ),
                subtitle: ListTile(
                    title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    NumberPicker.integer(
                        initialValue: this.widget.matrix.col,
                        minValue: _minSize,
                        maxValue: _maxSize,
                        onChanged: (value) =>
                            this.setState(() => _curCol = value)),
                    Text('X'),
                    NumberPicker.integer(
                      initialValue: this.widget.matrix.row,
                      minValue: _minSize,
                      maxValue: _maxSize,
                      onChanged: (value) => this.setState(() => _curRow = value),
                    )
                  ],
                ),
                subtitle: DataTable(
                  columns: List.from(List.generate(this.widget.matrix.col, (index) => index).map<DataColumn>((index) {
                    return DataColumn(
                      numeric: true,
                      tooltip: 'Column ${index.toString()}',
                      label: Text('Column ${index.toString()}')
                    );
                  })),
                  rows: List.from(widget.matrix.data.map<DataRow>((List<double> row) {
                    return DataRow(
                      selected: false,
                      cells: List.from(row.map<DataCell>((value) {
                        return DataCell(
                          Text(value.toString()),
                          showEditIcon: true,
                          onTap: () {
                            print('Editing');
                          },

                        );
                      })),
                    );
                  })),
                ),
                ),
                ),
          ],
        ));
  }
}
