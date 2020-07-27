import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'presentation/custom_icon_icons.dart' show CustomIcon;

enum Operations {
  ADD,
  SUB,
  MATRIX_MULT,
  SCALAR_MULT,
  POW,
  DET,
  INV,
  RE,
  RRE
}

extension OperationsExt on Operations {
  static const operationShortName = {
    Operations.ADD: "add",
    Operations.SUB: "sub",
    Operations.SCALAR_MULT: "smult",
    Operations.MATRIX_MULT: "mmult",
    Operations.POW: "pow",
    Operations.DET: "det",
    Operations.INV: "inv",
    Operations.RE: "RE",
    Operations.RRE: "RRE",
  };

  static const operationFullName = {
    Operations.ADD: "Addition",
    Operations.SUB: "Subtraction",
    Operations.SCALAR_MULT: "Scalar Multiplication",
    Operations.MATRIX_MULT: "Matrix Multiplication",
    Operations.POW: "Power",
    Operations.DET: "Determinant",
    Operations.INV: "Inverse",
    Operations.RE: "Row Echelon Form",
    Operations.RRE: "Reduced Row Echelon Form",
  };
  
  String get shortName => operationShortName[this];
  String get fullName => operationFullName[this];
}

class MatrixOperation {
  const MatrixOperation(this.title, this.icon, this.color, this.bgColor,
      this.singleOperation, this.needMatrix, this.name, this.description, this.enumOperation);
  final String title;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final bool singleOperation;
  final bool needMatrix;
  final String name;
  final String description;
  final Operations enumOperation;
}

final List<MatrixOperation> MatrixOperations = <MatrixOperation>[
  MatrixOperation(
      Operations.ADD.fullName,
      CustomIcon.plus,
      Colors.yellow,
      Colors.green,
      false,
      true,
      Operations.ADD.shortName,
      'Perform addition of Matrix 1 + Matrix 2. Dimension of both Matrixes must be exactly the same',
      Operations.ADD
  ),
  MatrixOperation(
      Operations.SUB.fullName,
      CustomIcon.minus,
      Colors.yellow,
      Colors.blue,
      false,
      true,
      Operations.SUB.shortName,
      'Perform subtraction of Matrix 1 - Matrix 2. Dimension of both Matrixes must be exactly the same',
      Operations.SUB
  ),
  MatrixOperation(
      Operations.MATRIX_MULT.fullName,
      CustomIcon.asterisk,
      Colors.green[200],
      Colors.red,
      false,
      true,
      Operations.MATRIX_MULT.shortName,
      'Perform multiplication of a Matrix 1 * Matrix 2. Dimension of both Matrixes must obey m x n * n x k.',
      Operations.MATRIX_MULT,
  ),
  MatrixOperation(
      Operations.SCALAR_MULT.fullName,
      CustomIcon.cancel,
      Colors.green[200],
      Colors.cyan,
      false,
      false,
      Operations.SCALAR_MULT.shortName,
      'Perform scalar multiplication of Matrix * Decimal Number',
      Operations.SCALAR_MULT,
  ),
  MatrixOperation(
      Operations.POW.fullName,
      CustomIcon.angle_up,
      Colors.blue[300],
      Colors.yellow[700],
      false,
      false,
      Operations.POW.shortName,
      'Perform power operation. Example would be (Matrix 1)^(Integer Power). A power of -1 will be calculating its inverse.',
      Operations.POW,
  ),
  MatrixOperation(
      Operations.DET.fullName,
      CustomIcon.eject,
      Colors.blue[300],
      Colors.orange,
      true,
      false,
      Operations.DET.shortName,
      'Calculate the determinant of the given Matrix. Given Matrix must be a square Matrix',
      Operations.DET,
  ),
  MatrixOperation(
      Operations.INV.fullName,
      CustomIcon.info,
      Colors.green[100],
      Colors.pink,
      true,
      false,
      Operations.INV.shortName,
      'Calculate the inverse of the given Matrix. Given Matrix must be a square Matrix',
      Operations.INV,
  ),
  MatrixOperation(
      Operations.RE.fullName,
      CustomIcon.yandex,
      Colors.teal[200],
      Colors.teal,
      true,
      false,
      Operations.RE.shortName,
      'Calculate the Row Echelon Form (RE) of the given Matrix.',
      Operations.RE,
  ),
  MatrixOperation(
      Operations.RRE.fullName,
      CustomIcon.calc,
      Colors.deepPurple[200],
      Colors.purple,
      true,
      false,
      Operations.RRE.shortName,
      'Calculate the Reduced Row Echelon Form (RRE) of the given Matrix',
      Operations.RRE,
  )
];
