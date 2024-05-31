import 'package:flutter/material.dart';
import 'package:vote_sphere/application/blocs/home_bloc.dart';
import '../../widgets/my_drawer.dart';
import 'my_polls.dart';
import 'no_group.dart';
import 'no_polls.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
          if (state is UnloggedState) {
            context.go('/');
          }
          if (state is DeletePollErrorState) {
            final snackBar = SnackBar(
              content: Text(state.error),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          if (state is VoteError) {
            final snackBar = SnackBar(
              content: Text(state.error),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
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
                  body: Center(
                      child: MyPolls(
                    polls: pollState.polls,
                    role: pollState.role,
                  )));
            }
          } else {
            return SizedBox();
          }
        });
  }
}
