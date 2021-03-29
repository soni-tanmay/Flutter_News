import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/bloc/headlines/headlines_bloc.dart';
import 'package:news_app/bloc/intrests/intrests_bloc.dart';
import 'package:news_app/screens/headlines/headlines_screen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HeadlinesBloc()),
        BlocProvider(create: (context) => IntrestsBloc()),
      ],
      child: MaterialApp(
        title: 'news_app',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: HeadlinesScreen(),
      ),
    );
  }
}
