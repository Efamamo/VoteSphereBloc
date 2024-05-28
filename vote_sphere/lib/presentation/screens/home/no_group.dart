import 'package:flutter/material.dart';
import 'package:vote_sphere/local_storage/secure_storage.dart';
import 'package:vote_sphere/presentation/screens/home/bloc/home_bloc.dart';
import '../../widgets/alertdialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoGroup extends StatelessWidget {
  NoGroup({super.key, required this.role});

  final secureStorage = SecureStorage().secureStorage;
  final role;

  void createGroup(context) {
    showDialog(
        context: context,
        builder: (context) {
          return MyAlertDialog();
        });
  }

  final HomeBloc homeBloc = HomeBloc();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is NavigateToCreateGroupState) {
          createGroup(context);
        }
      },
      builder: (context, state) {
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
              Text(
                role == "Admin"
                    ? "Create A Group to get Started"
                    : 'You Are Not Assigned To Any Group Yet',
                style: const TextStyle(
                  color: Color.fromARGB(255, 2, 34, 82),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 140.0),
                child: role != "User"
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Create group'),
                        onPressed: () {
                          homeBloc.add(OpenDialogToCreateGroup());
                        },
                      )
                    : const SizedBox(
                        height: 10,
                      ),
              )
            ],
          ),
        );
      },
    );
  }
}
