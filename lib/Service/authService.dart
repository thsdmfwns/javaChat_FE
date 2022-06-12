import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:java_chat/Model/user.dart';

import '../Connect/UserProvider.dart';

class AuthService extends GetxService {
  final storage = const FlutterSecureStorage();
  final userProvider = Get.put(UserProvider());
  String token = '';
  Rx<User> user = User.blank.obs;

  Future<User> getuser() async {
    var res = await userProvider.getUserByToken(token);
    if (res.hasError || res.body['error'] != null) {
      print("getUser error");
      Get.offAllNamed('/login');
      return User.blank;
    }
    return User.fromJson(res.body['data']);
  }

  Future getTokenFromStorage() async {
    var _token = await storage.read(key: 'token');
    if (_token == null) return;
    token = _token;
    user(await getuser());
  }

  Future logout() async {
    await storage.delete(key: 'token');
    token = "";
    user(User.blank);
    Get.offAndToNamed('/login');
  }

  Future setToken(String Token) async {
    token = Token;
    await storage.write(key: 'token', value: token);
    user(await getuser());
  }
}
