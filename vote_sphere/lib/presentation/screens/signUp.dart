import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Utils/extensions.dart';
import 'feedback.dart';
import '../widgets/forms.dart';
import 'login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  static final formkey = new GlobalKey<FormState>();
  int? index = 3;
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
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Sign up",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Create a new account",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    )
                  ],
                ),
                Container(
                    child: Form(
                        key: formkey,
                        child: Column(children: <Widget>[
                          CustomForm(
                            hintText: "Username",
                            validator: (val) {
                              if (!val!.isValidUsername) {
                                return "Please enter the valid username";
                              } else {
                                return null;
                              }
                            },
                          ),
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
                          CustomForm(
                              hintText: "Confirm Password",
                              obsecuretext: true,
                              validator: (val) {
                                if (!val!.isValidConfirmPass) {
                                  return "the password doesn't match";
                                } else {
                                  return null;
                                }
                              })
                        ]))),
                Column(
                  children: <Widget>[
                    Text(
                      "Signup As",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Radio(
                                value: 1,
                                groupValue: index,
                                onChanged: (value) {
                                  setState(() {
                                    index = value;
                                  });
                                }),
                            Text("Member")
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          children: [
                            Radio(
                                value: 2,
                                groupValue: index,
                                onChanged: (value) {
                                  setState(() {
                                    index = value;
                                  });
                                }),
                            Text("Admin")
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                Container(
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
                      "Sign up",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account"),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the second page
                        Navigator.pushNamed(context, 'login');
                      },
                      child: Text(
                        ' Login',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                )
              ]),
        )),
      ),
    );
  }
}
