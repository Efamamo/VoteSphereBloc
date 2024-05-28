import 'package:flutter/material.dart';
import 'package:vote_sphere/presentation/screens/home/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAlertDialog extends StatelessWidget {
  MyAlertDialog({super.key});
  final TextEditingController groupName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is CreateGroupState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          title: const Text(
            "Create Group",
            style: TextStyle(color: Colors.black),
          ),
          content: TextField(
            controller: groupName,
            decoration: const InputDecoration(
                hintText: 'Enter Group Name',
                hintStyle: TextStyle(color: Colors.black)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (groupName.text != '') {
                  Navigator.pop(context);
                  homeBloc.add(CreateGroup(groupName: groupName.text));
                }
              },
              child: const Text(
                "Create Group",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        );
      },
    );
    ;
  }
}
