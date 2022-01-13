import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection_container.dart' as getit;
import 'presentation/bloc/number_trivia/number_trivia_cubit.dart';
import 'presentation/pages/number_trivia_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await getit.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.green.shade600,
          primary: Colors.green.shade800,
        ),
      ),
      home: BlocProvider(
        create: (_) => getit.di<NumberTriviaCubit>(),
        child: NumberTriviaPage(),
      ),
    );
  }
}
