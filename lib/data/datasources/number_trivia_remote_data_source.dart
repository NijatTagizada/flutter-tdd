import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/number_trivia_model.dart';

part 'number_trivia_remote_data_source.g.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number}?json endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random?json endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

@RestApi()
abstract class NumberTriviaRemoteDataSourceImpl
    implements NumberTriviaRemoteDataSource {
  factory NumberTriviaRemoteDataSourceImpl(Dio dio, {String baseUrl}) =
      _NumberTriviaRemoteDataSourceImpl;

  @GET('{number}?json')
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(@Path('number') int number);

  @GET('random?json')
  @override
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
