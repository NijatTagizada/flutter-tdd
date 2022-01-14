import 'package:flutter/material.dart';
import 'package:flutter_tdd/presentation/bloc/number_trivia/number_trivia_cubit.dart';

class TriviaControls extends StatefulWidget {
  final NumberTriviaCubit numberTriviaCubit;
  const TriviaControls({
    required this.numberTriviaCubit,
  });

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  String? inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) {
            dispatchConcrete();
          },
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                child: Text('Search'),
                color: Theme.of(context).colorScheme.primary,
                textTheme: ButtonTextTheme.primary,
                onPressed: dispatchConcrete,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: RaisedButton(
                child: Text('Get random trivia'),
                onPressed: dispatchRandom,
              ),
            ),
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    // Clearing the TextField to prepare it for the next inputted number
    controller.clear();
    widget.numberTriviaCubit.getTriviaNumberConcrete(inputStr ?? '');
  }

  void dispatchRandom() {
    controller.clear();
    widget.numberTriviaCubit.getRandomNumberTrivia();
  }
}
