import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tdd/core/error/failures.dart';
import 'package:flutter_tdd/core/usecases/usecase.dart';

import '../../../core/utils/input_converter.dart';
import '../../../domain/entities/number_trivia.dart';
import '../../../domain/usecases/get_concrete_number.dart';
import '../../../domain/usecases/get_random_number.dart';

part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaCubit extends Cubit<NumberTriviaState> {
  NumberTriviaCubit({
    required this.getConcreteNumber,
    required this.getRandomNumber,
    required this.inputConverter,
  }) : super(Empty());

  final GetConcreteNumber getConcreteNumber;
  final GetRandomNumber getRandomNumber;
  final InputConverter inputConverter;

  void getTriviaNumberConcrete(String number) {
    final inputEither = inputConverter.stringToUnsignedInteger(number);
    inputEither.fold(
      (l) => emit(const Error(message: invalidInputFailureMessage)),
      (triviaNumber) async {
        emit(Loading());
        final result = await getConcreteNumber.call(
          Params(number: triviaNumber),
        );

        result.fold(
          (failure) => emit(
            Error(message: _mapFailureToMessage(failure)),
          ),
          (numberTrivia) => emit(Loaded(trivia: numberTrivia)),
        );
      },
    );
  }

  void getRandomNumberTrivia() async {
    emit(Loading());
    final result = await getRandomNumber(NoParams());

    result.fold(
      (failure) => emit(Error(message: _mapFailureToMessage(failure))),
      (numberTrivia) => emit(Loaded(trivia: numberTrivia)),
    );
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return serverFailureMessage;
    case CacheFailure:
      return cacheFailureMessage;
    default:
      return 'Unexpected error';
  }
}
