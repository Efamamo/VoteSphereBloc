import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../providers/group_provider.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var groupProvider = Provider.of<GroupProvider>(context);
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
                    Navigator.pushNamed(context, 'settings');
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
                groupProvider.group != ''
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
  }
}
