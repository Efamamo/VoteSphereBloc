import 'package:flutter/material.dart';
import '../../widgets/alertdialog.dart';

class NoGroup extends StatelessWidget {
  const NoGroup({super.key});
  void createGroup(context) {
    showDialog(
        context: context,
        builder: (context) {
          return MyAlertDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/vote.jpg',
            width: 230,
          ),
          const SizedBox(
            height: 80,
          ),
          const Padding(
              padding: EdgeInsets.only(left: 25, right: 80),
              child: Text.rich(TextSpan(
                children: [
                  TextSpan(
                    text: 'Votesphere',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 2, 34, 82),
                    ),
                  ),
                  TextSpan(
                    text:
                        " is a dynamic voting platform that makes group decision-making a breeze. Whether you're planning a trip with friends, organizing an event, or seeking opinions on important topics, Votesphere has you covered. ",
                  ),
                ],
                style: TextStyle(fontSize: 16),
              ))),
          const SizedBox(
            height: 100,
          ),
          const Text(
            "Create A Group to get Started",
            style: TextStyle(
              color: const Color.fromARGB(255, 2, 34, 82),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 140.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
              ),
              child: const Text('Create group'),
              onPressed: () {
                createGroup(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
