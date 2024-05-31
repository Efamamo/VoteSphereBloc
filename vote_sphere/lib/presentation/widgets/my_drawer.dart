import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vote_sphere/application/blocs/auth_bloc.dart';
import 'package:vote_sphere/application/blocs/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, required this.group});
  final group;

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is NavigateToSettingState) {
          context.push('/settings');
        }

        if (state is NavigateToMembersState) {
          context.push('/members');
        }
      },
      builder: (context, state) {
        return Drawer(
          surfaceTintColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    DrawerHeader(child: Image.asset('assets/vote.jpg')),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.home),
                          SizedBox(
                            width: 12,
                          ),
                          Text("HOME")
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        homeBloc.add(NavigateToSettings());
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.settings),
                          SizedBox(
                            width: 12,
                          ),
                          Text("SETTINGS")
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    group != null
                        ? GestureDetector(
                            onTap: () {
                              homeBloc.add(NavigateToMembersEvent());
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.people),
                                SizedBox(
                                  width: 12,
                                ),
                                Text("MEMBERS")
                              ],
                            ),
                          )
                        : const Text(''),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    context.go('/');
                    authBloc.add(SignoutEvent());
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(
                        width: 12,
                      ),
                      Text("LOGOUT")
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
