import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vote_sphere/presentation/screens/landing/bloc/landing_bloc.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatefulWidget {
  LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final LandingBloc landingBloc = LandingBloc();
  @override
  void initState() {
    final LandingBloc landingBloc = LandingBloc();
    landingBloc.add(LandingInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LandingBloc, LandingState>(
      bloc: landingBloc,
      listenWhen: (previous, current) => current is LandingActionState,
      buildWhen: (previous, current) => current is! LandingActionState,
      listener: (context, state) {
        if (state is LandingNavigateToLogin) {
          context.go('/login');
        } else if (state is LandingNavigateToSignup) {
          context.go('/signup');
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(children: <Widget>[
                      const Text("Welcome",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30)),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: 200,
                          child: TextLiquidFill(
                            text: 'Votosphere',
                            waveColor: Colors.blueAccent,
                            boxBackgroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                            boxHeight: 80,
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      AnimatedTextKit(
                        animatedTexts: [
                          WavyAnimatedText(
                              "The most competitive vote app. Vote anything that you want!",
                              textStyle: const TextStyle(
                                  color: Colors.lightBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                              textAlign: TextAlign.center),
                        ],
                        isRepeatingAnimation: true,
                      )
                    ]),
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images.png"))),
                    ),
                    Column(
                      children: <Widget>[
                        MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            landingBloc.add(LoginPageButtonNavigateEvent());
                          },
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.amberAccent),
                              borderRadius: BorderRadius.circular(50)),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 20),
                        MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            landingBloc.add(SignupPageButtonNavigateEvent());
                          },
                          color: const Color(0xff0095FF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
          ),
        );
      },
    );
  }
}
