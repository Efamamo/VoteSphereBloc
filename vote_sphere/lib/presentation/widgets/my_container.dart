import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vote_sphere/application/blocs/home_bloc.dart';

class MyContainer extends StatelessWidget {
  MyContainer({required this.poll, required this.role});
  TextEditingController commentController = TextEditingController();
  var selected;
  var poll;
  var role;
  void updateComment(context, data, poll, com) {
    showDialog(
        context: context,
        builder: (context) {
          final homeBloc = BlocProvider.of<HomeBloc>(context);

          TextEditingController comment = TextEditingController();
          comment.text = data;

          return AlertDialog(
            backgroundColor: Colors.grey[200],
            title: const Text(
              "Update Comment",
              style: TextStyle(color: Colors.black),
            ),
            content: Container(
              height: 60,
              child: TextField(
                controller: comment,
                decoration: const InputDecoration(
                    hintText: 'Enter new Password',
                    hintStyle: TextStyle(color: Colors.black)),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                  homeBloc.add(UpdateCommentEvent(
                      comment: comment.text, pollId: poll, comId: com));
                },
                child: const Text(
                  "Change Comment",
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    final pollId = poll["id"];
    List pollOptions = poll["options"];
    pollOptions.sort((a, b) => a["id"]!.compareTo(b["id"]!));

    num calculateTotal(List options) {
      num total = 0;
      for (var option in options) {
        total += option["numberOfVotes"];
      }
      return total;
    }

    final total =
        calculateTotal(pollOptions) != 0 ? calculateTotal(pollOptions) : 1;

    return Material(
      child: Container(
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
                Text(poll["question"],
                    style: const TextStyle(
                      fontSize: 20,
                    )),
                role == "Admin"
                    ? IconButton(
                        onPressed: () {
                          homeBloc.add(DeletePollEvent(pollId: pollId));
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red[900],
                        ))
                    : const SizedBox()
              ],
            ),
          ),
          const Divider(
            height: 20,
          ),
          ...pollOptions
              .map((option) => RadioListTile(
                  fillColor: MaterialStateColor.resolveWith((states) {
                    return Colors.blue.shade700;
                  }),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(((option["numberOfVotes"] / total) * 100)
                              .toStringAsFixed(2) +
                          "%"),
                      LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.blue.shade700,
                          value: option["numberOfVotes"] / total),
                    ],
                  ),
                  title: Text(option["optionText"]),
                  value: option["id"],
                  groupValue: selected,
                  onChanged: (value) {
                    selected = value;
                    homeBloc
                        .add(VoteEvent(optionId: option['id'], pollId: pollId));
                  }))
              .toList(),
          const Divider(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
            child: Text("Comments",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          ...poll["comments"].map((com) {
            final comId = com["id"];
            return Padding(
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
                      Text(com["commentText"]),
                    ],
                  ),
                  PopupMenuButton(onSelected: (value) {
                    if (value == "update") {
                      updateComment(context, com["commentText"], pollId, comId);
                    } else if (value == "delete") {
                      homeBloc.add(DeleteComment(comId: comId, pollId: pollId));
                    }
                  }, itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text("Delete"),
                      ),
                      const PopupMenuItem(
                        value: 'update',
                        child: Text("Update"),
                      ),
                    ];
                  })
                ],
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              controller: commentController,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      if (commentController.text.isNotEmpty) {
                        homeBloc.add(SendCommentEvent(
                            comment: commentController.text, pollID: pollId));
                      }
                    },
                  ),
                  hintText: 'Write comment...'),
            ),
          )
        ]),
      ),
    );
  }
}
