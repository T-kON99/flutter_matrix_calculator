class Token {
  int _type;
  dynamic _value;

  int get type => this._type;
  dynamic get value => this._value;

  Token(int type, dynamic value) {
    this._type = type;
    this._value = value;
  }
}

class TokenType {
  static const int OP = 1;
  static const int NUM = 2;
  static const int OPAREN = 3;
  static const int CPAREN = 4;
  static const int VAR = 5;
  static const int END = 6;
}

class Tokenize {
  String _str;
  List<Token> result;

  String get str => this._str;

  Tokenize(String input) {
    this._str = input;
    this.result = [];
  }

  List tokenize() {
    this._str = this._str.replaceAll(new RegExp(r"\s+"), "");
    List temp = this._str.split("");
    temp.forEach((char) {
      if (_isOperator(char))
        result.add(Token(TokenType.OP, char));
      else if (_isDigit(char))
        result.add(Token(TokenType.NUM, char));
      else if (_isOParen(char))
        result.add(Token(TokenType.OPAREN, char));
      else if (_isCParen(char))
        result.add(Token(TokenType.CPAREN, char));
      else if (_isAlphabet(char))
        result.add(Token(TokenType.VAR, char));
      else
        throw('Syntax Error');
    });
    // str.forEach(function (char, idx) {    if(isDigit(char)) {      result.push(new Token("Literal", char));    } else if (isLetter(char)) {      result.push(new Token("Variable", char));    } else if (isOperator(char)) {      result.push(new Token("Operator", char));    } else if (isLeftParenthesis(char)) {      result.push(new Token("Left Parenthesis", char));    } else if (isRightParenthesis(char)) {      result.push(new Token("Right Parenthesis", char));    } else if (isComma(char)) {      result.push(new Token("Function Argument Separator", char));    }  });
    return result;
  }

  bool _isDigit(String char) => new RegExp(r"(?:[1-9]\d*|0)(?:\.\d+)?").hasMatch(char);
  bool _isOperator(String char) => new RegExp(r"[+*/^-]").hasMatch(char);
  bool _isOParen(String char) => char == '(';
  bool _isCParen(String char) => char == ')';
  bool _isAlphabet(String char) => new RegExp(r"[a-z]").hasMatch(char);
}
