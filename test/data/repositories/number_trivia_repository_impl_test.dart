import 'package:flutter_tdd/core/platform/network_info.dart';
import 'package:flutter_tdd/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd/data/repositories/number_trivia_repository_impl.dart';
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
  NumberTriviaRepositoryImpl repository;
  MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;
  MockNumberTriviaLocalDataSource mockLocalDataSource;

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
}
