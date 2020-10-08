import 'package:tuple/tuple.dart';

class Matrix {
  int _row, _col, _size;
  List<List<double>> _data;
  List<String> _historyMessage;
  List<Matrix> _historyState;
  List<Tuple2<int, int>> _historyHighlight;
  Tuple2<String, String> _historyMessageSymbol = Tuple2(r'$i', r'$j');
  static const int _historyPrecision = 3;
  static const _epsilon = 0.0000000001;

  int get row => this._row;
  int get col => this._col;
  int get size => this._size;
  List<List<double>> get data => this._data;
  List<String> get historyMessage => this._historyMessage;
  List<Matrix> get historyState => this._historyState;
  List<Tuple2<int, int>> get historyHighlight => this._historyHighlight;
  Tuple2<String, String> get historyMessageSymbol => this._historyMessageSymbol;

  /// Generate a 0-filled matrix with custom size.
  Matrix.withSize({int row, int col}) {
    assert(row >= 1 && col >= 1, 'Dimension of the matrix at least be 1 or bigger');
    this._row = row;
    this._col = col;
    this._historyMessage = [];
    this._historyState = [];
    this._historyHighlight = [];
    this._data = new List.generate(_row, (_) => List<double>.generate(_col, (_) => null));
    this._size = this._row == this._col ? this._row : null;
  }

  Matrix.identity({int size}) {
    assert(size >= 1, 'Dimension of the matrix at least be 1 or bigger');
    this._row = size;
    this._col = size;
    this._size = size;
    this._historyMessage = [];
    this._historyState = [];
    this._historyHighlight = [];
    this._data = new List.generate(_row, (rowIndex) => List<double>.generate(_col, (colIndex) => rowIndex == colIndex ? 1 : 0));
  }

  Matrix({List<List<double>> data}) {
    this._data = data;
    this._row = this._data.length;
    this._col = this._data[0].length;
    this._historyMessage = [];
    this._historyState = [];
    this._historyHighlight = [];
    this._size = this._row == this._col ? this._row : null;
  }

