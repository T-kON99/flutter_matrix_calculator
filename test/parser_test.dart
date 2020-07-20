import 'package:flutter_test/flutter_test.dart';
import 'package:matrix_calculator/classes/matrix.dart';
import 'package:matrix_calculator/classes/tokenizer.dart';

void main() {
  test('Tokenize one Matrix', () {
    final token = Tokenize('3.1 + sin(2x)');
    token.tokenize().forEach((e) => print('${e.type}, ${e.value}'));
    expect(token.tokenize(), [1]);
  });
}