import 'package:flutter/material.dart';

class CustomForm extends StatelessWidget {
  final TextEditingController controller;
  final bool obsecuretext;
  final String hintText;
  final String? Function(String?) validator;

  const CustomForm(
      {super.key,
      this.obsecuretext = false,
      required this.hintText,
      required this.validator,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        obscureText: obsecuretext,
        decoration: InputDecoration(hintText: hintText),
        validator: validator,
      ),
    );
  }
}
