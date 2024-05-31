import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vote_sphere/presentation/screens/home/bloc/home_bloc.dart';
import 'package:vote_sphere/presentation/screens/settings/bloc/settings_bloc.dart';
import 'package:go_router/go_router.dart';

class Settings extends StatefulWidget {
  const Settings();

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    settingsBloc.add(LoadSettingEvent());
    super.initState();
  }

  void updateUsername(context) {
    showDialog(
        context: context,
        builder: (context) {
          final settingsBloc = BlocProvider.of<SettingsBloc>(context);
          TextEditingController newPassword = TextEditingController();

          return AlertDialog(
            backgroundColor: Colors.grey[200],
            title: const Text(
              "Update Password",
              style: TextStyle(color: Colors.black),
            ),
            content: Container(
              height: 50,
              child: TextField(
                controller: newPassword,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: 'Enter new Password',
                    hintStyle: TextStyle(color: Colors.black)),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                  settingsBloc
                      .add(ChangePaswordEvent(newPassword: newPassword.text));
                },
                child: const Text(
                  "Change Password",
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final settingsBloc = BlocProvider.of<SettingsBloc>(context);
    return BlocConsumer<SettingsBloc, SettingsState>(
      listenWhen: (previous, current) => current is SettingsActionState,
      buildWhen: (previous, current) => current is! SettingsActionState,
      listener: (context, state) {
        if (state is NavigateToUpdatePasswordState) {
          updateUsername(context);
        }

        if (state is ChangePasswordSuccessState) {
          const snackBar = SnackBar(
            content: Text("Password Updated Successfully"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        if (state is ChangePasswordErrorState) {
          if (state.error == "Invalid password" ||
              state.error == "old password cannot be empty") {
            const snackBar = SnackBar(
              content: Text("Enter Correct Old Password"),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            const snackBar = SnackBar(
              content: Text("New Password is not strong"),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      },
      builder: (context, state) {
        if (state is SettingsLoadingState) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else if (state is SettingsLoadedState) {
          final settingState = state as SettingsLoadedState;
          final homeBloc = BlocProvider.of<HomeBloc>(context);
          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      GoRouter.of(context).pop();
                      homeBloc.add(PopMemberPageEvent());
                    }),
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
                margin: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 253, 250, 250),
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/vote.jpg',
                      width: 230,
                    ),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text("username"),
                      subtitle: Text(settingState.username.toString()),
                    ),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text("email"),
                      subtitle: Text(settingState.email.toString()),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                backgroundColor: Colors.blue[700],
                                foregroundColor: Colors.white),
                            onPressed: () {
                              settingsBloc.add(NavigateToChangePasswordEvent());
                            },
                            child: const Text("Update Password")),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                backgroundColor: Colors.red[600],
                                foregroundColor: Colors.white),
                            onPressed: () {
                              context.go('/');
                              settingsBloc.add(DeleteAccountEvent());
                            },
                            child: Text("DeleteAccount")),
                      ],
                    )
                  ],
                ),
              ));
        }
        return Container();
      },
    );
  }
}
