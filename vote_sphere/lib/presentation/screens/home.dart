import 'package:flutter/material.dart';

import '../widgets/buttons.dart';
import 'new_polls.dart';
import 'package:provider/provider.dart';
import '../providers/group_provider.dart';
import '../widgets/my_drawer.dart';
import '../providers/pole_provider.dart';
import 'Home/my_polls.dart';
import 'Home/no_group.dart';
import 'Home/no_polls.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController groupName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var pollProvider = Provider.of<PollProvider>(context);
    var groupProvider = Provider.of<GroupProvider>(context);
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
      drawer: const MyDrawer(),
      body: Center(
          child: groupProvider.group == ''
              ? const NoGroup()
              : pollProvider.questions.isEmpty
                  ? NoPoll()
                  : MyPolls()),
    );
  }
}
