import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_tdd/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([HttpClientAdapter])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClientAdapter mockHttpClientAdapter;

  setUp(() {
    mockHttpClientAdapter = MockHttpClientAdapter();

    dataSource = NumberTriviaRemoteDataSourceImpl(
      Dio()
        ..options.baseUrl = 'http://numbersapi.com/'
        ..httpClientAdapter = mockHttpClientAdapter,
    );
  });

  setUpMockHttpAdapter200() {
    final triviaJson = fixture('trivia.json');
    when(mockHttpClientAdapter.fetch(any, any, any)).thenAnswer(
      (_) async => ResponseBody.fromString(
        triviaJson,
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    );
  }

  setUpMockHttpAdapter404() {
    final triviaJson = fixture('trivia.json');

    when(mockHttpClientAdapter.fetch(any, any, any)).thenAnswer(
      (_) async => ResponseBody.fromString(
        triviaJson,
        404,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    );
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;

    test(
      'should preform a GET request on a URL with number being the endpoint and with application/json header',
      () async {
        final triviaJson = fixture('trivia.json');

        setUpMockHttpAdapter200();

        final result = await dataSource.getConcreteNumberTrivia(tNumber);

        expect(result, NumberTriviaModel.fromJson(json.decode(triviaJson)));
      },
    );

    test('should throw DioError', () async {
      setUpMockHttpAdapter404();

      final call = dataSource.getConcreteNumberTrivia;

      expect(() => call(tNumber), throwsA(isInstanceOf<DioError>()));
    });
  });

  group('getRandomNumberTrivia', () {
    test(
      'should preform a GET request on a URL with number being the endpoint and with application/json header',
      () async {
        final triviaJson = fixture('trivia.json');

        setUpMockHttpAdapter200();

        final result = await dataSource.getRandomNumberTrivia();

        expect(result, NumberTriviaModel.fromJson(json.decode(triviaJson)));
      },
    );

    test('should throw DioError', () async {
      setUpMockHttpAdapter404();

      final call = dataSource.getRandomNumberTrivia;

      expect(() => call(), throwsA(isInstanceOf<DioError>()));
    });
  });
}
