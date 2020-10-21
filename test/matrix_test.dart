import 'package:flutter_test/flutter_test.dart';
import 'package:matrix_calculator/classes/matrix.dart';
import 'package:tuple/tuple.dart';
import 'dart:math';

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

  test('Matrix scaling by a constant', () {
    final mat = Matrix(data: [
      [1, 2],
      [2, 4],
    ]);
    expect((mat * 3).data, [
      [3, 6],
      [6, 12],
    ]);
  });

  test('Matrix 2x3 Addition', () {
    final matA = Matrix(data: [[1, 5, 3], [3, 6, 1]]);
    final matB = Matrix(data: [[2, 1, 0], [-4, 5, 1]]);
    final matRes = Matrix(data: [[3, 6, 3], [-1, 11, 2]]);
    expect((matA + matB).data, matRes.data);
    // print(matRes.data);
  });

  test('Matrix 2x2 Multiplication', () {
    final matA = Matrix(data: [[1, 3], [4, 6]]);
    final matB = Matrix(data: [[3, 6], [9, 1]]);
    expect((matA * matB).data, [[30, 9], [66, 30]]);
    // print((matA * matB).data);
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
    // print(out.data);
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

  test('Determinant of a non-square Matrix should not work', () {
    final mat = Matrix(data: [[1, 3]]);
    try {
      print('Attempting to calculate determinant');
      double det = mat.det();
      expect(det, null);
    } catch (e) {
      print('Exception was thrown, ok behaviour');
      print(e);
      expect(true, true);
    }
    // expect(mat.det(), throwsException);
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

  test('Reduced Row Echelon Form of a 3x6 matrix extreme floating points', () {
    final mat = Matrix(data: [
      [37.10750265647809, 47.646290934711224, 38.43983786403484, 1.0, 0.0, 0.0], 
      [80.02367239308013, 11.563476376052106, 11.603992200828216, 0.0, 1.0, 0.0], 
      [96.0465225939978, 81.46671905291639, 66.86609947304328, 0.0, 0.0, 1.0]
    ]);
    expect(mat.getRRE().data, [
      [1.0, 0.0, 0.0, moreOrLessEquals(0.5268642955619023), moreOrLessEquals(0.16636552479069672), moreOrLessEquals(-0.33175379638899666)],
      [0.0, 1.0, 0.0, moreOrLessEquals(12.966482195227124), moreOrLessEquals(3.705914296000624), moreOrLessEquals(-8.097270187824103)],
      [0.0, 0.0, 1.0, moreOrLessEquals(-16.554580785994926), moreOrLessEquals(-4.754090808755727), moreOrLessEquals(10.356845089591753)]
    ]);
  });

    test('100000 Reduced Row Echelon Form iterations of random 3x6 Matrix extreme floating points', () {
    Random _random = new Random();
    for(int i = 0; i < 100000; i++) {
      final mat = Matrix(data: [
        [_random.nextDouble() * 100, _random.nextDouble() * 100, _random.nextDouble() * 100],
        [_random.nextDouble() * 100, _random.nextDouble() * 100, _random.nextDouble() * 100],
        [_random.nextDouble() * 100, _random.nextDouble() * 100, _random.nextDouble() * 100]
      ]);
      if (mat.det() != 0) {
        Matrix expanded = mat & Matrix.identity(size: mat.size);
        Matrix rreMat = expanded.getRRE();
        for(int i = 0; i < mat.size; i++) {
          for(int j = 0; j < mat.size; j++) {
            expect(rreMat.data[i][j], i == j ? moreOrLessEquals(1) : moreOrLessEquals(0));
          }
        }
      }
      else continue;
    }
  });

  test('Cofactor of a 3x3 Matrix', () {
    final mat = Matrix(data: [
      [1, 2, 3],
      [0, 4, 5],
      [1, 0, 6]
    ]);
    expect(mat.getCofactor().data, [
      [moreOrLessEquals(24), moreOrLessEquals(5), moreOrLessEquals(-4)],
      [moreOrLessEquals(-12), moreOrLessEquals(3), moreOrLessEquals(2)],
      [moreOrLessEquals(-2), moreOrLessEquals(-5), moreOrLessEquals(4)]
    ]);
  });

  test('Adjoint of a 3x3 Matrix', () {
    final mat = Matrix(data: [
      [1, 2, 3],
      [0, 4, 5],
      [1, 0, 6]
    ]);
    expect(mat.getAdjoint().getTranspose().data, [
      [moreOrLessEquals(24), moreOrLessEquals(5), moreOrLessEquals(-4)],
      [moreOrLessEquals(-12), moreOrLessEquals(3), moreOrLessEquals(2)],
      [moreOrLessEquals(-2), moreOrLessEquals(-5), moreOrLessEquals(4)]
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
      [moreOrLessEquals(0.2), moreOrLessEquals(-0.16), moreOrLessEquals(-0.03)], 
      [moreOrLessEquals(0.4), moreOrLessEquals(0.08), moreOrLessEquals(-0.11)], 
      [moreOrLessEquals(-0.2), moreOrLessEquals(-0.04), moreOrLessEquals(0.18)]
    ]);
  });

  test('1000 inverse iterations of random 3x3 Matrix extreme floating points', () {
    Random _random = new Random();
    for(int i = 0; i < 1000; i++) {
      final mat = Matrix(data: [
        [_random.nextDouble() * 100, _random.nextDouble() * 100, _random.nextDouble() * 100],
        [_random.nextDouble() * 100, _random.nextDouble() * 100, _random.nextDouble() * 100],
        [_random.nextDouble() * 100, _random.nextDouble() * 100, _random.nextDouble() * 100]
      ]);
      if (mat.det() != 0) {
        Matrix invMat = mat.inv();
        expect((mat * invMat).data, [
          [moreOrLessEquals(1), moreOrLessEquals(0), moreOrLessEquals(0)],
          [moreOrLessEquals(0), moreOrLessEquals(1), moreOrLessEquals(0)],
          [moreOrLessEquals(0), moreOrLessEquals(0), moreOrLessEquals(1)],
        ]);
      }
      else continue;
    }
  });

  test('Latex text of 2x3 Matrix', () {
    final mat = Matrix(data: [
      [1, 2, 3],
      [4, 5, 6]
    ]);
    final supposedLatex = r"$$\begin{matrix}"r"1.00&2.00&3.00\\"r"4.00&5.00&6.00"r"\end{matrix}$$";
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
    // print('Matrix matC');
    print(matC.historyMessage);
    // for(int i = 0; i < matC.historyState.length; i++) print(matC.historyState[i].data);
    // print('Matrix matD');
    // print(matD.historyMessage);
    // for(int i = 0; i < matD.historyState.length; i++) print(matD.historyState[i].data);
    expect(matA.historyMessage.length, 0);
    expect(matA.historyState.length, 0);
    expect(matB.historyMessage.length, 0);
    expect(matB.historyState.length, 0);
    expect(matC.historyMessage.length, 11);
    expect(matC.historyState.length, 11);
    expect(matD.historyMessage.length, 11);
    expect(matD.historyState.length, 11);
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
    // print(matC.historyMessage);
    // for(int i = 0; i < matC.historyState.length; i++) print(matC.historyState[i].data);
    expect(matC.historyMessage.length, 33);
    expect(matC.historyState.length, 33);
  });

  test('History of RRE', () {
    final matA = Matrix(data: [
      [1, 3, 4],
      [5, 9, 0],
      [4, 6, 3]
    ]);
    Matrix matC = matA.getRRE();
    // print(matC.historyMessage);
    // for(int i = 0; i < matC.historyState.length; i++) print(matC.historyState[i].data);
    expect(matC.historyMessage.length, 16);
  });

  test('Concatenate 2 matrixes', () {
    final matA = Matrix(data: [
      [1, 2, 3],
      [2, 4, 1],
      [0, 1, 2]
    ]);
    final matB = Matrix(data: [
      [2, 1],
      [1, 1],
      [9, 9]
    ]);
    expect((matA & matB).data, [
      [1, 2, 3, 2, 1],
      [2, 4, 1, 1, 1],
      [0, 1, 2, 9, 9]
    ]);
  });

  
  test('Matrix concatenate history', () {
        final matA = Matrix(data: [
      [1, 2, 3],
      [2, 4, 1],
      [0, 1, 2]
    ]);
    final matB = Matrix(data: [
      [2, 1],
      [1, 1],
      [9, 9]
    ]);
    expect((matA & matB).getHistoryText(),'\\(1. \\)Concatenate Matrix \$\$\\begin{bmatrix}2.00&1.00\\\\1.00&1.00\\\\9.00&9.00\\end{bmatrix}\$\$ With our original Matrix \$\$\\begin{bmatrix}1.00&2.00&3.00\\\\2.00&4.00&1.00\\\\0.00&1.00&2.00\\end{bmatrix}\$\$ To get\n'
      '\$\$\\begin{bmatrix}1.00&2.00&3.00&2.00&1.00\\\\2.00&4.00&1.00&1.00&1.00\\\\0.00&1.00&2.00&9.00&9.00\\end{bmatrix}\$\$\n'
      'Operation Result\n'
      '\$\$\\begin{bmatrix}1.00&2.00&3.00&2.00&1.00\\\\2.00&4.00&1.00&1.00&1.00\\\\0.00&1.00&2.00&9.00&9.00\\end{bmatrix}\$\$\n'
    '');
  });

  test('Initiate Identity 2x2 Matrix', () {
    final matA = Matrix.identity(size: 2);
    expect(matA.data, [
      [1, 0],
      [0, 1]
    ]);
  });

  test('1000 Iterations to confirm property of Identity Matrix', () {
    final identity = Matrix.identity(size: 3);
    Random _random = new Random();
    for(int i = 0; i < 1000; i++) {
      final mat = Matrix(data: [
        [_random.nextDouble() * 100, _random.nextDouble() * 100, _random.nextDouble() * 100],
        [_random.nextDouble() * 100, _random.nextDouble() * 100, _random.nextDouble() * 100],
        [_random.nextDouble() * 100, _random.nextDouble() * 100, _random.nextDouble() * 100]
      ]);
      expect((mat * identity).data, mat.data);
    }
  });

  test('Matrix Shift', () {
    final mat = Matrix(data: [
      [1, 2],
      [2, 1]
    ]);
    expect(mat.shift(length: 1).data, [
      [2],
      [1]
    ]);
  });

  
  test('Matrix Shift History', () {
    final mat = Matrix(data: [
      [1, 2],
      [2, 1]
    ]);
    expect(mat.shift(length: 1).getHistoryText(), '\\(1. \\)Shift matrix 1 to the right \$\$\\begin{bmatrix}1.00&2.00\\\\2.00&1.00\\end{bmatrix}\$\$ Deleting columns less than 1\n'
      '\$\$\\begin{bmatrix}2.00\\\\1.00\\end{bmatrix}\$\$\n'
      'Operation Result\n'
      '\$\$\\begin{bmatrix}2.00\\\\1.00\\end{bmatrix}\$\$\n'
    '');
  });

  test('Complex Chained Matrix Steps', () {
    final mat = Matrix(data: [
      [1, 3],
      [5, 2]
    ]);
    Matrix a = mat * mat;
    Matrix b = a * a;
    Matrix c = b.getRRE();
    Matrix d = c + b^4;
    expect((d.inv()).getHistoryText(stepsOnly: true), '\\(1. \\)Getting inverse of the matrix\n'
      '\$\$\\begin{bmatrix}2.32e+11&2.05e+11\\\\3.41e+11&3.01e+11\\end{bmatrix}\$\$\n'
      '\\(2. \\)Concatenate Matrix \$\$\\begin{bmatrix}1.00&0.00\\\\0.00&1.00\\end{bmatrix}\$\$ With our original Matrix \$\$\\begin{bmatrix}2.32e+11&2.05e+11\\\\3.41e+11&3.01e+11\\end{bmatrix}\$\$ To get\n'
      '\$\$\\begin{bmatrix}2.32e+11&2.05e+11&1.00&0.00\\\\3.41e+11&3.01e+11&0.00&1.00\\end{bmatrix}\$\$\n'
      '\\(3. \\)Getting Reduced Row Echelon Form of the matrix\n'
      '\$\$\\begin{bmatrix}2.32e+11&2.05e+11&1.00&0.00\\\\3.41e+11&3.01e+11&0.00&1.00\\end{bmatrix}\$\$\n'
      '\\(4. \\)Getting Row Echelon Form of the matrix\n'
      '\$\$\\begin{bmatrix}2.32e+11&2.05e+11&1.00&0.00\\\\3.41e+11&3.01e+11&0.00&1.00\\end{bmatrix}\$\$\n'
      '\\(5. \\)Performing Gaussian Elimination on the matrix\n'
      '\$\$\\begin{bmatrix}2.32e+11&2.05e+11&1.00&0.00\\\\3.41e+11&3.01e+11&0.00&1.00\\end{bmatrix}\$\$\n'
      '\\(6. \\)Get Ratio of element at \$\$(Row_{2}, Col_{1}) = \\frac{(Row_{2}, Col_{1})}{(Row_{1}, Col_{1})}\$\$\n'
      '\$\$\\begin{bmatrix}2.32e+11&2.05e+11&1.00&0.00\\\\\\colorbox{yellow}{3.41e+11}&3.01e+11&0.00&1.00\\end{bmatrix}\$\$\n'
      '\\(7. \\)Perform Elementary Row Operation \$\$R_{2} = R_{2} - (1.47 * R_{1})\$\$\n'
      '\$\$\\begin{bmatrix}2.32e+11&2.05e+11&1.00&0.00\\\\\\colorbox{yellow}{0.00}&3.24e+6&-1.47&1.00\\end{bmatrix}\$\$\n'
      '\\(8. \\)Normalizing leftmost non-zero value of the matrix to make it equal to 1\n'
      '\$\$\\begin{bmatrix}2.32e+11&2.05e+11&1.00&0.00\\\\0.00&3.24e+6&-1.47&1.00\\end{bmatrix}\$\$\n'
      '\\(9. \\)Normalizing \\(Row_{1}\\).<br>Multiply row by \\(4.30e-12\\) to make element at \$\$(Row_{1}, Col_{1})\$\$ into 1\n'
      '\$\$\\begin{bmatrix}\\colorbox{yellow}{1.00}&0.881&0.00&0.00\\\\0.00&3.24e+6&-1.47&1.00\\end{bmatrix}\$\$\n'
      '\\(10. \\)Normalizing \\(Row_{2}\\).<br>Multiply row by \\(3.09e-7\\) to make element at \$\$(Row_{2}, Col_{2})\$\$ into 1\n'
      '\$\$\\begin{bmatrix}1.00&0.881&0.00&0.00\\\\0.00&\\colorbox{yellow}{1.00}&-4.54e-7&3.09e-7\\end{bmatrix}\$\$\n'
      '\\(11. \\)Perform Gaussian Elimination on the pivots which is on \$\$(Row_{2}, Col_{2})\$\$\n'
      '\$\$\\begin{bmatrix}1.00&0.00&4.00e-7&-2.72e-7\\\\0.00&\\colorbox{yellow}{1.00}&-4.54e-7&3.09e-7\\end{bmatrix}\$\$\n'
      '\\(12. \\)Perform Gaussian Elimination on the pivots which is on \$\$(Row_{1}, Col_{1})\$\$\n'
      '\$\$\\begin{bmatrix}\\colorbox{yellow}{1.00}&0.00&4.00e-7&-2.72e-7\\\\0.00&1.00&-4.54e-7&3.09e-7\\end{bmatrix}\$\$\n'
      '\\(13. \\)Shift matrix 2 to the right \$\$\\begin{bmatrix}1.00&0.00&4.00e-7&-2.72e-7\\\\0.00&1.00&-4.54e-7&3.09e-7\\end{bmatrix}\$\$ Deleting columns less than 2\n'
      '\$\$\\begin{bmatrix}4.00e-7&-2.72e-7\\\\-4.54e-7&3.09e-7\\end{bmatrix}\$\$\n'
      'Operation Result\n'
      '\$\$\\begin{bmatrix}4.00e-7&-2.72e-7\\\\-4.54e-7&3.09e-7\\end{bmatrix}\$\$\n'
    '');
  });
}