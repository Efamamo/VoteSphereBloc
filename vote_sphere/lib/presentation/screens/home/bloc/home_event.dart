part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class LoadHomeEvent extends HomeEvent {}

class OpenDialogToCreateGroup extends HomeEvent {}

class CreateGroup extends HomeEvent {
  final groupName;

  CreateGroup({required this.groupName});
}

class NavigateToAddPollEvent extends HomeEvent {}

class AddPoleEvent extends HomeEvent {
  final question;
  final options;

  AddPoleEvent({required this.question, required this.options});
}

class DeletePollEvent extends HomeEvent {
  final pollId;
  DeletePollEvent({required this.pollId});
}

class NavigateToSettings extends HomeEvent {}
