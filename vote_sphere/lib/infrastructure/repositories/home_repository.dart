import 'package:vote_sphere/infrastructure/local_storage/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeRespository {
  static Future<Map> loadHome() async {
    final secureStorage = SecureStorage().secureStorage;
    final group = await secureStorage.read(key: "group");
    final role = await secureStorage.read(key: 'role');
    final username = await secureStorage.read(key: 'username');
    final token = await secureStorage.read(key: 'token');
    final email = await secureStorage.read(key: 'email');

    if (group == null) {
      return {
        "group": group,
        "role": role,
        "username": username,
        "token": token,
        "email": email
      };
    } else {
      String uri = 'http://localhost:9000/polls?groupId=$group';

      final url = Uri.parse(uri);
      final res =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});
      final jsonBody = jsonDecode(res.body);
      print(res.statusCode);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final polls = jsonBody;

        return {
          "group": group,
          "role": role,
          "username": username,
          "token": token,
          "polls": polls,
          "email": email
        };
      } else {
        return {
          "group": group,
          "role": role,
          "username": username,
          "token": token,
          "email": email
        };
      }
    }
  }

  static Future<bool> createGroup(event) async {
    final secureStorage = SecureStorage().secureStorage;
    final username = await secureStorage.read(key: 'username');
    final token = await secureStorage.read(key: 'token');
    final role = await secureStorage.read(key: 'role');

    final email = await secureStorage.read(key: 'email');

    String uri = 'http://localhost:9000/groups';
    final url = Uri.parse(uri);
    final body = {"adminUsername": username, "groupName": event.groupName};
    final jsonBody = jsonEncode(body);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.post(url, headers: headers, body: jsonBody);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      Map response = jsonDecode(res.body);

      await secureStorage.write(key: 'group', value: response["groupID"]);
      return true;
    }

    return false;
  }

  static Future<bool> addPole(event) async {
    try {
      final secureStorage = SecureStorage().secureStorage;
      final group = await secureStorage.read(key: 'group');
      final token = await secureStorage.read(key: 'token');

      if (group == null || token == null) {
        return false;
      }

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
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<bool> deletePoll(event) async {
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');

    String uri = 'http://localhost:9000/polls/${event.pollId}';
    final url = Uri.parse(uri);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.delete(url, headers: headers);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> vote(event) async {
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

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> addComment(event) async {
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

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateComment(event) async {
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');

    String uri = 'http://localhost:9000/polls/comments/${event.comId}';
    final url = Uri.parse(uri);
    final body = {"commentText": event.comment};

    final jsonBody = jsonEncode(body);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.patch(url, headers: headers, body: jsonBody);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteComment(event) async {
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');

    String uri = 'http://localhost:9000/polls/comments/${event.comId}';
    final url = Uri.parse(uri);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.delete(url, headers: headers);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return true;
    }
    return false;
  }

  static Future<Map> getMembers(event) async {
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
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final decodedBody = jsonDecode(res.body);
      return {"members": decodedBody, "role": role};
    }
    return {"error": "error"};
  }

  static Future<bool> addMember(event) async {
    try {
      // Retrieve the token and group from secure storage
      final secureStorage = SecureStorage().secureStorage;
      final token = await secureStorage.read(key: 'token');
      final group = await secureStorage.read(key: 'group');

      String uri = 'http://localhost:9000/groups/$group/members';
      final url = Uri.parse(uri);

      final body = {"username": event.username};
      final encodedBody = jsonEncode(body);
      final headers = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      };

      final res = await http.post(url, headers: headers, body: encodedBody);
      print(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  static Future<bool> deleteMember(event) async {
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

    try {
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
