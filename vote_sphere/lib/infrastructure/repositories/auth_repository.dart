import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vote_sphere/infrastructure/data_provider/auth_dataprovider.dart';
import 'package:vote_sphere/infrastructure/local_storage/secure_storage.dart';

class AuthRepository {
  static Future<String> login(event) async {
    final res = await AuthDataProvider.login(event) as http.Response;
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
    final res = await AuthDataProvider.signUp(event) as http.Response;
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
