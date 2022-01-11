import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
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

  mockInputConverter = MockInputConverter();
  mockGetConcreteNumber = MockGetConcreteNumber();
  mockGetRandomNumber = MockGetRandomNumber();

  bloc = NumberTriviaCubit(
    getConcreteNumber: mockGetConcreteNumber,
    getRandomNumber: mockGetRandomNumber,
    inputConverter: mockInputConverter,
  );

  test('initialState should be Empty', () {
    // assert
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberPased = 1;
    const tNumberTrivia = NumberTrivia(text: 'Test trivia', number: 1);

    // test(
    //   'should call the InputConverter to validate and convert the string to an unsigned integer',
    //   () async {
    //     when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(
    //       const Right(tNumberPased),
    //     );

    //     bloc.getTriviaNumberConcrete(tNumberString);

    //     await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

    //     verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    //   },
    // );

    blocTest<NumberTriviaCubit, NumberTriviaState>(
      'should emit [Error] when the input is invalid',
      build: () => bloc,
      setUp: () {
        when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(
          const Right(tNumberPased),
        );
      },
      act: (cubit) => bloc.getTriviaNumberConcrete(tNumberString),
      verify: (bloc) {
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    // test('should emit [Error] when the input is invalid', () {
    //   when(mockInputConverter.stringToUnsignedInteger(any))
    //       .thenReturn(Left(InvalidInputFailure()));

    //   final expexted = [
    //     Empty(),
    //     const Error(message: INVALID_INPUT_FAILURE_MESSAGE),
    //   ];

    //   bloc.getTriviaNumberConcrete(tNumberString);
    //   expectLater(bloc.stream, emitsInOrder(expexted));
    // });
  });
}
