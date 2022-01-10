import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_tdd/core/error/exceptions.dart';
import 'package:flutter_tdd/core/error/failures.dart';
import 'package:flutter_tdd/core/network/network_info.dart';
import 'package:flutter_tdd/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd/data/models/number_trivia_model.dart';
import 'package:flutter_tdd/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tdd/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'package:mockito/mockito.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks([
  NumberTriviaRemoteDataSource,
  NumberTriviaLocalDataSource,
  NetworkInfo,
])
void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockNumberTriviaLocalDataSource mockLocalDataSource;
  final requestOpt = RequestOptions(path: 'test');

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'Test trivia');
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer(
        (_) async => tNumberTriviaModel,
      );

      // act
      await repository.getConcreteNumber(tNumber);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer(
          (_) async => tNumberTriviaModel,
        );

        final result = await repository.getConcreteNumber(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));

        expect(result, const Right(tNumberTrivia));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer(
          (_) async => tNumberTriviaModel,
        );

        await repository.getConcreteNumber(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(DioError(requestOptions: requestOpt));

        final result = await repository.getConcreteNumber(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });

    runTestOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer(
            (_) async => tNumberTriviaModel,
          );

          final result = await repository.getConcreteNumber(tNumber);
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, const Right(tNumberTriviaModel));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());

          final result = await repository.getConcreteNumber(tNumber);
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(number: 123, text: 'Test trivia');
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer(
        (_) async => tNumberTriviaModel,
      );

      // act
      await repository.getRandomNumber();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer(
          (_) async => tNumberTriviaModel,
        );

        final result = await repository.getRandomNumber();

        verify(mockRemoteDataSource.getRandomNumberTrivia());

        expect(result, const Right(tNumberTrivia));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer(
          (_) async => tNumberTriviaModel,
        );

        await repository.getRandomNumber();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(DioError(requestOptions: requestOpt));

        final result = await repository.getRandomNumber();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });

    runTestOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer(
            (_) async => tNumberTriviaModel,
          );

          final result = await repository.getRandomNumber();
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, const Right(tNumberTriviaModel));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());

          final result = await repository.getRandomNumber();
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });
}
