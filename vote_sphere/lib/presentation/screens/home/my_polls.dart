import 'package:flutter/material.dart';
import 'package:vote_sphere/presentation/screens/questions_model.dart';
import '../../widgets/my_container.dart';
import 'package:provider/provider.dart';
import '../new_polls.dart';
import '../../../application/home/pole_provider.dart';

class MyPolls extends StatefulWidget {
  MyPolls({super.key, required this.polls});
  List<Question> polls;

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
          children: [...widget.polls.map((poll) => MyContainer(poll: poll))],
        ),
        const SizedBox(
          height: 20,
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
