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

    if (token == null) {
      emit(LogOutState());
    }

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
    emit(LoadingState());
    final secureStorage = SecureStorage().secureStorage;
    final username = await secureStorage.read(key: 'username');
    final token = await secureStorage.read(key: 'token');

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
    add(LoadHomeEvent());
  }

  FutureOr<void> navigateToAddPollEvent(
      NavigateToAddPollEvent event, Emitter<HomeState> emit) {
    emit(NavigateToAddPoles());
  }

  FutureOr<void> addPoleEvent(
      AddPoleEvent event, Emitter<HomeState> emit) async {
    final secureStorage = SecureStorage().secureStorage;
    final group = await secureStorage.read(key: 'group');
    final token = await secureStorage.read(key: 'token');

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

    if (res.statusCode == 201) {
      add(LoadHomeEvent());
    }

    print(res.body);
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
    final jsonBody = jsonDecode(res.body);
    if (res.statusCode != 204) {
      emit(DeletePollErrorState(error: jsonBody['message']));
    } else {
      add(LoadHomeEvent());
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
      add(LoadHomeEvent());
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
    print(res.body);

    add(LoadHomeEvent());
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
    final jsonBody = jsonDecode(res.body);
    if (res.statusCode == 200) {
      add(LoadHomeEvent());
    } else {
      emit(DeletePollErrorState(error: jsonBody['message']));
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

    final res = await http.post(url, headers: headers, body: encodedBody);
    final decodedRes = jsonDecode(res.body);
    if (res.statusCode == 201) {
      add(LoadMembersEvent());
    } else {
      emit(AddMemberErrorState(error: decodedRes["message"]));
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

    print(res.body);
    add(LoadMembersEvent());
  }
}
