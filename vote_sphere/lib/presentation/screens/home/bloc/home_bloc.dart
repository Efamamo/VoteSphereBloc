import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vote_sphere/local_storage/secure_storage.dart';
import 'package:http/http.dart' as http;
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeEvent>(loadHomeEvent);
    on<OpenDialogToCreateGroup>(openDialogToCreateGroup);
    on<CreateGroup>(createGroup);
    on<NavigateToAddPollEvent>(navigateToAddPollEvent);
    on<AddPoleEvent>(addPoleEvent);
    on<DeletePollEvent>(deletePollEvent);
    on<NavigateToSettings>(navigateToSettings);
    on<VoteEvent>(voteEvent);
    on<SendCommentEvent>(sendCommentEvent);
    on<DeleteComment>(deleteComment);
    on<NavigateToMembersEvent>(navigateToMembersEvent);
    on<LoadMembersEvent>(loadMembersEvent);
    on<AddMemberEvent>(addMemberEvent);
    on<DeleteMemberEvent>(deleteMemberEvent);
  }

  FutureOr<void> loadHomeEvent(
      LoadHomeEvent event, Emitter<HomeState> emit) async {
    emit(LoadingState());

    final secureStorage = SecureStorage().secureStorage;
    final group = await secureStorage.read(key: "group");
    final role = await secureStorage.read(key: 'role');
    final username = await secureStorage.read(key: 'username');
    final token = await secureStorage.read(key: 'token');

    if (group == null) {
      emit(NoGroupState(
          group: group, role: role, token: token, username: username));
    } else {
      String uri = 'http://localhost:9000/polls?groupId=$group';

      final url = Uri.parse(uri);
      final res =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});
      final jsonBody = jsonDecode(res.body);
      print(res.statusCode);

      if (res.statusCode != 400) {
        final polls = jsonBody;

        emit(HomeWithPollState(
            group: group,
            username: username,
            polls: polls,
            role: role,
            token: token));
      } else {
        print(res.body);
      }
    }
  }

  FutureOr<void> openDialogToCreateGroup(
      OpenDialogToCreateGroup event, Emitter<HomeState> emit) {
    emit(NavigateToCreateGroupState());
  }

  FutureOr<void> createGroup(CreateGroup event, Emitter<HomeState> emit) async {
    final secureStorage = SecureStorage().secureStorage;
    final username = await secureStorage.read(key: 'username');
    final token = await secureStorage.read(key: 'token');
    final role = await secureStorage.read(key: 'role');
    final group = await secureStorage.read(key: 'group');

    String uri = 'http://localhost:9000/groups';
    final url = Uri.parse(uri);
    final body = {"adminUsername": username, "groupName": event.groupName};
    final jsonBody = jsonEncode(body);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.post(url, headers: headers, body: jsonBody);
    Map response = jsonDecode(res.body);

    await secureStorage.write(key: 'group', value: response["groupID"]);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      add(LoadHomeEvent());
    }
  }

  FutureOr<void> navigateToAddPollEvent(
      NavigateToAddPollEvent event, Emitter<HomeState> emit) {
    emit(NavigateToAddPoles());
  }

  FutureOr<void> addPoleEvent(
      AddPoleEvent event, Emitter<HomeState> emit) async {
    try {
      final secureStorage = SecureStorage().secureStorage;
      final group = await secureStorage.read(key: 'group');
      final token = await secureStorage.read(key: 'token');

      if (group == null || token == null) {
        throw Exception("Missing group ID or token.");
      }

      String uri = 'http://localhost:9000/polls';
      final url = Uri.parse(uri);
      final body = {
        "poll": {"question": event.question, "options": event.options},
        "groupID": group
      };

      final jsonBody = jsonEncode(body);
      final headers = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      };

      final res = await http.post(url, headers: headers, body: jsonBody);
      final decodedBody = jsonDecode(res.body);

      if (res.statusCode == 201) {
        final currentState = state as HomeWithPollState;
        decodedBody['comments'] = [];
        final updatedPolls = List<Map<String, dynamic>>.from(currentState.polls)
          ..add(decodedBody);

        emit(currentState.copyWith(polls: updatedPolls));
      } else {
        throw Exception("Failed to add poll: ${decodedBody['message']}");
      }
    } catch (e) {
      print("Error: $e");
      // Optionally, emit an error state if you have one
      // emit(AddPollErrorState(error: e.toString()));
    }
  }

  FutureOr<void> deletePollEvent(
      DeletePollEvent event, Emitter<HomeState> emit) async {
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');

    String uri = 'http://localhost:9000/polls/${event.pollId}';
    final url = Uri.parse(uri);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.delete(url, headers: headers);
    print(res.body);
    print(res.statusCode);
    if (res.statusCode >= 300) {
      final jsonBody = jsonDecode(res.body);
      emit(DeletePollErrorState(error: jsonBody['message']));
    } else {
      final currentState = state as HomeWithPollState;

      // Find the poll and update it
      final updatedPolls =
          currentState.polls.removeWhere((poll) => poll['id'] == event.pollId);

      emit(currentState.copyWith(polls: updatedPolls));
    }
  }

  FutureOr<void> navigateToSettings(
      NavigateToSettings event, Emitter<HomeState> emit) {
    emit(NavigateToSettingState());
  }

  FutureOr<void> voteEvent(VoteEvent event, Emitter<HomeState> emit) async {
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');
    String uri =
        'http://localhost:9000/polls/${event.pollId}/vote?optionId=${event.optionId}';
    final url = Uri.parse(uri);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.patch(url, headers: headers);
    final decodedRes = jsonDecode(res.body);

    if (res.statusCode == 200) {
      final currentState = state as HomeWithPollState;

      // Find the poll and update it
      final updatedPolls = currentState.polls.map((poll) {
        if (poll['id'] == event.pollId) {
          poll['options'] =
              decodedRes['options']; // Assuming 'votes' is the updated data
        }
        return poll;
      }).toList();

      emit(currentState.copyWith(polls: updatedPolls));
    } else {
      emit(VoteError(error: decodedRes["message"]));
    }
    print(res.body);
  }

  FutureOr<void> sendCommentEvent(
      SendCommentEvent event, Emitter<HomeState> emit) async {
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');
    String uri = 'http://localhost:9000/polls/comments';
    final url = Uri.parse(uri);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final body = {"pollId": event.pollID, "commentText": event.comment};
    final jsonBody = jsonEncode(body);
    final res = await http.post(url, headers: headers, body: jsonBody);

    if (res.statusCode == 201) {
      final addedComment = jsonDecode(res.body);

      if (state is HomeWithPollState) {
        final currentState = state as HomeWithPollState;

        // Update polls immutably
        final updatedPolls = currentState.polls.map((poll) {
          if (poll['id'] == event.pollID) {
            // Initialize comments if they don't exist
            final List comments =
                poll['comments'] != null ? List.from(poll['comments']) : [];

            // Add the new comment
            comments.add({
              "id": addedComment["id"],
              "commentText": addedComment["commentText"]
            });

            // Return a new poll object with updated comments
            return {
              ...poll,
              'comments': comments,
            };
          }
          return poll;
        }).toList();

        emit(currentState.copyWith(polls: updatedPolls));
      } else {
        // Handle the case where the state is not HomeWithPollState
        print('Current state is not HomeWithPollState');
      }
    } else {
      // Handle error if needed
      print('Failed to add comment: ${res.statusCode}');
    }
  }

  FutureOr<void> deleteComment(
      DeleteComment event, Emitter<HomeState> emit) async {
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');

    String uri = 'http://localhost:9000/polls/comments/${event.comId}';
    final url = Uri.parse(uri);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.delete(url, headers: headers);

    if (res.statusCode == 200) {
      if (state is HomeWithPollState) {
        final currentState = state as HomeWithPollState;

        // Update polls immutably
        final updatedPolls = currentState.polls.map((poll) {
          if (poll['id'] == event.pollId) {
            // Check if comments exist
            if (poll['comments'] != null) {
              // Create a new list without the deleted comment
              final updatedComments = List.from(poll['comments'])
                  .where((comment) => comment['id'] != event.comId)
                  .toList();

              return {
                ...poll,
                'comments': updatedComments,
              };
            }
          }
          return poll;
        }).toList();

        emit(currentState.copyWith(polls: updatedPolls));
      } else {
        // Handle the case where the state is not HomeWithPollState
        print('Current state is not HomeWithPollState');
      }
    } else {
      final jsonBody = jsonDecode(res.body);
      emit(DeletePollErrorState(error: jsonBody['message'] ?? 'Unknown error'));
    }
  }

  FutureOr<void> navigateToMembersEvent(
      NavigateToMembersEvent event, Emitter<HomeState> emit) {
    emit(NavigateToMembersState());
  }

  FutureOr<void> loadMembersEvent(
      LoadMembersEvent event, Emitter<HomeState> emit) async {
    emit(MembersLoadingState());

    final secureStorage = SecureStorage().secureStorage;

    final token = await secureStorage.read(key: 'token');
    final group = await secureStorage.read(key: 'group');
    final role = await secureStorage.read(key: 'role');

    String uri = 'http://localhost:9000/groups/${group}/members';
    final url = Uri.parse(uri);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.get(url, headers: headers);

    print(res.body);
    if (res.statusCode == 200) {
      final decodedody = jsonDecode(res.body);
      emit(MembersLoadedState(members: decodedody, role: role));
    }
  }

  FutureOr<void> addMemberEvent(
      AddMemberEvent event, Emitter<HomeState> emit) async {
    try {
      // Retrieve the token and group from secure storage
      final secureStorage = SecureStorage().secureStorage;
      final token = await secureStorage.read(key: 'token');
      final group = await secureStorage.read(key: 'group');

      // Ensure token and group are not null
      if (token == null || group == null) {
        emit(AddMemberErrorState(
            error: 'Authentication or group information is missing'));
        return;
      }

      // Prepare the request URL
      String uri = 'http://localhost:9000/groups/$group/members';
      final url = Uri.parse(uri);

      // Prepare the request body and headers
      final body = {"username": event.username};
      final encodedBody = jsonEncode(body);
      final headers = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      };

      // Send the HTTP POST request
      final res = await http.post(url, headers: headers, body: encodedBody);
      print(res.body);

      final jsonBody = jsonDecode(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final currentState = state as MembersLoadedState;

        final updatedMembers =
            List<Map<String, dynamic>>.from(currentState.members)
              ..add({
                "username": jsonBody["username"],
                "email": jsonBody["email"],
                "isAdmin": jsonBody["isAdmin"]
              });

        emit(currentState.copyWith(members: updatedMembers));
      } else {
        emit(AddMemberErrorState(
            error: jsonBody["message"] ?? 'Unknown error occurred'));
      }
    } catch (error) {
      print(error);

      emit(AddMemberErrorState(error: error.toString()));
    }
  }

  FutureOr<void> deleteMemberEvent(
      DeleteMemberEvent event, Emitter<HomeState> emit) async {
    final secureStorage = SecureStorage().secureStorage;

    final token = await secureStorage.read(key: 'token');
    final group = await secureStorage.read(key: 'group');

    String uri = 'http://localhost:9000/groups/${group}/members';

    final body = {"username": event.username};
    final encodedBody = jsonEncode(body);
    final url = Uri.parse(uri);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.delete(url, headers: headers, body: encodedBody);

    try {
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final currentState = state as MembersLoadedState;

        final updatedMembers = currentState.members
            .removeWhere((member) => member['username'] == event.username);

        emit(currentState.copyWith(members: updatedMembers));
      } else {
        final jsonBody = jsonDecode(res.body);
        emit(AddMemberErrorState(
            error: jsonBody["message"] ?? 'Unknown error occurred'));
      }
    } catch (e) {
      print(e);
    }
  }
}
