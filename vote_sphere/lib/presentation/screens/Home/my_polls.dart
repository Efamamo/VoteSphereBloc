import 'package:flutter/material.dart';
import '../../widgets/my_container.dart';
import 'package:provider/provider.dart';
import '../new_polls.dart';
import '../../providers/pole_provider.dart';

class MyPolls extends StatefulWidget {
  MyPolls({super.key});

  @override
  State<MyPolls> createState() => _MyPollsState();
}

class _MyPollsState extends State<MyPolls> {
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
    var pollProvider = Provider.of<PollProvider>(context);
    return SingleChildScrollView(
      child: Column(children: [
        Image.asset(
          'assets/vote.jpg',
          width: 230,
        ),
        const SizedBox(
          height: 50,
        ),
        Text("Your Polls",
            style: TextStyle(
                color: Colors.blue[900],
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        Column(
          children: [
            ...pollProvider.questions
                .map((question) => MyContainer(question: question))
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  // Navigate to the second page
                  Navigator.pushNamed(context, 'feedBack');
                },
                child: const Text(
                  'feedback',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
              ),
              const Icon(
                Icons.question_mark,
                color: Colors.blue,
                size: 18,
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue[700]),
            onPressed: navigateNewPolls,
            child: const Text("Add Poll")),
        const SizedBox(
          height: 50,
        )
      ]),
    );
  }
}
