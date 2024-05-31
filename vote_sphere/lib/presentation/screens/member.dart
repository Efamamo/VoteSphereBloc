import 'package:flutter/material.dart';
import 'package:vote_sphere/application/blocs/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(Members());
}

class Members extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 34, 82),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              GoRouter.of(context).pop();
              homeBloc.add(PopMemberPageEvent());
            }),
        title: const Text(
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

  @override
  void initState() {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.add(LoadMembersEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    return BlocConsumer<HomeBloc, HomeState>(
        bloc: homeBloc,
        listenWhen: (previous, current) => current is HomeActionState,
        buildWhen: (previous, current) => current is! HomeActionState,
        listener: (context, state) {
          if (state is AddMemberErrorState) {
            final snackBar = SnackBar(
              content: Text(state.error),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          if (state is MembersLoadingState) {
            _usernameController.clear();
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MembersLoadedState) {
            final memberstate = state as MembersLoadedState;

            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0), // Added x-direction padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  memberstate.role == "Admin"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                                width:
                                    7), // Added padding to the left of the circular avatar
                            const CircleAvatar(
                              radius: 45,
                              backgroundColor: Color.fromARGB(255, 2, 34, 82),
                              child: Icon(Icons.people,
                                  size: 25,
                                  color: Colors
                                      .white), // Changed the icon to 'people'
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: _usernameController,
                                          decoration: const InputDecoration(
                                            labelText: 'Enter Username',
                                            labelStyle: TextStyle(
                                                color:
                                                    Colors.black), // Text color
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors
                                                      .blue), // Border color
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
                                        ElevatedButton(
                                          onPressed: () {
                                            homeBloc.add(AddMemberEvent(
                                                username:
                                                    _usernameController.text));
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue[500],
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 60, vertical: 20),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  5), // Increased the border radius
                                            ),
                                          ),
                                          child: const Text('Add Member',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  memberstate.members.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(top: 200),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'No Member Added Yet',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 1,
                        ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: memberstate.members.length,
                      itemBuilder: (context, index) {
                        return MemberListItem(
                            member: memberstate.members[index],
                            role: memberstate.role);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        });
  }
}

class MemberListItem extends StatelessWidget {
  final member;
  final role;

  const MemberListItem({Key? key, required this.member, required this.role})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
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
                  Text(member["username"],
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                ],
              ),
              role == "Admin"
                  ? IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        homeBloc.add(
                            DeleteMemberEvent(username: member["username"]));
                      },
                      color: Colors.red,
                    )
                  : const SizedBox(
                      width: 1,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
