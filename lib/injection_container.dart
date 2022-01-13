import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/utils/input_converter.dart';
import 'data/datasources/number_trivia_local_data_source.dart';
import 'data/datasources/number_trivia_remote_data_source.dart';
import 'data/repositories/number_trivia_repository_impl.dart';
import 'domain/repositories/number_trivia_repository.dart';
import 'domain/usecases/get_concrete_number.dart';
import 'domain/usecases/get_random_number.dart';
import 'presentation/bloc/number_trivia/number_trivia_cubit.dart';

final di = GetIt.instance;
Future<void> init() async {
  //! Features - Number Trivia

  //bloc
  di.registerFactory(
    () => NumberTriviaCubit(
      getConcreteNumber: di(),
      getRandomNumber: di(),
      inputConverter: di(),
    ),
  );

  // Use cases
  di.registerLazySingleton(() => GetConcreteNumber(repository: di()));
  di.registerLazySingleton(() => GetRandomNumber(repository: di()));

  // Repository
  di.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: di(),
      localDataSource: di(),
      networkInfo: di(),
    ),
  );

  // Data sources
  di.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(di()),
  );

  di.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: di()),
  );

  //! Core
  di.registerLazySingleton(() => InputConverter());
  di.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(di()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerLazySingleton(() => sharedPreferences);
  di.registerLazySingleton(
      () => Dio()..options.baseUrl = 'http://numbersapi.com/');
  di.registerLazySingleton(() => Connectivity());
}
