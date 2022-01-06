import 'package:dartz/dartz.dart';
import 'package:flutter_tdd/core/usecases/usecase.dart';
import 'package:flutter_tdd/domain/entities/number_trivia.dart';
import 'package:flutter_tdd/domain/usecases/get_random_number.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_concrete_number_test.mocks.dart';

void main() {
  late GetRandomNumber usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumber(repository: mockNumberTriviaRepository);
  });

  test('get random trivia from the repository', () async {
    when(mockNumberTriviaRepository.getRandomNumber())
        .thenAnswer((_) async => const Right(tNumberTrivia));

    final result = await usecase(NoParams());
    expect(result, const Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumber());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
