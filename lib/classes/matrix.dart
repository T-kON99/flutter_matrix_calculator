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

  /// Determinant of a matrix
  double det() {
    //  TODO
    assert(this.isSquare(), 'A non-square matrix has no determinant value');
    double output = 1;
    var matGauss = this.gaussElimination();
    for(int n = 0; n < matGauss.size; n++) {
      output = output * matGauss.data[n][n];
    }
    return output;
  }

  Matrix gaussElimination() {
    var out = Matrix(data: this.data);
    double ratio;
    for(int j = 0; j < this.col; j++) {
      for(int i = this.row - 1; i > j; i--) {
        //  Step 1
        //  Countermeasure if the current cell is 0, we're going to perform an elementary matrix operation and add the row below
        //  to current row.
        if(out.data[i - 1][j] == 0) {
          for(int n = 0; n < this.col; n++) {
              out.data[i - 1][n] = out.data[i - 1][n] + out.data[i][n];
          }
        }

        //  Step 2
        //  Get the ratio if applicable (non zero value, otherwise will result in dividing by 0)
        if(out.data[i - 1][j] != 0) ratio = out.data[i][j] / out.data[i - 1][j];
        else ratio = 1;

        //  Step 3
        //  Perform the elementary row operation, in this case substracting the value from row (i)-th with row (i-1)th
        for(int n = 0; n < this.col; n++) {
          out.data[i][n] = out.data[i][n] - (ratio * out.data[i - 1][n]);
        }
      }
    }
    return out;
  }

  //  TODO?
  Matrix toRE() {
    this.data = this.gaussElimination().data;
    return this;
  }

  Matrix inv() {
    //  TODO
    assert(this.isSquare(), 'Can not perform inverse on a non-square matrix');
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
          for(int j = 0; j < this.col; j++) {
            result.data[i][j] += this.data[i][j] * other.data[j][j];
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

