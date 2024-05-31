import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vote_sphere/infrastructure/local_storage/secure_storage.dart';

class AuthRepository {
  static Future<String> login(event) async {
    String uri = 'http://10.0.2.2:9000/auth/signin';
    final url = Uri.parse(uri);

    final body = {"username": event.username, "password": event.password};
    final jsonBody = jsonEncode(body);
    final headers = {"Content-Type": "application/json"};

    final res = await http.post(url, headers: headers, body: jsonBody);
    Map response = jsonDecode(res.body);

    if (response.containsKey('message')) {
      var error = response["message"];

      if (error is! String) {
        error = error[0];
      }

      return error;
    } else {
      final secureStorage = SecureStorage().secureStorage;

      await secureStorage.write(key: "role", value: response["role"]);
      await secureStorage.write(key: "token", value: response["accessToken"]);
      await secureStorage.write(key: "username", value: response["username"]);
      await secureStorage.write(key: "group", value: response["groupID"]);
      await secureStorage.write(key: "email", value: response["email"]);

      return "success";
    }
  }

  static Future<String> signUp(event) async {
    String uri = 'http://10.0.2.2:9000/auth/signup';
    final url = Uri.parse(uri);
    final body = {
      "username": event.username,
      "role": event.role,
      "email": event.email,
      "password": event.password
    };

    final jsonBody = jsonEncode(body);
    final headers = {"Content-Type": "application/json"};

    final res = await http.post(url, headers: headers, body: jsonBody);
    Map response = jsonDecode(res.body);

    if (res.statusCode != 201) {
      var error = response["message"];

      if (error is! String) {
        error = error[0];
      }
      return error;
    } else {
      final secureStorage = SecureStorage().secureStorage;
      await secureStorage.write(key: "role", value: response["role"]);
      await secureStorage.write(key: "token", value: response["accessToken"]);
      await secureStorage.write(key: "username", value: response["username"]);
      await secureStorage.write(key: "group", value: response["groupID"]);
      await secureStorage.write(key: "email", value: response["email"]);

      return "success";
    }
  }

  static Future<void> signout() async {
    final secureStorage = SecureStorage().secureStorage;
    await secureStorage.deleteAll();
  }
}
