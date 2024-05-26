import 'package:flutter/material.dart';

class CustomForm extends StatelessWidget {
  final bool obsecuretext;
  final String hintText;
  final String? Function(String?) validator;

  const CustomForm(
      {super.key,
      this.obsecuretext = false,
      required this.hintText,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        obscureText: obsecuretext,
        decoration: InputDecoration(hintText: hintText),
        validator: validator,
      ),
    );
  }
}
