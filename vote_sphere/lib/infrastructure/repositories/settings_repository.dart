import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vote_sphere/infrastructure/data_provider/settings_dataprovider.dart';
import 'package:vote_sphere/infrastructure/local_storage/secure_storage.dart';
import 'package:http/http.dart%20';

class SettingsRepository {
  static Future<Map> loadSetting(event) async {
    final secureStorage = SecureStorage().secureStorage;
    final username = await secureStorage.read(key: 'username');
    final email = await secureStorage.read(key: "email");
    final role = await secureStorage.read(key: "role");

    return {"username": username, "email": email, "role": role};
  }

  static Future<String> changePassword(event) async {
    final res = await SettingsDataProvider.changePassword(event) as Response;

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

    final res = await SettingsDataProvider.deleteAccount() as Response;
    if (res.statusCode >= 200 && res.statusCode < 300) {
      await secureStorage.deleteAll();
      return true;
    } else {
      return false;
    }
  }
}
