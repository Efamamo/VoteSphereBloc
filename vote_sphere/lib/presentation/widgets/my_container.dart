import 'package:flutter/material.dart';
import '../providers/pole_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyContainer extends StatelessWidget {
  MyContainer({super.key, required this.question});
  var question;
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var pollProvider = Provider.of<PollProvider>(context);

    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(question.question,
                  style: const TextStyle(
                    fontSize: 20,
                  )),
              IconButton(
                  onPressed: () {
                    pollProvider.removeIndex(pollProvider
                        .index[pollProvider.questions.indexOf(question)]);
                    pollProvider.removeVote(pollProvider
                        .votes[pollProvider.questions.indexOf(question)]);
                    pollProvider.removeDisabled(pollProvider
                        .disabled[pollProvider.questions.indexOf(question)]);
                    pollProvider.removeQuestion(question);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red[900],
                  ))
            ],
          ),
        ),
        const Divider(
          height: 20,
        ),
        ...question.answers.map((choice) => RadioListTile(
            fillColor: MaterialStateColor.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.blue.shade700; // Active color
              } else {
                return Colors
                    .blue.shade700; // Inactive color (same as active color)
              }
            }),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text((((pollProvider.votes[pollProvider.questions
                                        .indexOf(question)]
                                    [question.answers.indexOf(choice)]) /
                                pollProvider.sum(pollProvider.votes[pollProvider
                                    .questions
                                    .indexOf(question)])) *
                            100)
                        .toStringAsFixed(2) +
                    '%'),
                LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.blue.shade700,
                  value: (pollProvider
                              .votes[pollProvider.questions.indexOf(question)]
                          [question.answers.indexOf(choice)]) /
                      pollProvider.sum(pollProvider
                          .votes[pollProvider.questions.indexOf(question)]),
                  minHeight: 4,
                ),
              ],
            ),
            title: Text(choice),
            value: 5 * pollProvider.questions.indexOf(question) +
                question.answers.indexOf(choice),
            groupValue:
                pollProvider.index[pollProvider.questions.indexOf(question)],
            onChanged:
                pollProvider.disabled[pollProvider.questions.indexOf(question)]
                    ? null
                    : (value) {
                        pollProvider.increamentVote(choice, question, value);

                        // disabled[questions
                        //         .indexOf(
                        //             question)] =
                        //     true;
                      })),
        const Divider(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
          child: Text("Comments",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        ...question.comment.map((com) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(com),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red[800]),
                    onPressed: () {
                      pollProvider.removeComment(com, question);
                    },
                  )
                ],
              ),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: TextField(
            controller: commentController,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    if (commentController.text != "") {
                      pollProvider.addComment(commentController.text, question);
                      commentController.clear();
                    }
                  },
                ),
                hintText: 'Write comment...'),
          ),
        )
      ]),
    );
  }
}
