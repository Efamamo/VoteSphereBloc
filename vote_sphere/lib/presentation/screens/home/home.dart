import 'package:flutter/material.dart';
import 'package:vote_sphere/local_storage/secure_storage.dart';
import 'package:vote_sphere/presentation/screens/home/bloc/home_bloc.dart';
import '../../widgets/my_drawer.dart';
import 'my_polls.dart';
import 'no_group.dart';
import 'no_polls.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController groupName = TextEditingController();

  @override
  void initState() {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    super.initState();
    homeBloc.add(LoadHomeEvent());
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    return BlocConsumer<HomeBloc, HomeState>(
        bloc: homeBloc,
        listenWhen: (previous, current) => current is HomeActionState,
        buildWhen: (previous, current) => current is! HomeActionState,
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          print(state);
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is NoGroupState) {
            final noGroup = state as NoGroupState;
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color.fromARGB(255, 2, 34, 82),
                  title: const Text(
                    "VOTESPHERE",
                    style: TextStyle(color: Colors.white, letterSpacing: 2.0),
                  ),
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                  ),
                  centerTitle: true,
                ),
                drawer: const MyDrawer(group: null),
                body: NoGroup(
                  role: noGroup.role,
                ));
          } else if (state is HomeWithPollState) {
            final pollState = state as HomeWithPollState;
            print(pollState.polls);
            if (pollState.polls.length == 0) {
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: const Color.fromARGB(255, 2, 34, 82),
                    title: const Text(
                      "VOTESPHERE",
                      style: TextStyle(color: Colors.white, letterSpacing: 2.0),
                    ),
                    iconTheme: const IconThemeData(
                      color: Colors.white,
                    ),
                    centerTitle: true,
                  ),
                  drawer: MyDrawer(group: pollState.group),
                  body: Center(
                      child: NoPoll(
                    role: pollState.role,
                  )));
            } else {
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: const Color.fromARGB(255, 2, 34, 82),
                    title: const Text(
                      "VOTESPHERE",
                      style: TextStyle(color: Colors.white, letterSpacing: 2.0),
                    ),
                    iconTheme: const IconThemeData(
                      color: Colors.white,
                    ),
                    centerTitle: true,
                  ),
                  drawer: MyDrawer(
                    group: pollState.group,
                  ),
                  body: Center(child: MyPolls(polls: pollState.polls)));
            }
          }
          return Container(
            color: Colors.red,
            height: 10,
          );
        });
  }
}
