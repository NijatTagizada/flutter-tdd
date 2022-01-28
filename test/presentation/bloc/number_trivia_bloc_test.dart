import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_tdd/core/error/failures.dart';
import 'package:flutter_tdd/core/usecases/usecase.dart';
import 'package:flutter_tdd/core/utils/input_converter.dart';
import 'package:flutter_tdd/domain/entities/number_trivia.dart';
import 'package:flutter_tdd/domain/usecases/get_concrete_number.dart';
import 'package:flutter_tdd/domain/usecases/get_random_number.dart';
import 'package:flutter_tdd/presentation/bloc/number_trivia/number_trivia_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([
  GetConcreteNumber,
  GetRandomNumber,
  InputConverter,
])
main() {
  late NumberTriviaCubit bloc;
  late MockGetRandomNumber mockGetRandomNumber;
  late MockGetConcreteNumber mockGetConcreteNumber;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockInputConverter = MockInputConverter();
    mockGetConcreteNumber = MockGetConcreteNumber();
    mockGetRandomNumber = MockGetRandomNumber();

    bloc = NumberTriviaCubit(
      getConcreteNumber: mockGetConcreteNumber,
      getRandomNumber: mockGetRandomNumber,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'Test trivia', number: 1);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(const Right(tNumberParsed));
    blocTest<NumberTriviaCubit, NumberTriviaState>(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      build: () => bloc,
      setUp: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumber(any)).thenAnswer(
          (_) async => Right(tNumberTrivia),
        );
      },
      act: (cubit) => bloc.getTriviaNumberConcrete(tNumberString),
      verify: (bloc) {
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    blocTest<NumberTriviaCubit, NumberTriviaState>(
      'should emit [Error] when the input is invalid',
      setUp: () {
        when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(
          Left(InvalidInputFailure()),
        );
      },
      build: () => bloc,
      act: (_) => bloc.getTriviaNumberConcrete('fw23'),
      expect: () => [
        const Error(message: invalidInputFailureMessage),
      ],
    );

    blocTest<NumberTriviaCubit, NumberTriviaState>(
      'should get data from the concrete use case',
      build: () => bloc,
      act: (bloc) => bloc.getTriviaNumberConcrete(tNumberString),
      setUp: () {
        setUpMockInputConverterSuccess();

        when(mockGetConcreteNumber(any)).thenAnswer(
          (_) async => Right(tNumberTrivia),
        );
      },
      verify: (bloc) {
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
        verify(mockGetConcreteNumber(const Params(number: tNumberParsed)));
      },
    );

    blocTest(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () => bloc,
      setUp: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumber(any)).thenAnswer(
          (_) async => Right(tNumberTrivia),
        );
      },
      act: (_) => bloc.getTriviaNumberConcrete(tNumberString),
      expect: () => [
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ],
    );

    blocTest(
      'should emit [Loading, Error] when getting data fails',
      build: () => bloc,
      setUp: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumber(any)).thenAnswer(
          (_) async => Left(ServerFailure()),
        );
      },
      act: (_) => bloc.getTriviaNumberConcrete(tNumberString),
      expect: () => [
        Loading(),
        const Error(message: serverFailureMessage),
      ],
    );

    blocTest(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      build: () => bloc,
      setUp: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumber(any)).thenAnswer(
          (_) async => Left(CacheFailure()),
        );
      },
      act: (_) => bloc.getTriviaNumberConcrete(tNumberString),
      expect: () => [
        Loading(),
        const Error(message: cacheFailureMessage),
      ],
    );
  });

  group('GetRandomTriviaNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'Test trivia', number: 1);

    blocTest<NumberTriviaCubit, NumberTriviaState>(
      'should get data from the random use case',
      build: () => bloc,
      act: (bloc) => bloc.getRandomNumberTrivia(),
      setUp: () {
        when(mockGetRandomNumber.call(any)).thenAnswer(
          (_) async => Right(tNumberTrivia),
        );
      },
      verify: (bloc) {
        verify(mockGetRandomNumber.call((NoParams())));
      },
    );

    blocTest(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () => bloc,
      setUp: () {
        when(mockGetRandomNumber(any)).thenAnswer(
          (_) async => Right(tNumberTrivia),
        );
      },
      act: (_) => bloc.getRandomNumberTrivia(),
      expect: () => [
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ],
    );

    blocTest(
      'should emit [Loading, Error] when getting data fails',
      build: () => bloc,
      setUp: () {
        when(mockGetRandomNumber(any)).thenAnswer(
          (_) async => Left(ServerFailure()),
        );
      },
      act: (_) => bloc.getRandomNumberTrivia(),
      expect: () => [
        Loading(),
        const Error(message: serverFailureMessage),
      ],
    );

    blocTest(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      build: () => bloc,
      setUp: () {
        when(mockGetRandomNumber(any)).thenAnswer(
          (_) async => Left(CacheFailure()),
        );
      },
      act: (_) => bloc.getRandomNumberTrivia(),
      expect: () => [
        Loading(),
        const Error(message: cacheFailureMessage),
      ],
    );
  });
}
