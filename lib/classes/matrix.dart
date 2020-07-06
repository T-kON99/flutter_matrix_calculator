class Matrix {
  int _row, _col, _size;
  List<List<double>> _data;
  List<String> _historyMessage;
  List<Matrix> _historyState;
  static const _epsilon = 0.0000000000001;

  int get row => this._row;
  int get col => this._col;
  int get size => this._size;
  List<List<double>> get data => this._data;
  List<String> get historyMessage => this._historyMessage;
  List<Matrix> get historyState => this._historyState;

  /// Generate a 0-filled matrix with custom size.
  Matrix.withSize({int row, int col}) {
    this._row = row;
    this._col = col;
    this._historyMessage = [];
    this._historyState = [];
    this._data = new List.generate(_row, (_) => List<double>.generate(_col, (_) => null));
    this._size = this._row == this._col ? this._row : null;
  }

  Matrix({List<List<double>> data}) {
    this._data = data;
    this._row = this._data.length;
    this._col = this._data[0].length;
    this._historyMessage = [];
    this._historyState = [];
    this._size = this._row == this._col ? this._row : null;
  }

  factory Matrix.copyFrom(Matrix other) {
    var copy = Matrix.withSize(row: other._row, col: other._col);
    for(int i = 0; i < copy._row; i++)
      for(int j = 0; j < copy._col; j++)
        copy._data[i][j] = other._data[i][j];
    copy._historyMessage = new List<String>.from(other._historyMessage);
    copy._historyState = new List<Matrix>.from(other._historyState);
    return copy;
  }

  bool isSquare() => this._row == this._col;

  void zeroFillResize({int col, int row}) {
    List<List<double>> newData = new List.generate(row, (indexRow) => List<double>.generate(col, (indexCol) {
      if(indexRow >= this._row || indexCol >= this._col) {
        return 0;
      }
      else return this.data[indexRow][indexCol];
    }));
    this._row = row;
    this._col = col;
    this._data = newData;
  }

  /// Determinant of a matrix
  double det() {
    if(!this.isSquare()) throw('A non-square matrix has no determinant value');
    double output = 1;
    var matGauss = this.gaussElimination();
    for (int n = 0; n < matGauss._size; n++) {
      output = output * matGauss._data[n][n];
    }
    return output;
  }

  Matrix gaussElimination() {
    var out = Matrix.copyFrom(this);
    double ratio;
    for (int j = 0; j < this._col; j++) {
      for (int i = this._row - 1; i > j; i--) {
        //  Step 1
        //  Countermeasure if the current cell is 0, we're going to perform an elementary matrix operation and add the row below
        //  to current row.
        if (out._data[i - 1][j] == 0) {
          for (int n = 0; n < this._col; n++) {
            out._data[i - 1][n] = out._data[i - 1][n] + out._data[i][n];
          }
          out._historyMessage.add('Element at Row $i, Col ${j+1} is 0, perform Elementary Row Operation Row $i = Row $i + Row ${i+1}');
          out._historyState.add(Matrix.copyFrom(out));
        }

        //  Step 2
        //  Get the ratio if applicable (non zero value, otherwise will result in dividing by 0)
        out._historyMessage.add('Get Ratio of element at Col ${j+1} which is Row ${i+1}/Row $i');
        out._historyState.add(Matrix.copyFrom(out));
        if (out._data[i - 1][j] != 0)
          ratio = out._data[i][j] / out._data[i - 1][j];
        else
          ratio = 1;

        //  Step 3
        //  Perform the elementary row operation, in this case substracting the value from row (i)-th with row (i-1)th
        for (int n = 0; n < this._col; n++) {
          out._data[i][n] = out._data[i][n] - (ratio * out._data[i - 1][n]);
        }
        out._historyMessage.add('Perform Elementary Row Operation at Row ${i + 1} = Row ${i + 1} - ($ratio * Row $i)');
        out._historyState.add(Matrix.copyFrom(out));
      }
    }
    return out;
  }

  Matrix _normalizeRE() {
    double ratio;
    for (int i = 0; i < this._row; i++) {
      for (int j = 0; j < this._col; j++) {
        if (this._data[i][j].abs() > _epsilon) {
          ratio = 1 / this._data[i][j];
          for (int n = 0; n < this._col; n++) {
            this._data[i][n] *= ratio;
            //Fixes floating point problem. Ex : 0 * -0.333333 returns -0 instead of 0.
            if (this._data[i][n].abs() < _epsilon) this._data[i][n] = 0;
          }
          this._historyMessage.add('Normalizing Row ${i+1} (Multiply by a ratio to make element at Row ${i+1}, Col ${j+1} into 1) with ratio $ratio');
          this._historyState.add(Matrix.copyFrom(this));
          break;
        }
      }
    }
    return this;
  }

  Matrix toRE() {
    this._data = this.gaussElimination()._normalizeRE()._data;
    return this;
  }

  //  TODO: ADD THE HISTORY STATE AND MESSAGE
  Matrix getRRE() {
    double ratio, temp;
    Matrix out = Matrix.copyFrom(this).getRE();
    if (out._row > 1 || out._col > 1) {
      for (int i = out._row - 1; i >= 0; i--) {
        for (int k = 0; k < out._col; k++) {
          //  GE on pivots
          if (out._data[i][k].abs() > _epsilon) {
            for (int rowThis = 0; rowThis < i; rowThis++) {
              if (out._data[rowThis + 1][k].abs() > _epsilon)
                ratio = out._data[rowThis][k] / out._data[rowThis + 1][k];
              else
                ratio = 1;
              for (int n = 0; n < _col; n++) {
                temp = ratio * out._data[rowThis + 1][n];
                out._data[rowThis][n] = out._data[rowThis][n] - temp;
              }
            }
            out._historyMessage.add('Perform Gaussian Elimination on the pivots which is on Row ${i+1}, Col ${k+1}');
            out._historyState.add(Matrix.copyFrom(out));
            break;
          }
        }
      }
    }
    return out;
  }

  /// Return a new matrix which is the RE (Row Echelon) form of given matrix.
  Matrix getRE() {
    var out = Matrix.copyFrom(this);
    out = out.gaussElimination()._normalizeRE();
    return out;
  }

  Matrix toCofactor() {
    assert(this.isSquare(), "Not a square matrix, can't calculate determinant");
    int size, rowOutput, colOutput;
    var output = Matrix.withSize(row: this._row - 1, col: this._col - 1);
    var copy = Matrix.copyFrom(this);
    size = this._size;
    rowOutput = 0;
    colOutput = 0;
    for (int rowIndex = 0; rowIndex < size; rowIndex++) {
      for (int colIndex = 0; colIndex < size; colIndex++) {
        for (int rowPos = 0; rowPos < size; rowPos++) {
          for (int colPos = 0; colPos < size; colPos++) {
            if (rowPos != rowIndex && colPos != colIndex) {
              output._data[rowOutput][colOutput++] = copy._data[rowPos][colPos];
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
        this._historyMessage.add('Get cofactor matrix by excluding Row ${rowIndex+1} & Col ${colIndex+1}');
        this._historyState.add(Matrix.copyFrom(output));
        this._data[rowIndex][colIndex] = output.det();
        this._historyMessage.add('Element Row ${rowIndex+1}, Col ${colIndex+1} has the value of the determinant of cofactor.');
        this._historyState.add(Matrix.copyFrom(this));
        if ((rowIndex + colIndex) % 2 == 1)
          this._data[rowIndex][colIndex] = this._data[rowIndex][colIndex] * -1;
        this._historyMessage.add('Multiply by -1 when Index of (Row + Col) = (${rowIndex+1} + ${colIndex+1}) is not divisible by 2');
        this._historyState.add(Matrix.copyFrom(this));
      }
    }
    return this;
  }

  Matrix toAdjoint() {
    assert(this.isSquare(), "Not a square matrix, error");
    this.toCofactor();
    return ~this;
  }

  //  TODO: Implement Faster inv with just concatenating n x n matrix with n x n Identity matrix and then taking RRE.
  //  Inverse will be the right side of the matrix (Was identity)
  Matrix inv() {
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
    assert(this._row == other._row && this._col == other._col,
        'Dimension of matrixes does not match');
    var result = Matrix.copyFrom(this);
    result._row = other._row;
    result._col = other._col;
    for (int i = 0; i < _row; i++) {
      for (int j = 0; j < _col; j++) {
        assert(this._data[i][j] != null && other._data[i][j] != null,
            'Invalid null type in addition');
        result._data[i][j] = this._data[i][j] + other._data[i][j];
        result._historyMessage.add('Add element at position Row ${i+1}, Col ${j+1}: ${this._data[i][j]} + ${other._data[i][j]} = ${result._data[i][j]}');
        result._historyState.add(Matrix.copyFrom(result));
      }
    }
    return result;
  }

  ///  Matrix Multiplication
  Matrix operator *(other) {
    var result = Matrix.copyFrom(this);
    //  A scaling operation of Matrix with const scale
    if (other is num) {
      for (int i = 0; i < _row; i++) {
        for (int j = 0; j < _col; j++) {
          result._data[i][j] = other * _data[i][j];
          result._historyMessage.add('Multiply $other with element at Row ${i+1}, Col ${j+1}: $other * ${_data[i][j]} = ${result._data[i][j]}');
          result._historyState.add(Matrix.copyFrom(result));
        }
      }
    }
    //  Matrix Multiplication, O(n^3) default algorithm
    else if (other is Matrix) {
      result = Matrix.withSize(row: this._row, col: other._col);
      for (int i = 0; i < result._row; i++) {
        for (int j = 0; j < result._col; j++) {
          result._data[i][j] = 0;
          for (int k = 0; k < this._col; k++) {
            result._data[i][j] += this._data[i][k] * other._data[k][j];
          }
          result._historyMessage.add('Perform a dot product on First Matrix Row ${i+1} & Second Matrix Col ${j+1}, result will be element at Row ${i+1}, Col ${j+1}');
          result._historyState.add(Matrix.copyFrom(result));
        }
      }
    }
    return result;
  }

  ///  Matrix substraction
  //  Not utizing overloaded + operator because this is indeed faster
  //  Rather than performing -1 * other which costs O(n^2) already and then perform the Add which is another O(n^2),
  //  We just do it in one go.
  Matrix operator -(Matrix other) {
    assert(this._row == other._row && this._col == other._col,
        'Dimension of matrixes does not match');
    var result = Matrix.copyFrom(this);
    result._row = other._row;
    result._col = other._col;
    for (int i = 0; i < _row; i++) {
      for (int j = 0; j < _col; j++) {
        assert(this._data[i][j] != null && other._data[i][j] != null,
            'Invalid null type in addition');
        result._data[i][j] = this._data[i][j] - other._data[i][j];
        result._historyMessage.add('Subtract element at position Row ${i+1}, Col ${j+1}: ${this._data[i][j]} - ${other._data[i][j]} = ${result._data[i][j]}');
        result._historyState.add(Matrix.copyFrom(result));
      }
    }
    return result;
  }

  /// Matrix transpose
  Matrix operator ~() {
    assert(this._size != null && this._row == this._col,
        'Can not transpose a non-square matrix');
    for (int i = 0; i < this._row; i++) {
      for (int j = i + 1; j < this._col; j++) {
        var temp = this._data[j][i];
        this._data[j][i] = this._data[i][j];
        this._data[i][j] = temp;
      }
    }
    this._historyMessage.add('Transpose Matrix');
    this._historyState.add(Matrix.copyFrom(this));
    return this;
  }

  /// Matrix power of, follows the convention of inversing matrix with <Matrix>^(-1)
  Matrix operator ^(int power) {
    assert(power >= -1,
        'Invalid power, can only perform positive power multiplication');
    //  Inverse Matrix
    var out = Matrix(data: this._data);
    if (power == -1) {
      return this.inv();
    } else {
      for (int i = 0; i < power - 1; i++) {
        out = out * this;
      }
    }
    return out;
  }

  String getMathJexText({String parentheses}) {
    final Map<String, String> tags = {
      "plain": "matrix",
      "round": "pmatrix",
      "square": "bmatrix",
      "curly": "Bmatrix",
      "one-pipe": "vmatrix",
      "double-pipe": "Vmatrix"
    };
    assert(tags.containsKey(parentheses), "Invalid type of parentheses.");
    String tag = tags[parentheses];
    String latexMatrix = this.data.map((row) => row.join('&')).join(r'\\');
    String latexText = r"$$\begin""{$tag}""$latexMatrix"r"\end""{$tag}\$\$";
    return latexText;
  }
}
