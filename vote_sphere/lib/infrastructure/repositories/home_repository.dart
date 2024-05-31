import 'package:vote_sphere/infrastructure/data_provider/home_dataprovider.dart';
import 'package:vote_sphere/infrastructure/local_storage/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/http.dart%20';

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
      final res = await HomeDataProvider.loadHome() as Response;
      final jsonBody = jsonDecode(res.body);

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

    final res = await HomeDataProvider.createGroup(event) as Response;
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

      final res = await HomeDataProvider.addPole(event) as Response;

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  static Future<bool> deletePoll(event) async {
    final res = await HomeDataProvider.deletePoll(event) as Response;

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> vote(event) async {
    try {
      final res = await HomeDataProvider.vote(event) as Response;

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> addComment(event) async {
    final res = await HomeDataProvider.addComment(event) as Response;

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateComment(event) async {
    final res = await HomeDataProvider.updateComment(event) as Response;

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteComment(event) async {
    final res = await HomeDataProvider.deleteComment(event) as Response;
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return true;
    }
    return false;
  }

  static Future<Map> getMembers(event) async {
    final secureStorage = SecureStorage().secureStorage;
    final role = await secureStorage.read(key: 'role');

    final res = await HomeDataProvider.getMembers(event) as Response;
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final decodedBody = jsonDecode(res.body);
      return {"members": decodedBody, "role": role};
    }
    return {"error": "error"};
  }

  static Future<bool> addMember(event) async {
    try {
      final res = await HomeDataProvider.addMember(event) as Response;

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
    final res = await HomeDataProvider.deleteMember(event) as Response;

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
