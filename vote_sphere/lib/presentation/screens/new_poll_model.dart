import 'package:flutter/material.dart';

class NewPollsData {
  final TextEditingController question;
  final TextEditingController choice1;
  final TextEditingController choice2;
  final TextEditingController choice3;
  final TextEditingController choice4;
  final TextEditingController choice5;
  final String questionError;

  NewPollsData({
    required this.question,
    required this.choice1,
    required this.choice2,
    required this.choice3,
    required this.choice4,
    required this.choice5,
    required this.questionError,
  });
}
