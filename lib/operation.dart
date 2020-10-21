import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'presentation/custom_icon_icons.dart' show CustomIcon;

enum Operation {
  ADD,
  SUB,
  MATRIX_MULT,
  SCALAR_MULT,
  POW,
  DET,
  INV,
  RE,
  RRE,
  COFACTOR,
  ADJOINT,
  TRANSPOSE,
}

extension OperationsExt on Operation {
  static const operationShortName = {
    Operation.ADD: "add",
    Operation.SUB: "sub",
    Operation.SCALAR_MULT: "smult",
    Operation.MATRIX_MULT: "mmult",
    Operation.POW: "pow",
    Operation.DET: "det",
    Operation.INV: "inv",
    Operation.RE: "RE",
    Operation.RRE: "RRE",
    Operation.COFACTOR: "cofac",
    Operation.ADJOINT: "adj",
    Operation.TRANSPOSE: "trans"
  };

  static const operationFullName = {
    Operation.ADD: "Addition",
    Operation.SUB: "Subtraction",
    Operation.SCALAR_MULT: "Scalar Multiplication",
    Operation.MATRIX_MULT: "Matrix Multiplication",
    Operation.POW: "Power",
    Operation.DET: "Determinant",
    Operation.INV: "Inverse",
    Operation.RE: "Row Echelon Form",
    Operation.RRE: "Reduced Row Echelon Form",
    Operation.COFACTOR: "Cofactor",
    Operation.ADJOINT: "Adjoint",
    Operation.TRANSPOSE: "Transpose"
  };
  
  String get shortName => operationShortName[this];
  String get fullName => operationFullName[this];
}

class MatrixOperation {
  const MatrixOperation(this.operation, this.icon, this.color, this.bgColor,
      this.singleOperation, this.needMatrix, this.description);
  final Operation operation;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final bool singleOperation;
  final bool needMatrix;
  final String description;
}

final List<MatrixOperation> MatrixOperations = <MatrixOperation>[
  MatrixOperation(
      Operation.ADD,
      CustomIcon.plus,
      Colors.yellow,
      Colors.green,
      false,
      true,
      'Perform addition of Matrix 1 + Matrix 2. Dimension of both Matrixes must be exactly the same',
  ),
  MatrixOperation(
      Operation.SUB,
      CustomIcon.minus,
      Colors.yellow,
      Colors.blue,
      false,
      true,
      'Perform subtraction of Matrix 1 - Matrix 2. Dimension of both Matrixes must be exactly the same',
  ),
  MatrixOperation(
      Operation.MATRIX_MULT,
      CustomIcon.asterisk,
      Colors.green[200],
      Colors.red,
      false,
      true,
      'Perform multiplication of a Matrix 1 * Matrix 2. Dimension of both Matrixes must obey m x n * n x k.',
  ),
  MatrixOperation(
      Operation.SCALAR_MULT,
      CustomIcon.cancel,
      Colors.green[200],
      Colors.cyan,
      false,
      false,
      'Perform scalar multiplication of Matrix * Decimal Number',
  ),
  MatrixOperation(
      Operation.POW,
      CustomIcon.angle_up,
      Colors.blue[300],
      Colors.yellow[700],
      false,
      false,
      'Perform power operation. Example would be (Matrix 1)^(Integer Power). A power of -1 will be calculating its inverse.',
  ),
  MatrixOperation(
      Operation.DET,
      CustomIcon.eject,
      Colors.blue[300],
      Colors.orange,
      true,
      false,
      'Calculate the determinant of the given Matrix. Given Matrix must be a square Matrix',
  ),
  MatrixOperation(
      Operation.INV,
      CustomIcon.info,
      Colors.green[100],
      Colors.pink,
      true,
      false,
      'Calculate the inverse of the given Matrix. Given Matrix must be a square Matrix',
  ),
  MatrixOperation(
      Operation.RE,
      CustomIcon.yandex,
      Colors.teal[200],
      Colors.teal,
      true,
      false,
      'Calculate the Row Echelon Form (RE) of the given Matrix.',
  ),
  MatrixOperation(
      Operation.RRE,
      CustomIcon.calc,
      Colors.deepPurple[200],
      Colors.purple,
      true,
      false,
      'Calculate the Reduced Row Echelon Form (RRE) of the given Matrix',
  ),
  MatrixOperation(
    Operation.COFACTOR,
    CustomIcon.calculator,
    Colors.red[300],
    Colors.teal[300],
    true,
    false,
    'Calculate the Cofactor of the given Matrix. Given Matrix must be a square Matrix',
  ),
  MatrixOperation(
    Operation.ADJOINT,
    CustomIcon.sync_icon,
    Colors.red[300],
    Colors.lime[500],
    true,
    false,
    'Calculate the adjoint form of the given Matrix. Given Matrix must be a square Matrix',
  ),
  MatrixOperation(
    Operation.TRANSPOSE,
    CustomIcon.ok_circle,
    Colors.purple[300],
    Colors.pink[200],
    true,
    false,
    'Calculate the transpose of the given Matrix. Matrix can be of any size.',
  ),
];
