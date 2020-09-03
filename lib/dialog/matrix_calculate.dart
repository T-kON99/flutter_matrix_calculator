import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matrix_calculator/classes/matrix.dart';
import '../operation.dart' show Operation, OperationsExt;

typedef void MatrixCalculateCallback(String matrix_1, String matrix_2, double scalar_2, Operation operation, bool showSteps);

class CalculateFormView extends StatefulWidget {
  final bool singleOperation;
  final bool needMatrix;
  final Map<String, Matrix> data;
  final MatrixCalculateCallback callback;
  final Operation operation;
  const CalculateFormView({Key key, this.operation, this.singleOperation, this.needMatrix, this.data, this.callback})
      : super(key: key);
  @override
  _CalculateFormViewState createState() => _CalculateFormViewState();
}

class _CalculateFormViewState extends State<CalculateFormView> {
    final _formKey = GlobalKey<FormState>();
  //  Our First Matrix
  String matrix_1;
  //  2nd can be either a matrix or a scalar depending on operation
  //  Ex: Addition -> Need other matrix. Scalar Multiplication -> Need a double
  String matrix_2;
  double scalar_2;
  bool showSteps = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        titlePadding: EdgeInsets.all(0),
        contentPadding: EdgeInsets.all(0),
        actions: <Widget>[
          //  TODO: Finish actions
          // FlatButton(
          //   child: Text('Chain'),
          //   onPressed: () {
          //     print('Do we need this? Chain!');
          //   },
          // ),
          FlatButton(
            child: Text('Calculate'),
            onPressed: () {
              print('Calculating!');
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                print('Requesting Operation $matrix_1 ${widget.operation.shortName} $matrix_2 or $scalar_2');
                this.widget.callback(matrix_1, matrix_2, scalar_2, widget.operation, showSteps);
              }
            },
          ),
        ],
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppBar(
                title: Text(widget.operation.fullName),
                centerTitle: true,
              ),
              Container(
                margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: buildChoose(),
                )
              ),
            ],
          )
        )));
  }

  DropdownButtonFormField<String> MatrixDropDown(Map<String, Matrix> filteredMap, Function onChanged, String initVal, String hintText, String validateText) {
    return DropdownButtonFormField<String>(
      items: filteredMap.entries.map((MapEntry entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(entry.key),
        );
      }).toList(),
      onChanged: (newValue) => onChanged(newValue),
      value: initVal,
      hint: Text(hintText),
      disabledHint: Text('No suitable Matrix'),
      validator: (String value) => value == null ? validateText : null,
      elevation: 2,
    );
  }

  List<Widget> buildChoose() {
    Map<String, Matrix> filteredMap_1 = Map.from(widget.data)..removeWhere((key, value) => !operationHandler(key, matrix_2, widget.operation));
    List<Widget> result = <Widget>[
      Text('First Matrix'),
      MatrixDropDown(filteredMap_1, (newValue) => this.setState(() { matrix_1 = newValue; }), matrix_1, "Select First Matrix", "Choose a Matrix"),
    ];
    //  Build 2nd Dropdown if it's not a single operation operator
    if (!widget.singleOperation) {
      List<Widget> secondResult;
      if (widget.needMatrix) {
        Map<String, Matrix> filteredMap_2 = Map.from(widget.data)..removeWhere((key, value) => !operationHandler(matrix_1, key, widget.operation));
        secondResult = <Widget>[
          SizedBox(height: 25,),
          Text('Second Matrix'),
          MatrixDropDown(filteredMap_2, (newValue) => this.setState(() { matrix_2 = newValue; }), matrix_2, "Select Second Matrix", "Choose a Matrix")
        ];
      }
      else {
        //  Other argument isn't a matrix but a scalar double.
        secondResult = <Widget>[
          SizedBox(height: 25,),
          Text('Scalar Value'),
          TextFormField(
            keyboardType: TextInputType.number,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Enter a value';
              } else if (double.tryParse(value) == null) {
                return 'Enter a valid number';
              } else if (widget.operation == Operation.POW && (double.tryParse(value) < -1)) {
                return 'Power must be bigger than -1';
              }
              return null;
            },
            onSaved: (value) {
              if (_formKey.currentState.validate()) {
                this.setState(() {
                  scalar_2 = double.parse(value);
                });
              }
            },
          ),
        ];
      }
      result.addAll(secondResult);
    }
    bool curShowSteps = showSteps;
    result.add(CheckboxListTile(
      value: showSteps,
      onChanged: (val) => this.setState(() { showSteps = !curShowSteps; }),
      title: Text('Show Steps', style: TextStyle(color: Colors.grey),),
    ));
    return result;
  }

  /// Helper function to filter correct size matrixes given the operation
  bool operationHandler(String givenMatrix, String otherMatrix, Operation operation) {
    if ((!widget.data.containsKey(givenMatrix) || !widget.data.containsKey(otherMatrix)) && !widget.singleOperation && widget.needMatrix) {
      return true;
    }
    Map<Operation, Function> handler = {
      Operation.ADD: () => widget.data[givenMatrix].row == widget.data[otherMatrix].row && widget.data[givenMatrix].col == widget.data[otherMatrix].col,
      Operation.SUB: () => widget.data[givenMatrix].row == widget.data[otherMatrix].row && widget.data[givenMatrix].col == widget.data[otherMatrix].col,
      Operation.MATRIX_MULT: () => widget.data[givenMatrix].col == widget.data[otherMatrix].row,
      Operation.SCALAR_MULT: () => true,
      Operation.POW: () => widget.data[givenMatrix].isSquare(),
      Operation.DET: () => widget.data[givenMatrix].isSquare(),
      Operation.INV: () => widget.data[givenMatrix].isSquare() && widget.data[givenMatrix].det() != 0,
      Operation.RE: () => true,
      Operation.RRE: () => true,
    };
    final bool validity = handler[operation]();
    print('Checking validity of matrix operation: $givenMatrix $operation $otherMatrix -> $validity');
    return validity;
  }
}
