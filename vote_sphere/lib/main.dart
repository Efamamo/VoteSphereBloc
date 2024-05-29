import 'package:flutter/material.dart';
import 'package:vote_sphere/presentation/screens/auth/bloc/auth_bloc.dart';
import 'package:vote_sphere/presentation/screens/home/bloc/home_bloc.dart';
import 'package:vote_sphere/presentation/screens/settings/bloc/settings_bloc.dart';
import 'presentation/screens/landing/landing_page.dart';
import 'presentation/screens/home/home.dart';
import 'presentation/screens/auth/login.dart';
import 'presentation/screens/settings/settings.dart';
import 'presentation/screens/auth/signUp.dart';
import 'presentation/screens/member.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'presentation/screens/new_polls.dart';
import 'presentation/screens/new_poll_model.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      BlocProvider(
        create: (context) => HomeBloc(),
      ),
      BlocProvider(
        create: (context) => SettingsBloc(),
      ),
      BlocProvider(
        create: (context) => AuthBloc(),
      ),
    ],
    child: const MyApp(),
  ));
}

final GoRouter _router = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: "/",
    name: 'landing',
    builder: (context, state) => LandingPage(),
  ),
  GoRoute(
    path: "/home",
    name: 'home',
    builder: (context, state) => const Home(),
  ),
  GoRoute(
    path: "/login",
    name: 'login',
    builder: (context, state) => LoginPage(),
  ),
  GoRoute(
    path: "/signup",
    name: 'signup',
    builder: (context, state) => const SignUpPage(),
  ),
  GoRoute(
    path: "/settings",
    name: 'settings',
    builder: (context, state) => const Settings(),
  ),
  GoRoute(
    path: "/members",
    name: 'members',
    builder: (context, state) => Members(),
  ),
  GoRoute(
    path: '/newpolls',
    builder: (context, state) {
      final extra = state.extra as NewPollsData;
      return NewPolls(
        question: extra.question,
        choice1: extra.choice1,
        choice2: extra.choice2,
        choice3: extra.choice3,
        choice4: extra.choice4,
        choice5: extra.choice5,
        questionError: extra.questionError,
      );
    },
  )
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
