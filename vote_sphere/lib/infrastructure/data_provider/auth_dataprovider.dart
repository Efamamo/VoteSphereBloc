import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vote_sphere/infrastructure/local_storage/secure_storage.dart';

class AuthDataProvider {
  static Future<Object> login(event) async {
    String uri = 'http://10.0.2.2:9000/auth/signin';
    final url = Uri.parse(uri);

    final body = {"username": event.username, "password": event.password};
    final jsonBody = jsonEncode(body);
    final headers = {"Content-Type": "application/json"};

    final res = await http.post(url, headers: headers, body: jsonBody);
    return res;
  }

  static Future<Object> signUp(event) async {
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
    return res;
  }

  static Future<void> signout() async {
    final secureStorage = SecureStorage().secureStorage;
    await secureStorage.deleteAll();
  }
}
