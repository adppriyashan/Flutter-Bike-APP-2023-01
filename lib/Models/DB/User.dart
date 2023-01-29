import 'package:pickandgo/Models/Utils/JsonResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/Utils.dart';

class User {
  var id, status, usertype, name, email;

  User(this.id, this.status, this.usertype, this.name, this.email);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        status = json['status'],
        name = json['name'],
        usertype = json['usertype'],
        email = json['email'];

  static saveToken(JsonResponse resp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CustomUtils.setLoggedToken(resp.data["token"]);
    await prefs.setString("token", CustomUtils.getToken());
    await prefs.setBool("bio", false);
  }

  static Future getSavedToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  static Future needVerifyWithBiometrics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('bio');
  }

  static Future acceptBiometrics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('bio', true);
  }

  static saveUser(JsonResponse resp) async {
    await CustomUtils.setLoggedUser(resp.data["user"]);
  }
}
