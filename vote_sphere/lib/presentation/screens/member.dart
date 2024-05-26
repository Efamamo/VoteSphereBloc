import 'package:flutter/material.dart';

void main() {
  runApp(Members());
}

class Members extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 34, 82),
        title: Text(
          'Members',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: MemberPage(),
    );
  }
}

class MemberPage extends StatefulWidget {
  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  TextEditingController _usernameController = TextEditingController();
  String _errorMessage = '';
  List<String> _members = [];
  bool _showForm = false;

  void toggleFormVisibility() {
    setState(() {
      _showForm = !_showForm;
      _errorMessage = ''; // Reset error message when toggling form visibility
    });
  }

  void addMember() {
    setState(() {
      if (_usernameController.text.isNotEmpty) {
        _members.add(_usernameController.text);
        _usernameController.clear();
        toggleFormVisibility();
      } else {
        _errorMessage = 'Please enter a username';
      }
    });
  }

  void deleteMember(int index) {
    setState(() {
      _members.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 10.0), // Added x-direction padding
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          if (_errorMessage
              .isNotEmpty) // Display error message if it's not empty
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 7), // Added padding to the left of the circular avatar
              CircleAvatar(
                radius: 45,
                backgroundColor: Color.fromARGB(255, 2, 34, 82),
                child: Icon(Icons.people,
                    size: 25,
                    color: Colors.white), // Changed the icon to 'people'
              ),
              SizedBox(width: 20),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: _showForm
                        ? Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Username',
                                    labelStyle: TextStyle(
                                        color: Colors.black), // Text color
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue), // Border color
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .blue), // Focused border color
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a username';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: addMember,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue[700],
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 50, vertical: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5), // Increased the border radius
                                        ),
                                      ),
                                      child: Text('Add',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    ElevatedButton(
                                      onPressed: toggleFormVisibility,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red[600],
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 50, vertical: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              5), // Increased the border radius
                                        ),
                                      ),
                                      child: Text('Back',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : ElevatedButton(
                            onPressed: toggleFormVisibility,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[500],
                              padding: EdgeInsets.symmetric(
                                  horizontal: 60, vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    5), // Increased the border radius
                              ),
                            ),
                            child: Text('Add Member',
                                style: TextStyle(color: Colors.white)),
                          ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          if (_members.isEmpty)
            Padding(
              padding: EdgeInsets.only(top: 200),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'No Member Added Yet',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _members.length,
              itemBuilder: (context, index) {
                return MemberListItem(
                  name: _members[index],
                  onDelete: () => deleteMember(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MemberListItem extends StatelessWidget {
  final String name;
  final VoidCallback onDelete;

  const MemberListItem({Key? key, required this.name, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.person, color: Color.fromARGB(255, 2, 34, 82)),
                  SizedBox(width: 10),
                  Text(name,
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                ],
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: onDelete,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
