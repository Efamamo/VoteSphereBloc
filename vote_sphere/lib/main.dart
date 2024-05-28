import 'package:flutter/material.dart';
import 'package:vote_sphere/presentation/screens/home/bloc/home_bloc.dart';
import 'presentation/screens/landing/landing_page.dart';
import 'presentation/screens/home/home.dart';
import 'presentation/screens/auth/login.dart';
import 'presentation/screens/settings.dart';
import 'presentation/screens/auth/signUp.dart';
import 'presentation/screens/member.dart';
import 'package:provider/provider.dart';
import 'application/home/group_provider.dart';
import 'application/home/pole_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      BlocProvider(
        create: (context) => HomeBloc(),
      ),
      ChangeNotifierProvider(
        create: (context) => PollProvider(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'landing',
      routes: {
        'landing': (context) => LandingPage(),
        'home': (context) => Home(),
        'signUp': (context) => SignUpPage(),
        'login': (context) => LoginPage(),
        'settings': (context) => Settings(),
        'members': (context) => Members(),
      },
    );
  }
}
