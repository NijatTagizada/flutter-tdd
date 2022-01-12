import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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

  final GetConcreteNumber? getConcreteNumber;
  final GetRandomNumber getRandomNumber;
  final InputConverter inputConverter;

  void getTriviaNumberConcrete(String number) {
    final inputEither = inputConverter.stringToUnsignedInteger(number);
    inputEither.fold(
      (l) => emit(const Error(message: invalidInputFailureMessage)),
      (integer) => Right(integer),
    );
  }
}
