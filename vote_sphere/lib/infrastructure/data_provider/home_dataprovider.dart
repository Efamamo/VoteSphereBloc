import 'package:vote_sphere/application/blocs/home_bloc.dart';
import 'package:vote_sphere/infrastructure/local_storage/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeDataProvider {
  static Future<Object> loadHome() async {
    final secureStorage = SecureStorage().secureStorage;
    final group = await secureStorage.read(key: "group");
    final token = await secureStorage.read(key: 'token');

    String uri = 'http://10.0.2.2:9000/polls?groupId=$group';

    final url = Uri.parse(uri);
    final res =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    return res;
  }

  static Future<Object> createGroup(event) async {
    final secureStorage = SecureStorage().secureStorage;
    final username = await secureStorage.read(key: 'username');
    final token = await secureStorage.read(key: 'token');

    String uri = 'http://10.0.2.2:9000/groups';
    final url = Uri.parse(uri);
    final body = {"adminUsername": username, "groupName": event.groupName};
    final jsonBody = jsonEncode(body);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.post(url, headers: headers, body: jsonBody);
    return res;
  }

  static Future<Object> addPole(event) async {
    final secureStorage = SecureStorage().secureStorage;
    final group = await secureStorage.read(key: 'group');
    final token = await secureStorage.read(key: 'token');

    if (group == null || token == null) {
      return false;
    }

    String uri = 'http://10.0.2.2:9000/polls';
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
    return res;
  }

  static Future<Object> deletePoll(event) async {
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');

    String uri = 'http://10.0.2.2:9000/polls/${event.pollId}';
    final url = Uri.parse(uri);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.delete(url, headers: headers);
    return res;
  }

  static Future<Object> vote(VoteEvent event) async {
    try {
      final secureStorage = SecureStorage().secureStorage;
      final token = await secureStorage.read(key: 'token');

      String uri =
          'http://10.0.2.2:9000/polls/${event.pollId}/vote?optionId=${event.optionId}';
      final url = Uri.parse(uri);
      final headers = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      };

      final res = await http.patch(url, headers: headers);
      return res;
    } catch (e) {
      print(e);
      return {};
    }
  }

  static Future<Object> addComment(event) async {
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');
    String uri = 'http://10.0.2.2:9000/polls/comments';
    final url = Uri.parse(uri);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final body = {"pollId": event.pollID, "commentText": event.comment};
    final jsonBody = jsonEncode(body);
    final res = await http.post(url, headers: headers, body: jsonBody);
    return res;
  }

  static Future<Object> updateComment(event) async {
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');

    String uri = 'http://10.0.2.2:9000/polls/comments/${event.comId}';
    final url = Uri.parse(uri);
    final body = {"commentText": event.comment};

    final jsonBody = jsonEncode(body);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.patch(url, headers: headers, body: jsonBody);
    return res;
  }

  static Future<Object> deleteComment(event) async {
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');

    String uri = 'http://10.0.2.2:9000/polls/comments/${event.comId}';
    final url = Uri.parse(uri);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.delete(url, headers: headers);
    return res;
  }

  static Future<Object> getMembers(event) async {
    final secureStorage = SecureStorage().secureStorage;

    final token = await secureStorage.read(key: 'token');
    final group = await secureStorage.read(key: 'group');

    String uri = 'http://10.0.2.2:9000/groups/${group}/members';
    final url = Uri.parse(uri);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.get(url, headers: headers);
    return res;
  }

  static Future<Object> addMember(event) async {
    // Retrieve the token and group from secure storage
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');
    final group = await secureStorage.read(key: 'group');

    String uri = 'http://10.0.2.2:9000/groups/$group/members';
    final url = Uri.parse(uri);

    final body = {"username": event.username};
    final encodedBody = jsonEncode(body);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.post(url, headers: headers, body: encodedBody);
    return res;
  }

  static Future<Object> deleteMember(event) async {
    final secureStorage = SecureStorage().secureStorage;

    final token = await secureStorage.read(key: 'token');
    final group = await secureStorage.read(key: 'group');

    String uri = 'http://10.0.2.2:9000/groups/${group}/members';

    final body = {"username": event.username};
    final encodedBody = jsonEncode(body);
    final url = Uri.parse(uri);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.delete(url, headers: headers, body: encodedBody);
    return res;
  }
}
