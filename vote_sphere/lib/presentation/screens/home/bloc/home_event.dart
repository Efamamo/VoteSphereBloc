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

class VoteEvent extends HomeEvent {
  final pollId;
  final optionId;
  VoteEvent({required this.optionId, required this.pollId});
}

class SendCommentEvent extends HomeEvent {
  final pollID;
  final comment;
  SendCommentEvent({required this.comment, required this.pollID});
}

class DeleteComment extends HomeEvent {
  final comId;
  final pollId;
  DeleteComment({required this.comId, required this.pollId});
}

class NavigateToMembersEvent extends HomeEvent {}

class LoadMembersEvent extends HomeEvent {}

class AddMemberEvent extends HomeEvent {
  final username;
  AddMemberEvent({required this.username});
}

class DeleteMemberEvent extends HomeEvent {
  final username;
  DeleteMemberEvent({required this.username});
}

class UpdateCommentEvent extends HomeEvent {
  final comment;
  final pollId;
  final comId;
  UpdateCommentEvent(
      {required this.comment, required this.comId, required this.pollId});
}
