import '../../domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia{
  const NumberTriviaModel({required int number, required String text})
      : super(
          number: number,
          text: text,
        );
}
