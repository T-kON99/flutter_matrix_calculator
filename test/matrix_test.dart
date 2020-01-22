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

  test('Matrix 2x3 Addition', () {
    final matA = Matrix(data: [[1, 5, 3], [3, 6, 1]]);
    final matB = Matrix(data: [[2, 1, 0], [-4, 5, 1]]);
    final matRes = Matrix(data: [[3, 6, 3], [-1, 11, 2]]);
    expect((matA + matB).data, matRes.data);
    print(matRes.data);
  });

  test('Matrix 2x2  Multiplication', () {
    final matA = Matrix(data: [[1, 3], [4, 6]]);
    final matB = Matrix(data: [[3, 6], [9, 1]]);
    expect((matA * matB).data, [[30, 9], [66, 30]]);
    print((matA * matB).data);
  });

  test('Gaussian Elimination of a 3x4 Matrix', () {
    final mat = Matrix(data: [[1, 3, 2, 1], [2, 6, 1, 3], [3, 6, 8, 8]]);
    final out = mat.gaussElimination();
    for(int j = 0; j < out.col; j++)
      for(int i = out.row - 1; i > j; i--)
        expect(out.data[i][j], 0);
    print(out.data);
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
    expect(mat.det(), throwsA(isAssertionError));
  });
}