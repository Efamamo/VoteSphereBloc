import 'package:flutter/material.dart';
import '../new_polls.dart';

class NoPoll extends StatefulWidget {
  NoPoll({super.key});

  @override
  State<NoPoll> createState() => _NoPollState();
}

class _NoPollState extends State<NoPoll> {
  TextEditingController question = TextEditingController();

  TextEditingController choice1 = TextEditingController();

  TextEditingController choice2 = TextEditingController();

  TextEditingController choice3 = TextEditingController();

  TextEditingController choice4 = TextEditingController();

  TextEditingController choice5 = TextEditingController();

  String questionError = '';

  void navigateNewPolls() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NewPolls(
        question: question,
        questionError: questionError,
        choice1: choice1,
        choice2: choice2,
        choice3: choice3,
        choice4: choice4,
        choice5: choice5,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/vote.jpg',
          width: 230,
        ),
        const SizedBox(
          height: 60,
        ),
        const Text(
          "You dont have polls",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue[700]),
            onPressed: navigateNewPolls,
            child: const Text("Add Poll"))
      ],
    );
  }
}
