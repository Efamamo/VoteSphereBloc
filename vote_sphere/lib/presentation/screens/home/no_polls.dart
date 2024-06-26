import 'package:flutter/material.dart';
import 'package:vote_sphere/application/blocs/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NoPoll extends StatefulWidget {
  NoPoll({super.key, required this.role});
  final role;

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
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {},
      builder: (context, state) {
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
            widget.role == "Admin"
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue[700]),
                    onPressed: navigateNewPolls,
                    child: const Text("Add Poll"))
                : const SizedBox(
                    height: 10,
                  )
          ],
        );
      },
    );
  }
}
