part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

abstract class HomeActionState extends HomeState {}

class NoGroupState extends HomeState {
  final group;
  final username;
  final token;
  final role;

  NoGroupState(
      {required this.group,
      required this.role,
      required this.token,
      required this.username});
}

class NoPollState extends HomeState {
  final group;
  final username;
  final token;
  final role;

  NoPollState(
      {required this.group,
      required this.role,
      required this.token,
      required this.username});
}

class HomeWithPollState extends HomeState {
  final group;
  final username;
  final token;
  final role;
  final polls;

  HomeWithPollState(
      {required this.group,
      required this.username,
      required this.polls,
      required this.role,
      required this.token});
}

class LoadingState extends HomeState {}

class NavigateToCreateGroupState extends HomeActionState {}

class CreateGroupState extends HomeState {
  final group;
  final username;
  final token;
  final role;

  CreateGroupState(
      {required this.group,
      required this.role,
      required this.token,
      required this.username});
}
