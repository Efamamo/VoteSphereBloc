import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import './comment_bloc_mock.dart'; // Update this path accordingly

class FakeHttpClient extends http.BaseClient {
  final bool shouldFail;

  FakeHttpClient({this.shouldFail = false});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = shouldFail
        ? http.Response(
            '{"success": false, "error": "Something went wrong"}', 400)
        : http.Response('{"success": true}', 200);
    return http.StreamedResponse(
      Stream.value(utf8.encode(response.body)),
      response.statusCode,
      headers: response.headers,
    );
  }
}

void main() {
  late FakeHttpClient fakeHttpClient;
  late HomeBloc homeBloc;

  setUp(() {
    fakeHttpClient = FakeHttpClient();
    homeBloc = HomeBloc(httpClient: fakeHttpClient);
  });

  tearDown(() {
    homeBloc.close();
  });

  group('HomeBloc Tests', () {
    blocTest<HomeBloc, HomeState>(
      'emits [AddCommentSuccess] when AddComment is successful',
      build: () {
        fakeHttpClient = FakeHttpClient(shouldFail: false);
        return HomeBloc(httpClient: fakeHttpClient);
      },
      act: (bloc) =>
          bloc.add(AddComment(pollId: 'poll123', comment: 'Nice comment')),
      expect: () => [isA<AddCommentSuccess>()],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [AddCommentFailure] when AddComment fails',
      build: () {
        fakeHttpClient = FakeHttpClient(shouldFail: true);
        return HomeBloc(httpClient: fakeHttpClient);
      },
      act: (bloc) =>
          bloc.add(AddComment(pollId: 'poll123', comment: 'Nice comment')),
      expect: () => [isA<AddCommentFailure>()],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [UpdateCommentSuccess] when UpdateComment is successful',
      build: () {
        fakeHttpClient = FakeHttpClient(shouldFail: false);
        return HomeBloc(httpClient: fakeHttpClient);
      },
      act: (bloc) => bloc.add(
          UpdateComment(comment: 'Updated comment', commentId: 'commentId123')),
      expect: () => [isA<UpdateCommentSuccess>()],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [UpdateCommentFailure] when UpdateComment fails',
      build: () {
        fakeHttpClient = FakeHttpClient(shouldFail: true);
        return HomeBloc(httpClient: fakeHttpClient);
      },
      act: (bloc) => bloc.add(
          UpdateComment(comment: 'Updated comment', commentId: 'commentId123')),
      expect: () => [isA<UpdateCommentFailure>()],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [DeleteCommentSuccess] when DeleteComment is successful',
      build: () {
        fakeHttpClient = FakeHttpClient(shouldFail: false);
        return HomeBloc(httpClient: fakeHttpClient);
      },
      act: (bloc) => bloc.add(DeleteComment(commentId: 'commentId123')),
      expect: () => [isA<DeleteCommentSuccess>()],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [DeleteCommentFailure] when DeleteComment fails',
      build: () {
        fakeHttpClient = FakeHttpClient(shouldFail: true);
        return HomeBloc(httpClient: fakeHttpClient);
      },
      act: (bloc) => bloc.add(DeleteComment(commentId: 'commentId123')),
      expect: () => [isA<DeleteCommentFailure>()],
    );
  });
}
