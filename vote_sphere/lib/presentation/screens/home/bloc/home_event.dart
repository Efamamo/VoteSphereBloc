part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class LoadHomeEvent extends HomeEvent {}

class OpenDialogToCreateGroup extends HomeEvent {}

class CreateGroup extends HomeEvent {
  final groupName;

  CreateGroup({required this.groupName});
}
