class Matrix {
  int row, col, size;
  List<List<double>> data;
  static const _epsilon = 0.0000000000001;

  Matrix.withSize({this.row, this.col}) {
    this.data = new List.generate(row, (_) => List(col));
    this.size = this.row == this.col ? this.row : null;
  }

  Matrix({this.data}) {
    this.row = this.data.length;
    this.col = this.data[0].length;
    this.size = this.row == this.col ? this.row : null;
  }

  factory Matrix.copyFrom(Matrix other) {
    var copy = Matrix.withSize(row: other.row, col: other.col);
    for(int i = 0; i < copy.row; i++)
      for(int j = 0; j < copy.col; j++)
        copy.data[i][j] = other.data[i][j];
    return copy;
  }

  bool isSquare() => this.row == this.col;

  /// Determinant of a matrix
  double det() {
    if(!this.isSquare()) throw('A non-square matrix has no determinant value');
    double output = 1;
    var matGauss = this.gaussElimination();
    for (int n = 0; n < matGauss.size; n++) {
      output = output * matGauss.data[n][n];
    }
    return output;
  }

  Matrix gaussElimination() {
    //  TODO BUG, fix this.data pointing to old value!
    var out = Matrix.copyFrom(this);
    double ratio;
    for (int j = 0; j < this.col; j++) {
      for (int i = this.row - 1; i > j; i--) {
        //  Step 1
        //  Countermeasure if the current cell is 0, we're going to perform an elementary matrix operation and add the row below
        //  to current row.
        if (out.data[i - 1][j] == 0) {
          for (int n = 0; n < this.col; n++) {
            out.data[i - 1][n] = out.data[i - 1][n] + out.data[i][n];
          }
        }

        //  Step 2
        //  Get the ratio if applicable (non zero value, otherwise will result in dividing by 0)
        if (out.data[i - 1][j] != 0)
          ratio = out.data[i][j] / out.data[i - 1][j];
        else
          ratio = 1;

        //  Step 3
        //  Perform the elementary row operation, in this case substracting the value from row (i)-th with row (i-1)th
        for (int n = 0; n < this.col; n++) {
          out.data[i][n] = out.data[i][n] - (ratio * out.data[i - 1][n]);
        }
      }
    }
    return out;
  }

  Matrix _normalizeRE() {
    double ratio;
    for (int i = 0; i < this.row; i++) {
      for (int j = 0; j < this.col; j++) {
        if (this.data[i][j].abs() > _epsilon) {
          ratio = 1 / this.data[i][j];
          for (int n = 0; n < this.col; n++) {
            this.data[i][n] *= ratio;
            //Fixes floating point problem. Ex : 0 * -0.333333 returns -0 instead of 0.
            if (this.data[i][n].abs() < _epsilon) this.data[i][n] = 0;
          }
          break;
        }
      }
    }
    return this;
  }

  Matrix gaussJordanElimination() {
    //  TODO?
  }

  Matrix toRE() {
    this.data = this.gaussElimination()._normalizeRE().data;
    return this;
  }

  Matrix toRRE() {
    double ratio, temp;
    this.toRE();
    if (this.row > 1 || this.col > 1) {
      for (int i = this.row - 1; i >= 0; i--) {
        for (int k = 0; k < this.col; k++) {
          //  GE on pivots
          if (this.data[i][k].abs() > _epsilon) {
            for (int rowThis = 0; rowThis < i; rowThis++) {
              if (this.data[rowThis + 1][k].abs() > _epsilon)
                ratio = this.data[rowThis][k] / this.data[rowThis + 1][k];
              else
                ratio = 1;
              for (int n = 0; n < col; n++) {
                temp = ratio * this.data[rowThis + 1][n];
                this.data[rowThis][n] = this.data[rowThis][n] - temp;
              }
            }
            break;
          }
        }
      }
    }
    return this;
  }

  /// Return a new matrix which is the RE (Row Echelon) form of given matrix.
  Matrix getRE() {
    //  TODO
    var out = Matrix.copyFrom(this);
    return out.toRE();
  }

