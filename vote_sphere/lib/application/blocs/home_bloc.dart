import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vote_sphere/infrastructure/local_storage/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:vote_sphere/infrastructure/repositories/home_repository.dart';
part '../../presentation/events/home_event.dart';
part '../../presentation/states/home_state.dart';

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
    on<UpdateCommentEvent>(updateCommentEvent);
    on<PopMemberPageEvent>(popMemberPageEvent);
  }

  FutureOr<void> loadHomeEvent(
      LoadHomeEvent event, Emitter<HomeState> emit) async {
    final res = await HomeRespository.loadHome();
    if (res['token'] == null) {
      emit(UnloggedState());
    } else if (res["group"] == null) {
      emit(NoGroupState(
          group: res["group"],
          role: res["role"],
          token: res["token"],
          username: res["username"],
          email: res["email"]));
    } else if (res.containsKey("polls")) {
      emit(HomeWithPollState(
          group: res["group"],
          username: res["username"],
          polls: res["polls"],
          role: res["role"],
          email: res["email"],
          token: res["token"]));
    }
  }

  FutureOr<void> openDialogToCreateGroup(
      OpenDialogToCreateGroup event, Emitter<HomeState> emit) {
    emit(NavigateToCreateGroupState());
  }

  FutureOr<void> createGroup(CreateGroup event, Emitter<HomeState> emit) async {
    bool res = await HomeRespository.createGroup(event);

    if (res) {
      add(LoadHomeEvent());
    }
  }

  FutureOr<void> navigateToAddPollEvent(
      NavigateToAddPollEvent event, Emitter<HomeState> emit) {
    emit(NavigateToAddPoles());
  }

  FutureOr<void> addPoleEvent(
      AddPoleEvent event, Emitter<HomeState> emit) async {
    bool res = await HomeRespository.addPole(event);
    if (res) {
      add(LoadHomeEvent());
    }
  }

  FutureOr<void> deletePollEvent(
      DeletePollEvent event, Emitter<HomeState> emit) async {
    bool res = await HomeRespository.deletePoll(event);
    if (res) {
      add(LoadHomeEvent());
    } else {
      emit(DeletePollErrorState(
          error: "Admin Cant Delete The Poll That is already Voted On"));
    }
  }

  FutureOr<void> navigateToSettings(
      NavigateToSettings event, Emitter<HomeState> emit) {
    emit(NavigateToSettingState());
  }

  FutureOr<void> voteEvent(VoteEvent event, Emitter<HomeState> emit) async {
    bool res = await HomeRespository.vote(event);
    if (res) {
      add(LoadHomeEvent());
    } else {
      emit(VoteError(error: "You already Voted on the Poll"));
    }
  }

  FutureOr<void> sendCommentEvent(
      SendCommentEvent event, Emitter<HomeState> emit) async {
    bool res = await HomeRespository.addComment(event);
    if (res) {
      add(LoadHomeEvent());
    }
  }

  FutureOr<void> updateCommentEvent(
      UpdateCommentEvent event, Emitter<HomeState> emit) async {
    bool res = await HomeRespository.updateComment(event);
    if (res) {
      add(LoadHomeEvent());
    } else {
      emit(DeletePollErrorState(error: "The comment doesnt belong to you"));
    }
  }

  FutureOr<void> deleteComment(
      DeleteComment event, Emitter<HomeState> emit) async {
    bool res = await HomeRespository.deleteComment(event);

    if (res) {
      add(LoadHomeEvent());
    } else {
      emit(DeletePollErrorState(error: "Cant delate other peoples comment"));
    }
  }

  FutureOr<void> navigateToMembersEvent(
      NavigateToMembersEvent event, Emitter<HomeState> emit) {
    emit(NavigateToMembersState());
  }

  FutureOr<void> loadMembersEvent(
      LoadMembersEvent event, Emitter<HomeState> emit) async {
    Map res = await HomeRespository.getMembers(event);
    if (res.containsKey("error")) {
      add(LoadHomeEvent());
    } else {
      emit(MembersLoadedState(members: res["members"], role: res["role"]));
    }
  }

  FutureOr<void> addMemberEvent(
      AddMemberEvent event, Emitter<HomeState> emit) async {
    bool res = await HomeRespository.addMember(event);
    if (res) {
      add(LoadMembersEvent());
    } else {
      emit(AddMemberErrorState(error: "you cant add ${event.username}"));
    }
  }

  FutureOr<void> deleteMemberEvent(
      DeleteMemberEvent event, Emitter<HomeState> emit) async {
    bool res = await HomeRespository.deleteMember(event);
    if (res) {
      add(LoadMembersEvent());
    } else {
      emit(AddMemberErrorState(error: "You cant delete${event.username}"));
    }
  }

  FutureOr<void> popMemberPageEvent(
      PopMemberPageEvent event, Emitter<HomeState> emit) {
    add(LoadHomeEvent());
  }
}
