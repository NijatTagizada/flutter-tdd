import 'package:dartz/dartz.dart';
import 'package:flutter_tdd/domain/entities/number_trivia.dart';
import 'package:flutter_tdd/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tdd/domain/usecases/get_concrete_number.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_concrete_number_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
void main() {
  late GetConcreteNumber usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  const int tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumber(repository: mockNumberTriviaRepository);
  });

  test('get trivia for number from the repository', () async {
    when(mockNumberTriviaRepository.getConcreteNumber(any))
        .thenAnswer((_) async => const Right(tNumberTrivia));

    final result = await usecase(const Params(number: tNumber));
    expect(result, const Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumber(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
