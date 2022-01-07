import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../core/platform/network_info.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../datasources/number_trivia_local_data_source.dart';
import '../datasources/number_trivia_remote_data_source.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  late NumberTriviaRemoteDataSource remoteDataSource;
  late NumberTriviaLocalDataSource localDataSource;
  late NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumber(int number) async {
    networkInfo.isConnected;
    return Right(await remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumber() {
    // TODO: implement getRandomNumber
    throw UnimplementedError();
  }
}
