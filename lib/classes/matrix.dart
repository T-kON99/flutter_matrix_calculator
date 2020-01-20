class Matrix {
  int row, col, size;
  List<List<double>> data;

  Matrix({this.data}) {
    this.row = this.data.length;
    this.col = this.data[0].length;
    this.size = this.row == this.col ? this.row : null;
  }

  Matrix.withSize({this.row, this.col}) {
    this.data = new List.generate(row, (_) => List(col));
  }

  bool isSquare() => this.row == this.col;

  Matrix inv() {
    var out = Matrix(data: this.data);
    return out;
  }

  ///  Matrix Addition
  Matrix operator +(Matrix other) {
    assert(this.row == other.row && this.col == other.col, 'Dimension of matrixes does not match');
    var result = Matrix(data: this.data);
    result.row = other.row;
    result.col = other.col;
    for(int i = 0; i < row; i++) {
      for(int j = 0; j < col; j++) {
        assert(data[i][j] != null && other.data[i][j] != null, 'Invalid null type in addition');
        result.data[i][j] = data[i][j] + other.data[i][j];
      }
    }
    return result;
  }

  ///  Matrix Multiplication
  Matrix operator *(other) {
    var result = Matrix(data: this.data);
    //  A scaling operation of Matrix with const scale
    if(other is num) {
      for(int i = 0; i < row; i++) {
          for(int j = 0; j < col; j++) {
              result.data[i][j] = other * data[i][j];
          }
      }
    }
    //  Matrix Multiplication, O(n^3) default algorithm
    else if(other is Matrix) {
      // TODO
      result = Matrix.withSize(row: this.row, col: other.col);
      for(int i = 0; i < result.row; i++) {
        for(int j = 0; j < result.col; j++) {
          result.data[i][j] = 0;
          for(int k = 0; k < this.col; k++) {
            result.data[i][j] += this.data[i][k] * other.data[k][j];
          }
        }
      }
    }
    return result;
  }

  ///  Matrix substraction
  Matrix operator -(Matrix other) {
    var result = this + (other * -1);
    return result;
  }

  ///  Matrix dot product, if the matrix is a vector
  Matrix operator &(Matrix other) {
    assert(col == other.row, 'Dimension does not match for matrix multiplication.');
    return Matrix(data: [[1]]);
  }

  /// Matrix transpose
  Matrix operator ~() {
    assert(this.size != null && this.row == this.col, 'Can not transpose a non-square matrix');
    for(int i = 0; i < this.row; i++ ) {
      for(int j = i + 1; j < this.col; j++) {
          var temp = this.data[j][i];
          this.data[j][i] = this.data[i][j];
          this.data[i][j] = temp;
      }
    }
    return this;
  }

  /// Matrix power of, follows the convention of inversing matrix with <Matrix>^(-1)
  Matrix operator ^(int power) {
    assert(power >= -1, 'Invalid power, can only perform positive power multiplication');
    //  Inverse Matrix     
    var out = Matrix(data: this.data);
    if(power == -1) {
      //  TODO
      return this.inv();
    }
    else {
      for(int i = 0 ; i < power - 1 ; i++) {
        out = out * this;
      }
    }
    return out;
  }

}

