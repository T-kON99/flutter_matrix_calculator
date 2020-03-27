import 'package:flutter_test/flutter_test.dart';
import 'package:matrix_calculator/classes/matrix.dart';

void main() {
  test('Initializing a 1x1 matrix', () {
    final mat = Matrix(data: [[1]]);
    expect(mat.row, 1);
    expect(mat.col, 1);
  });

  test('Initializing 2x2 square matrixes', () {
    final mat = Matrix(data: [[1, 3], [4, 1]]);
    expect(mat.row, mat.col);
  });

  test('Copying a matrix from another matrix', () {
    final mat = Matrix(data: [
      [1, 2],
      [1, 5]
    ]);
    var copy = Matrix.copyFrom(mat);
    copy = copy * 2;
    expect(mat.data, [
      [1, 2],
      [1, 5]
    ]);
  });

  test('Resizing 3x3 Matrix to 2x2', () {
    final mat = Matrix(data: [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9]
    ]);
    mat.zeroFillResize(col: 2, row: 2);
    expect(mat.data, [
      [1, 2],
      [4, 5]
    ]);
  });


  test('Resizing 2x2 Matrix to 3x3', () {
    final mat = Matrix(data: [
      [1, 2],
      [4, 5]
    ]);
    mat.zeroFillResize(col: 3, row: 3);
    expect(mat.data, [
      [1, 2, 0],
      [4, 5, 0],
      [0, 0, 0]
    ]);
  });

  test('Resizing 3x3 Matrix to 2x2 and then back to 3x3', () {
    final mat = Matrix(data: [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9]
    ]);
    mat.zeroFillResize(col: 2, row: 2);
    mat.zeroFillResize(row: 3, col: 3);
    expect(mat.data, [
      [1, 2, 0],
      [4, 5, 0],
      [0, 0, 0]
    ]);
  });

    test('Resizing 4x2 Matrix to 2x1', () {
    final mat = Matrix(data: [
      [2, 3],
      [1, 5],
      [0, 3],
      [3, -1]
    ]);
    mat.zeroFillResize(col: 1, row: 2);
    expect(mat.data, [
      [2],
      [1],
    ]);
  });

  test('Matrix transpose of 1x2 Matrix', () {
    final matA = Matrix(data: [
      [1, 2]
    ]);
    expect((~matA).data, [
      [1],
      [2]
    ]);
  });

  test('Matrix 2x3 Addition', () {
    final matA = Matrix(data: [[1, 5, 3], [3, 6, 1]]);
    final matB = Matrix(data: [[2, 1, 0], [-4, 5, 1]]);
    final matRes = Matrix(data: [[3, 6, 3], [-1, 11, 2]]);
    expect((matA + matB).data, matRes.data);
    print(matRes.data);
  });

  test('Matrix 2x2 Multiplication', () {
    final matA = Matrix(data: [[1, 3], [4, 6]]);
    final matB = Matrix(data: [[3, 6], [9, 1]]);
    expect((matA * matB).data, [[30, 9], [66, 30]]);
    print((matA * matB).data);
  });

  test('Complex Matrix Arithmetic', () {
    final matA = Matrix(data: [
      [1, 2, 3],
      [-3, 1, 5]
    ]);
    final matB = Matrix(data: [
      [3, -1, 9],
      [5, -3, 7]
    ]);
    final matC = Matrix(data: [
      [10, -3, 9],
      [5, 9, 3]
    ]);
    final matD = matA + matB - matC;
    expect(matD.data, [
      [-6, 4, 3],
      [-3, -11, 9]
    ]);
  });

  test('Gaussian Elimination of a 3x4 Matrix', () {
    final mat = Matrix(data: [
      [1, 3, 2, 1], 
      [2, 6, 1, 3], 
      [3, 6, 8, 8]
    ]);
    final out = mat.gaussElimination();
    print(out.data);
    for(int j = 0; j < out.col; j++)
      for(int i = out.row - 1; i > j; i--)
        expect(out.data[i][j], 0);
  });

  test('Determinant of a 2x2 Matrix', () {
    final mat = Matrix(data: [[2, 1], [11, 3]]);
    expect(mat.det(), -5);
  });

  test('Determinant of a 3x3 Matrix', () {
    final mat = Matrix(data: [[2, 1, 5], [11, 3, -1], [4, 0, 1]]);
    expect(mat.det(), -69);
  });

  test('Determinant of a non-square Matrix', () {
    //  TODO
    final mat = Matrix(data: [[1, 3]]);
    expect(mat.det(), throwsException);
  });

  test('Reduced Row Echelon Form of a square 2x2 matrix', () {
    final mat = Matrix(data: [[1, 5], [3, 2]]);
    expect(mat.getRRE().data, [[1, 0], [0, 1]]);
  });

  test('Reduced Row Echelon Form of a 4x5 matrix', () {
    final mat = Matrix(data: [
      [1, 5, 7, 0, -5], 
      [3, 2, 6, 0, -7], 
      [-1, -3, 0, -7, 9], 
      [0.5, -3, 0.3, -1.9, 6]
    ]);
    expect(mat.getRRE().data, [
      [1.0, 0.0, 0.0, 0.0, moreOrLessEquals(-4.352112676056337)],
      [0.0, 1.0, 0.0, 0.0, moreOrLessEquals(-2.892605633802818)],
      [0.0, 0.0, 1.0, 0.0, moreOrLessEquals(1.9735915492957754)],
      [0.0, 0.0, 0.0, 1.0, moreOrLessEquals(0.5757042253521134)]
    ]);
  });

    test('Reduced Row Echelon Form of a 3x6 matrix', () {
    final mat = Matrix(data: [
      [1, 3, 2, 1, 0, 0],
      [-5, 3, 1, 0, 1, 0],
      [0, 4, 8, 0, 0, 1]
    ]);
    expect(mat.getRRE().data, [
      [1.0, 0.0, 0.0, moreOrLessEquals(0.2), moreOrLessEquals(-0.16), moreOrLessEquals(-0.03)],
      [0.0, 1.0, 0.0, moreOrLessEquals(0.4), moreOrLessEquals(0.08), moreOrLessEquals(-0.11)],
      [0.0, 0.0, moreOrLessEquals(1), moreOrLessEquals(-0.2), moreOrLessEquals(-0.04), moreOrLessEquals(0.18)],
    ]);
  });

  test('Inverse of a 2x2 Matrix', () {
    final mat = Matrix(data: [
      [1, 4],
      [2, 3]
    ]);
    expect(mat.inv().data, [
      [moreOrLessEquals(-0.6), moreOrLessEquals(0.8)], 
      [moreOrLessEquals(0.4), moreOrLessEquals(-0.2)]
    ]);
  });

  test('Inverse of a 3x3 Matrix', () {
    final mat = Matrix(data: [
      [1, 3, 2],
      [-5, 3, 1],
      [0, 4, 8]
    ]);
    expect(mat.inv().data, [
      [0.2, -0.16, -0.03], 
      [0.4, 0.08, -0.11], 
      [-0.2, -0.04, 0.18]
    ]);
  });

  test('Latex text of 2x3 Matrix', () {
    final mat = Matrix(data: [
      [1, 2, 3],
      [4, 5, 6]
    ]);
    final supposedLatex = r"$$\begin{matrix}"r"1.0&2.0&3.0\\"r"4.0&5.0&6.0"r"\end{matrix}$$";
    expect(mat.getMathJexText(parentheses: 'plain'), supposedLatex);
  });

  test('History of 3x3 Matrix addition/substraction', () {
    final matA = Matrix(data: [
      [1, 2, 9],
      [4, -1, 10],
      [3, 1, 0]
    ]);
    final matB = Matrix(data: [
      [1, 3, 3],
      [-4, 1, -9],
      [1, 9, 0]
    ]);
    Matrix matC = matA + matB;
    Matrix matD = matA - matB;
    print('Matrix matC');
    print(matC.historyMessage);
    for(int i = 0; i < matC.historyState.length; i++) print(matC.historyState[i].data);
    print('Matrix matD');
    print(matD.historyMessage);
    for(int i = 0; i < matD.historyState.length; i++) print(matD.historyState[i].data);
    expect(matA.historyMessage.length, 0);
    expect(matA.historyState.length, 0);
    expect(matB.historyMessage.length, 0);
    expect(matB.historyState.length, 0);
    expect(matC.historyMessage.length, 9);
    expect(matC.historyState.length, 9);
    expect(matD.historyMessage.length, 9);
    expect(matD.historyState.length, 9);
  });

  test('History of complex Matrix arithmetic', () {
    final matA = Matrix(data: [
      [1, 3, 4],
      [5, 9, 0],
      [4, 6, 3]
    ]);
    final matB = Matrix(data: [
      [-4, -3, 1],
      [5, 0, 3],
      [6, 4, 0]
    ]);

    Matrix matC = (matA * matB + matA) - matB;
    print(matC.historyMessage);
    for(int i = 0; i < matC.historyState.length; i++) print(matC.historyState[i].data);
    expect(matC.historyMessage.length, 27);
    expect(matC.historyState.length, 27);
  });

  test('History of RRE', () {
    final matA = Matrix(data: [
      [1, 3, 4],
      [5, 9, 0],
      [4, 6, 3]
    ]);
    Matrix matC = matA.getRRE();
    print(matC.historyMessage);
    for(int i = 0; i < matC.historyState.length; i++) print(matC.historyState[i].data);
    expect(matC.historyMessage.length, 15);
  });
}