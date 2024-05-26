import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings();
  void updateUsername(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[200],
            title: const Text(
              "Update Username",
              style: TextStyle(color: Colors.black),
            ),
            content: const TextField(
              decoration: InputDecoration(
                  hintText: 'Enter Username',
                  hintStyle: TextStyle(color: Colors.black)),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Change Username",
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 2, 34, 82),
          title: const Text(
            "SETTINGS",
            style: TextStyle(color: Colors.white, letterSpacing: 2.0),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          centerTitle: true,
        ),
        body: Container(
          height: 330,
          margin: EdgeInsets.all(30),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 253, 250, 250),
              border: Border.all(),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ListTile(
                leading: Icon(Icons.person),
                title: Text("Ephrem"),
                subtitle: Text("username"),
              ),
              const ListTile(
                leading: Icon(Icons.email),
                title: Text("e@gmail.com"),
                subtitle: Text("email"),
              ),
              const ListTile(
                leading: Icon(Icons.group),
                title: Text("group 1"),
                subtitle: Text("group"),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      child: Text("Update Username"),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white),
                      onPressed: () {
                        updateUsername(context);
                      }),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      child: Text("DeleteAccount"),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          backgroundColor: Colors.red[600],
                          foregroundColor: Colors.white),
                      onPressed: () {}),
                ],
              )
            ],
          ),
        ));
  }
}