  Matrix toCofactor() {
    assert(this.isSquare(), "Not a square matrix, can't calculate determinant");
    int size, rowOutput, colOutput;
    var output = Matrix.withSize(row: this.row - 1, col: this.col - 1);
    var copy = Matrix.copyFrom(this);
    size = this.size;
    rowOutput = 0;
    colOutput = 0;
    for (int rowIndex = 0; rowIndex < size; rowIndex++) {
      for (int colIndex = 0; colIndex < size; colIndex++) {
        for (int rowPos = 0; rowPos < size; rowPos++) {
          for (int colPos = 0; colPos < size; colPos++) {
            if (rowPos != rowIndex && colPos != colIndex) {
              output.data[rowOutput][colOutput++] = copy.data[rowPos][colPos];
              if (colOutput == size - 1) {
                colOutput = 0;
                rowOutput++;
              }
              if (rowOutput == size - 1) {
                rowOutput = 0;
              }
            }
          }
        }
        this.data[rowIndex][colIndex] = output.det();
        if ((rowIndex + colIndex) % 2 == 1)
          this.data[rowIndex][colIndex] = this.data[rowIndex][colIndex] * -1;
      }
    }
    return this;
  }

  Matrix toAdjoint() {
    assert(this.isSquare(), "Not a square matrix, error");
    this.toCofactor();
    return ~this;
  }

  Matrix inv() {
    //  TODO
    assert(this.isSquare(), 'Can not perform inverse on a non-square matrix');
    var out = Matrix.copyFrom(this);
    double det;
    det = out.det();
    assert(det.abs() > _epsilon,
        "Singular Matrix has no Inverse (Determinant is 0)");
    out.toAdjoint();
    out = out * (1 / det);
    return out;
  }

  ///  Matrix Addition
  Matrix operator +(Matrix other) {
    assert(this.row == other.row && this.col == other.col,
        'Dimension of matrixes does not match');
    var result = Matrix(data: this.data);
    result.row = other.row;
    result.col = other.col;
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        assert(this.data[i][j] != null && other.data[i][j] != null,
            'Invalid null type in addition');
        result.data[i][j] = this.data[i][j] + other.data[i][j];
      }
    }
    return result;
  }

  ///  Matrix Multiplication
  Matrix operator *(other) {
    var result = Matrix.copyFrom(this);
    //  A scaling operation of Matrix with const scale
    if (other is num) {
      for (int i = 0; i < row; i++) {
        for (int j = 0; j < col; j++) {
          result.data[i][j] = other * data[i][j];
        }
      }
    }
    //  Matrix Multiplication, O(n^3) default algorithm
    else if (other is Matrix) {
      // TODO
      result = Matrix.withSize(row: this.row, col: other.col);
      for (int i = 0; i < result.row; i++) {
        for (int j = 0; j < result.col; j++) {
          result.data[i][j] = 0;
          for (int k = 0; k < this.col; k++) {
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
    assert(col == other.row,
        'Dimension does not match for matrix multiplication.');
    return Matrix(data: [
      [1]
    ]);
  }

  /// Matrix transpose
  Matrix operator ~() {
    assert(this.size != null && this.row == this.col,
        'Can not transpose a non-square matrix');
    for (int i = 0; i < this.row; i++) {
      for (int j = i + 1; j < this.col; j++) {
        var temp = this.data[j][i];
        this.data[j][i] = this.data[i][j];
        this.data[i][j] = temp;
      }
    }
    return this;
  }

  /// Matrix power of, follows the convention of inversing matrix with <Matrix>^(-1)
  Matrix operator ^(int power) {
    assert(power >= -1,
        'Invalid power, can only perform positive power multiplication');
    //  Inverse Matrix
    var out = Matrix(data: this.data);
    if (power == -1) {
      //  TODO
      return this.inv();
    } else {
      for (int i = 0; i < power - 1; i++) {
        out = out * this;
      }
    }
    return out;
  }
}
