import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class HomeEvent {}

class AddComment extends HomeEvent {
  final String pollId;
  final String comment;

  AddComment({required this.pollId, required this.comment});
}

class UpdateComment extends HomeEvent {
  final String comment;
  final String commentId;

  UpdateComment({required this.comment, required this.commentId});
}

class DeleteComment extends HomeEvent {
  final String commentId;

  DeleteComment({required this.commentId});
}

abstract class HomeState {}

class HomeInitial extends HomeState {}

class AddCommentSuccess extends HomeState {}

class AddCommentFailure extends HomeState {}

class UpdateCommentSuccess extends HomeState {}

class UpdateCommentFailure extends HomeState {}

class DeleteCommentSuccess extends HomeState {}

class DeleteCommentFailure extends HomeState {}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final http.Client httpClient;

  HomeBloc({required this.httpClient}) : super(HomeInitial()) {
    on<AddComment>((event, emit) async {
      final response = await HomeDataProvider.addComment(
          event.pollId, event.comment, httpClient);
      if (response.statusCode == 200) {
        emit(AddCommentSuccess());
      } else {
        emit(AddCommentFailure());
      }
    });

    on<UpdateComment>((event, emit) async {
      final response = await HomeDataProvider.updateComment(
          event.comment, event.commentId, httpClient);
      if (response.statusCode == 200) {
        emit(UpdateCommentSuccess());
      } else {
        emit(UpdateCommentFailure());
      }
    });

    on<DeleteComment>((event, emit) async {
      final response =
          await HomeDataProvider.deleteComment(event.commentId, httpClient);
      if (response.statusCode == 200) {
        emit(DeleteCommentSuccess());
      } else {
        emit(DeleteCommentFailure());
      }
    });
  }
}

class HomeDataProvider {
  static Future<http.Response> addComment(
      String pollId, String comment, http.Client client) async {
    final response = await client.post(
      Uri.parse('http://localhost:3000/comments'),
      body: jsonEncode({'pollId': pollId, 'comment': comment}),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  static Future<http.Response> updateComment(
      String comment, String commentId, http.Client client) async {
    final response = await client.patch(
      Uri.parse('http://localhost:3000/comments/$commentId'),
      body: jsonEncode({'comment': comment}),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  static Future<http.Response> deleteComment(
      String commentId, http.Client client) async {
    final response = await client.delete(
      Uri.parse('http://localhost:3000/comments/$commentId'),
    );
    return response;
  }
}
