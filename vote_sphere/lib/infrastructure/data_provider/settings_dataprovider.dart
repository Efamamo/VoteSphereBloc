import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vote_sphere/infrastructure/local_storage/secure_storage.dart';

class SettingsDataProvider {
  static Future<Object> changePassword(event) async {
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
    return res;
  }

  static Future<Object> deleteAccount() async {
    final secureStorage = SecureStorage().secureStorage;
    final token = await secureStorage.read(key: 'token');
    String uri = 'http://10.0.2.2:9000/auth/deleteAccount';
    final url = Uri.parse(uri);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };
    final res = await http.delete(url, headers: headers);
    return res;
  }
}
