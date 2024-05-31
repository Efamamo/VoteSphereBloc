part of '../../application/blocs/home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

abstract class HomeActionState extends HomeState {}

class LogOutState extends HomeActionState {}

class NoGroupState extends HomeState {
  final group;
  final username;
  final token;
  final role;
  final email;

  NoGroupState(
      {required this.group,
      required this.role,
      required this.token,
      required this.username,
      required this.email});
}

class NoPollState extends HomeState {
  final group;
  final username;
  final token;
  final role;
  final emial;

  NoPollState(
      {required this.group,
      required this.role,
      required this.token,
      required this.username,
      required this.emial});
}

class HomeWithPollState extends HomeState {
  final group;
  final username;
  final token;
  final role;
  final polls;
  final email;

  HomeWithPollState(
      {required this.group,
      required this.username,
      required this.polls,
      required this.role,
      required this.email,
      required this.token});
  HomeWithPollState copyWith({List<dynamic>? polls}) {
    return HomeWithPollState(
      email: this.email,
      group: this.group,
      username: this.username,
      polls: polls ?? this.polls,
      role: this.role,
      token: this.token,
    );
  }
}

class LoadingState extends HomeState {}

class NavigateToCreateGroupState extends HomeActionState {}

class CreateGroupState extends HomeState {
  final group;
  final username;
  final token;
  final role;
  final email;

  CreateGroupState(
      {required this.group,
      required this.role,
      required this.token,
      required this.username,
      required this.email});
}

class NavigateToAddPoles extends HomeActionState {}

class NavigateToSettingState extends HomeActionState {}

class DeletePollErrorState extends HomeActionState {
  final error;
  DeletePollErrorState({required this.error});
}

class NavigateToMembersState extends HomeActionState {}

class MembersLoadingState extends HomeState {}

class MembersLoadedState extends HomeState {
  final role;
  final members;
  MembersLoadedState({required this.members, required this.role});
  MembersLoadedState copyWith({List<dynamic>? members}) {
    return MembersLoadedState(
      role: this.role,
      members: members ?? this.members,
    );
  }
}

class AddMemberErrorState extends HomeActionState {
  final error;
  AddMemberErrorState({required this.error});
}

class VoteError extends HomeActionState {
  final error;
  VoteError({required this.error});
}

class UnloggedState extends HomeActionState {}

class MemberPagePopped extends HomeState {}
