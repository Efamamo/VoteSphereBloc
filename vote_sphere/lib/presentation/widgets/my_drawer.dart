import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vote_sphere/presentation/screens/home/bloc/home_bloc.dart';
import '../../application/home/group_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, required this.group});
  final group;

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is NavigateToSettingState) {
          Navigator.pushNamed(context, 'settings');
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
                              Navigator.pushNamed(context, 'members');
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
                  onTap: () {},
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
