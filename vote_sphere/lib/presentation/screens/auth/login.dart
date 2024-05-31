import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vote_sphere/presentation/screens/auth/bloc/auth_bloc.dart';
import '../../../Utils/extensions.dart';
import '../../widgets/forms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  final AuthBloc landingBloc = AuthBloc();

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static final formkey = new GlobalKey<FormState>();
  final AuthBloc authBloc = AuthBloc();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      bloc: authBloc,
      listenWhen: (previous, current) => current is AuthActionState,
      buildWhen: (previous, current) => current is! AuthActionState,
      listener: (context, state) {
        if (state is LogInErrorState) {
          final snackBar = SnackBar(
            content: Text(state.error),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        if (state is LogInSuccessState) {
          print(state);
          context.push('/home');
        }
        if (state is LoginNavigateToSignupState) {
          context.push('/signup');
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                          Column(
                            children: <Widget>[
                              const Text(
                                "Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Login to your account",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey[700]),
                              )
                            ],
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Column(
                                children: <Widget>[
                                  Form(
                                      key: formkey,
                                      child: Column(children: <Widget>[
                                        CustomForm(
                                            controller: usernameController,
                                            hintText: "Username",
                                            validator: (val) {
                                              if (!val!.isValidEmail) {
                                                return "Please enter the valid email";
                                              } else {
                                                return null;
                                              }
                                            }),
                                        CustomForm(
                                            controller: passwordController,
                                            hintText: "Password",
                                            obsecuretext: true,
                                            validator: (val) {
                                              if (!val!.isValidPassword) {
                                                return "Please enter the valid password";
                                              } else {
                                                return null;
                                              }
                                            }),
                                      ])),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Container(
                              padding: const EdgeInsets.only(top: 1, left: 1),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: const Border(
                                      bottom:
                                          BorderSide(color: Colors.amberAccent),
                                      top:
                                          BorderSide(color: Colors.amberAccent),
                                      right:
                                          BorderSide(color: Colors.amberAccent),
                                      left: BorderSide(
                                          color: Colors.amberAccent))),
                              child: MaterialButton(
                                minWidth: double.infinity,
                                height: 60,
                                color: Colors.lightBlue,
                                onPressed: () {
                                  print("hello");
                                  authBloc.add(LogInEvent(
                                      username: usernameController.text,
                                      password: passwordController.text));
                                },
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text("Don't you have an account"),
                              GestureDetector(
                                onTap: () {
                                  authBloc.add(NavigateSignUpEvent());
                                },
                                child: const Text(
                                  ' Sign up',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 100),
                            height: 200,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/key.png"),
                                    fit: BoxFit.fitHeight)),
                          ),
                        ]))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
