import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Utils/extensions.dart';
import 'feedback.dart';
import '../widgets/forms.dart';
import 'signUp.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  static final formkey = new GlobalKey<FormState>();

  Widget build(BuildContext context) {
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
              Navigator.pop(context);
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
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            children: <Widget>[
                              Form(
                                  key: formkey,
                                  child: Column(children: <Widget>[
                                    CustomForm(
                                        hintText: "Email",
                                        validator: (val) {
                                          if (!val!.isValidEmail) {
                                            return "Please enter the valid email";
                                          } else {
                                            return null;
                                          }
                                        }),
                                    CustomForm(
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
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Container(
                          padding: EdgeInsets.only(top: 1, left: 1),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border(
                                  bottom: BorderSide(color: Colors.amberAccent),
                                  top: BorderSide(color: Colors.amberAccent),
                                  right: BorderSide(color: Colors.amberAccent),
                                  left: BorderSide(color: Colors.amberAccent))),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            color: Colors.lightBlue,
                            onPressed: () {
                              if (formkey.currentState!.validate()) {
                                Navigator.pushNamed(context, 'home');
                              }
                            },
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
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
                          Text("Don't you have an account"),
                          GestureDetector(
                            onTap: () {
                              // Navigate to the second page
                              Navigator.pushNamed(context, 'signUp');
                            },
                            child: Text(
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
                        padding: EdgeInsets.only(top: 100),
                        height: 200,
                        decoration: BoxDecoration(
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
  }
}
