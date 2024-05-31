import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vote_sphere/infrastructure/local_storage/secure_storage.dart';

class SettingsRepository {
  static Future<Map> loadSetting(event) async {
    final secureStorage = SecureStorage().secureStorage;
    final username = await secureStorage.read(key: 'username');
    final email = await secureStorage.read(key: "email");
    final role = await secureStorage.read(key: "role");

    return {"username": username, "email": email, "role" : role};
  }

  static Future<String> changePassword(event) async {
    String uri = 'http://10.0.2.2:9000/auth/changePassword';
    final url = Uri.parse(uri);
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');
    final body = {"newPassword": event.newPassword};
    final jsonBody = jsonEncode(body);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final res = await http.patch(url, headers: headers, body: jsonBody);
    print(res.statusCode);
    if (res.statusCode == 200) {
      return "success";
    } else {
      final decodedBody = jsonDecode(res.body);
      var error = decodedBody["message"];
      if (decodedBody["message"] is! String) {
        error = decodedBody["message"][0];
      }
      return error;
    }
  }

  static Future<bool> deleteAccount() async {
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');
    String uri = 'http://10.0.2.2:9000/auth/deleteAccount';
    final url = Uri.parse(uri);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };
    final res = await http.delete(url, headers: headers);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      await secureStorage.deleteAll();
      return true;
    } else {
      return false;
    }
  }
}