  factory Matrix.copyFrom(Matrix other, {bool copyHistory = true}) {
    var copy = Matrix.withSize(row: other._row, col: other._col);
    for(int i = 0; i < copy._row; i++)
      for(int j = 0; j < copy._col; j++)
        copy._data[i][j] = other._data[i][j];
    if (copyHistory) {
      copy._historyMessage = new List<String>.from(other._historyMessage);
      copy._historyState = new List<Matrix>.from(other._historyState);
      copy._historyHighlight = new List<Tuple2<int, int>>.from(other._historyHighlight);
    }
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

  void _copyHistory(Matrix other) {
    this._historyMessage = new List<String>.from(other._historyMessage);
    this._historyState = new List<Matrix>.from(other._historyState);
    this._historyHighlight = new List<Tuple2<int, int>>.from(other._historyHighlight);
  }

  //  This method will replace message $i with row from highlights value.
  void historyAdd({String message, Matrix state, Tuple2<int, int> highlights}) {
    this._historyMessage.add(message);
    this._historyState.add(state);
    this._historyHighlight.add(highlights);
  }

  /// This mutates current object
  Matrix shift({int length}) {
    assert(length < this._col, "Shift size must be less than the number of columns of the matrix");
    String originalMatrix = this.getMathJexText();
    for(int i = 0; i < this._row; i++) {
      this._data[i] = this._data[i].sublist(length);
    }
    this._col = this._col - length;
    this.historyAdd(
      message: 'Shift matrix $length to the right $originalMatrix Deleting columns less than $length',
      state: Matrix.copyFrom(this, copyHistory: false),
      highlights: Tuple2(null, null)
    );
    return this;
  }

  /// Determinant of a matrix
  double det() {
    if(!this.isSquare()) throw('A non-square matrix has no determinant value');
    double output = 1;
    Matrix matGauss = this.gaussElimination();
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
          out.historyAdd(
            message: 'Element at \$\$(Row_{$i}, Col_{${j+1}}) = 0\$\$. Perform Elementary Row Operation \$\$Row_{$i} = Row_{$i} + Row_{${i+1}}\$\$',
            state: Matrix.copyFrom(out, copyHistory: false),
            highlights: Tuple2(i, j + 1),
          );
        }

        //  Step 2
        //  Get the ratio if applicable (non zero value, otherwise will result in dividing by 0)
        out.historyAdd(
          message: 'Get Ratio of element at \$\$(Row_{${i+1}}, Col_{${j+1}}) = \\frac{(Row_{${i+1}}, Col_{${j+1}})}{(Row_{${i}}, Col_{${j+1}})}\$\$',
          state: Matrix.copyFrom(out, copyHistory: false),
          highlights: Tuple2(i + 1, j + 1),
        );
        if (out._data[i - 1][j] != 0)
          ratio = out._data[i][j] / out._data[i - 1][j];
        else
          ratio = 1;

        //  Step 3
        //  Perform the elementary row operation, in this case substracting the value from row (i)-th with row (i-1)th
        for (int n = 0; n < this._col; n++) {
          out._data[i][n] = out._data[i][n] - (ratio * out._data[i - 1][n]);
        }
        out.historyAdd(
          message: 'Perform Elementary Row Operation \$\$R_{${i + 1}} = R_{${i + 1}} - (${ratio.toStringAsPrecision(_historyPrecision)} * R_{$i})\$\$',
          state: Matrix.copyFrom(out, copyHistory: false),
          highlights: Tuple2(i + 1, j + 1)
        );
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
          this.historyAdd(
            message: 'Normalizing \\(Row_{${i+1}}\\).<br>Multiply row by \\(${ratio.toStringAsPrecision(_historyPrecision)}\\) to make element at \$\$(Row_{${i+1}}, Col_{${j+1}})\$\$ into 1',
            state: Matrix.copyFrom(this, copyHistory: false),
            highlights: Tuple2(i + 1, j + 1),
          );
          break;
        }
      }
    }
    return this;
  }

  Matrix toRE() {
    this._data = this.gaussElimination()._data;
    return this;
  }

  //  TODO: ADD THE HISTORY STATE AND MESSAGE
  Matrix getRRE() {
    double ratio, temp;
    Matrix out = Matrix.copyFrom(this).getRE()._normalizeRE();
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
            out.historyAdd(
              message: 'Perform Gaussian Elimination on the pivots which is on \$\$(Row_{${i+1}}, Col_{${k+1}})\$\$',
              state: Matrix.copyFrom(out, copyHistory: false),
              highlights: Tuple2(i + 1, k + 1),
            );
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
    out = out.gaussElimination();
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
        this.historyAdd(
          message: 'Get cofactor matrix by excluding \\(Row_{${rowIndex+1}}\\) and \\(Col_{${colIndex+1}}\\)',
          state: Matrix.copyFrom(output, copyHistory: false),
          highlights: Tuple2(null, null),
        );

        this._data[rowIndex][colIndex] = output.det();

        this.historyAdd(
          message: 'Element \\((Row_{${rowIndex+1}}, Col_{${colIndex+1}})\\) has the value of the determinant of cofactor.',
          state: Matrix.copyFrom(this, copyHistory: false),
          highlights: Tuple2(rowIndex + 1, colIndex + 1),
        );

        if ((rowIndex + colIndex) % 2 == 1)
          this._data[rowIndex][colIndex] = this._data[rowIndex][colIndex] * -1;
        
        this.historyAdd(
          message: 'Multiply by -1 when Index of \$\$Row_{${rowIndex+1}} + Col_{${colIndex+1}} = ${rowIndex+1} + ${colIndex+1}\$\$ is not divisible by 2',
          state: Matrix.copyFrom(this, copyHistory: false),
          highlights: Tuple2(rowIndex + 1, colIndex + 1),
        );
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
    Matrix expanded = out & Matrix.identity(size: out.size);
    Matrix result = expanded.getRRE();
    result.shift(length: out._size);
    return result;
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

        result.historyAdd(
          message: 'Add element at position \$\$(Row_{${i+1}}, Col_{${j+1}}) = ${this._data[i][j]} + ${other._data[i][j]} = ${result._data[i][j]}\$\$',
          state: Matrix.copyFrom(result, copyHistory: false),
          highlights: Tuple2(i + 1, j + 1),
        );
        result._data[i][j] = this._data[i][j] + other._data[i][j];
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
          result.historyAdd(
            message: 'Multiply \\($other\\) with element at \$\$(Row_{${i+1}}, Col_{${j+1}}) = $other * ${_data[i][j]} = ${result._data[i][j]}\$\$',
            state: Matrix.copyFrom(result, copyHistory: false),
            highlights: Tuple2(i + 1, j + 1),
          );
        }
      }
    }
    //  Matrix Multiplication, O(n^3) default algorithm
    else if (other is Matrix) {
      assert(this._col == other._row, 'Dimension of the matrixes must obey matrix multiplication law which is m x n * n x k');
      result = Matrix.withSize(row: this._row, col: other._col);
      result._copyHistory(this);
      for (int i = 0; i < result._row; i++) {
        for (int j = 0; j < result._col; j++) {
          result._data[i][j] = 0;
          for (int k = 0; k < this._col; k++) {
            result._data[i][j] += this._data[i][k] * other._data[k][j];
          }
          result.historyAdd(
            message: 'Perform a dot product on First Matrix\'s \\(Row_{${i+1}}\\) and Second Matrix\'s \\(Col_{${j+1}}\\). <br>Result will be element at \\((Row_{${i+1}}, Col_{${j+1}})\\)',
            state: Matrix.copyFrom(result, copyHistory: false),
            highlights: Tuple2(i + 1, j + 1),
          );
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
        result.historyAdd(
          message: 'Subtract element at position \$\$(Row_{${i+1}}, Col_{${j+1}}) = ${this._data[i][j]} - ${other._data[i][j]} = ${result._data[i][j]}\$\$',
          state: Matrix.copyFrom(result, copyHistory: false),
          highlights: Tuple2(i + 1, j + 1),
        );
      }
    }
    return result;
  }

  /// Matrix transpose
  Matrix operator ~() {
    Matrix original = Matrix.copyFrom(this);
    this.zeroFillResize(col: original._row, row: original._col);
    for (int i = 0; i < original._row; i++) {
      for (int j = 0; j < original._col; j++) {
        this._data[j][i] = original._data[i][j];
      }
    }
    this.historyAdd(
      message: 'Transpose Matrix',
      state: Matrix.copyFrom(this, copyHistory: false),
      highlights: Tuple2(null, null),
    );
    return this;
  }

  /// Matrix power of, follows the convention of inversing matrix with <Matrix>^(-1)
  Matrix operator ^(int power) {
    assert(power >= -1 && this.isSquare(),
        'Invalid power, can only perform positive power multiplication on square matrixes');
    //  Inverse Matrix
    Matrix out = Matrix.copyFrom(this);
    Matrix result = Matrix.identity(size: this.size);
    if (power == -1) {
      return this.inv();
    } else {
      while (power > 0) {
        if (power % 2 == 1) {
          result *= out;
        }
        out *= out;
        power ~/= 2;
      }
    }
    return result;
  }

  /// Matrix concatenation. Row has to be equal.
  Matrix operator &(Matrix other) {
    assert(this._row == other._row, 'Row has to match');
    Matrix out = Matrix.copyFrom(this);
    Matrix dummy = Matrix.copyFrom(out);
    int initColSize = out._col;
    out.zeroFillResize(row: out._row, col: out._col + other._col);
    for(int i = 0; i < out._row; i++) {
      for(int j = 0; j < other._col; j++) {
        out._data[i][j + initColSize] = other._data[i][j];
      }
    }
    out.historyAdd(
      message: 'Concatenate Matrix ${other.getMathJexText()} With our original Matrix ${dummy.getMathJexText()} To get',
      state: Matrix.copyFrom(out, copyHistory: false),
      highlights: Tuple2(null, null)
    );
    return out;
  }

  String getMathJexText({String parentheses = 'square', int precision = Matrix._historyPrecision, String highlightColor = 'yellow', int highlightRow, int highlightCol}) {
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
    String latexMatrix = this.data.asMap().map((rowIndex, row) {
      var temp = row.asMap().map((colIndex, value) {
        String newValue = value?.toStringAsPrecision(precision);
        return MapEntry(colIndex, rowIndex == highlightRow && colIndex == highlightCol ? r"\colorbox{""$highlightColor}""{""$newValue""}" : newValue);
      }).values;
      return MapEntry(rowIndex, temp.join('&'));
    }).values.join(r'\\');
    String latexText = r"$$\begin""{$tag}""$latexMatrix"r"\end""{$tag}\$\$";
    return latexText;
  }

  String getHistoryText({int precision = Matrix._historyPrecision}) {
    assert(this._historyHighlight.length == this._historyMessage.length && this._historyMessage.length == this._historyState.length, "Size of history must match");
    String result = "";
    for(int i = 0; i < this._historyMessage.length; i++) {
      int rowHighlight = this._historyHighlight[i].item1 == null ? null : this._historyHighlight[i].item1 - 1;
      int colHighlight = this._historyHighlight[i].item2 == null ? null : this._historyHighlight[i].item2 - 1;
      result += "\\(${i+1}. \\)" + this._historyMessage[i] + '\n' + this._historyState[i].getMathJexText(highlightRow: rowHighlight, highlightCol: colHighlight, precision: precision) + '\n';
    }
    result += "Operation Result""\n" + this.getMathJexText(precision: precision) + '\n';
    return result;
  }
}
