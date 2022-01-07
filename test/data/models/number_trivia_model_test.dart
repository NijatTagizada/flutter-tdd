import 'dart:convert';

import 'package:flutter_tdd/data/models/number_trivia_model.dart';
import 'package:flutter_tdd/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test text');

  test('should be subclass of NumberTrivia entity', () {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return valid model when the JSON number is an integer', () {
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, tNumberTriviaModel);
    });

    test('should return valid model when the JSON number is an double', () {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, tNumberTriviaModel);
    });

    group('toJson', () {
      test('should retrun a JSON map containing the proper data', () {
        final result = tNumberTriviaModel.toJson();

        final expectedMap = {
          "text": "Test text",
          "number": 1,
        };

        expect(result, expectedMap);
      });
    });
  });
}
