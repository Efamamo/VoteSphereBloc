import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../providers/group_provider.dart';
import 'package:provider/provider.dart';

class MyAlertDialog extends StatelessWidget {
  MyAlertDialog({super.key});
  TextEditingController groupName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var groupProvider = Provider.of<GroupProvider>(context);
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
            groupProvider.createGroup(groupName);

            Navigator.pop(context);
          },
          child: const Text(
            "Create Group",
            style: TextStyle(color: Colors.black),
          ),
        )
      ],
    );
    ;
  }
}
