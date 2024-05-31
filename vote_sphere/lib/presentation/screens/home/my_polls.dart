import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vote_sphere/application/blocs/home_bloc.dart';
import '../../widgets/my_container.dart';
import 'package:go_router/go_router.dart';

class MyPolls extends StatefulWidget {
  MyPolls({super.key, required this.polls, required this.role});
  final polls;
  final role;

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
    context.push('/new_polls', extra: {
      'question': question,
      'choice1': choice1,
      'choice2': choice2,
      'choice3': choice3,
      'choice4': choice4,
      'choice5': choice5,
      'questionError': '',
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    print(widget.polls);
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listener: (context, state) {},
      builder: (context, state) {
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
                ...widget.polls
                    .map((poll) => MyContainer(poll: poll, role: widget.role))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            widget.role == "Admin"
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue[700]),
                    onPressed: navigateNewPolls,
                    child: const Text("Add Poll"))
                : const SizedBox(),
            const SizedBox(
              height: 50,
            )
          ]),
        );
      },
    );
  }
}
