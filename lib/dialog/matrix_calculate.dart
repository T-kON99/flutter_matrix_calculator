import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrix_calculator/classes/matrix.dart';

class CalculateFormView extends StatefulWidget {
  final String name;
  final String title;
  final bool singleOperation;
  final Map<String, Matrix> data;
  const CalculateFormView({Key key, this.title, this.name, this.singleOperation, this.data})
      : super(key: key);
  @override
  _CalculateFormViewState createState() => _CalculateFormViewState();
}

class _CalculateFormViewState extends State<CalculateFormView> {
  String matrix_1;
  String matrix_2;
  Float scalar_2;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        titlePadding: EdgeInsets.all(0),
        contentPadding: EdgeInsets.all(0),
        content: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppBar(
              title: Text(widget.title),
              centerTitle: true,
            ),
            ...buildDropDownMatrix(),
          ],
        )));
  }

  //  TODO: Filter the selectable matrixes based on the operations. Ex: Addition -> row_1 == row_2. Multiplication -> col_1 == row_1
  List<Widget> buildDropDownMatrix() {
    Map<String, Matrix> filteredMap_1 = Map.from(widget.data)..removeWhere((key, value) => !operationHandler(key, matrix_2, widget.name));
    List<Widget> result = <Widget>[
      Text('First Matrix'),
      DropdownButton<String>(
        items: filteredMap_1.entries.map((MapEntry entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Text(entry.key),
          );
        }).toList(),
        onChanged: (newValue) {
          this.setState(() {
            matrix_1 = newValue;
          });
        },
        autofocus: true,
        value: matrix_1,
        hint: Text('Select matrix'),
        disabledHint: Text('-'),
      )
    ];
    if (!widget.singleOperation) {
      //  TODO: Finish this filtering
      Map<String, Matrix> filteredMap_2 = Map.from(widget.data)..removeWhere((key, value) => !operationHandler(matrix_1, key, widget.name));
      List<Widget> secondResult = [
        Text('Second Matrix'),
        DropdownButton<String>(
          items: filteredMap_2.entries.map((MapEntry entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Text(entry.key),
            );
          }).toList(),
          onChanged: (newValue) {
            this.setState(() {
              matrix_2 = newValue;
            });
          },
          value: matrix_2,
          hint: Text('Select a corresponding Matrix'),
          autofocus: true,
          disabledHint: Text('-'),
        )
      ];
      result.addAll(secondResult);
    }
    return result;
  }

  /// Helper function to filter correct size matrixes given the operation
  bool operationHandler(String givenMatrix, String otherMatrix, String operation) {
    if ((!widget.data.containsKey(givenMatrix) || !widget.data.containsKey(otherMatrix)) && !widget.singleOperation) {
      return true;
    }
    Map<String, Function> handler = {
      "add": () => widget.data[givenMatrix].row == widget.data[otherMatrix].row && widget.data[givenMatrix].col == widget.data[otherMatrix].col,
      "sub": () => widget.data[givenMatrix].row == widget.data[otherMatrix].row && widget.data[givenMatrix].col == widget.data[otherMatrix].col,
      "mmult": () => widget.data[givenMatrix].col == widget.data[otherMatrix].row,
      "smult": () => true,
      "pow": () => widget.data[givenMatrix].isSquare(),
      "det": () => widget.data[givenMatrix].isSquare(),
      "inv": () => widget.data[givenMatrix].isSquare(),
      "RE": () => true,
      "RRE": () => true,
    };
    final bool validity = handler[operation]();
    print('Checking validity of matrix operation: $givenMatrix $operation $otherMatrix -> $validity');
    return validity;
  }
}
