import 'package:get/get.dart';
import 'package:java_chat/Model/loginRequest.dart';
import 'package:java_chat/Model/registerRequest.dart';

class UserProvider extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = 'https://sonserver.xyz/javaChat/api/user/';
    httpClient.defaultContentType = 'application/json';
  }

  Future<Response> getUserByToken(String token) =>
      get('', query: {"token": token});

  Future<Response> getUserById(int id) => get('$id');

  Future<Response> postLogin(LoginRequest req) => post('login', req.toJson());

  Future<Response> postIdCheck(String id) =>
      post('checkId', null, query: {"id": id});

  Future<Response> postNickCheck(String nick) =>
      post('checkNick', null, query: {"nick": nick});

  Future<Response> postRegister(RegisterRequest register) =>
      post('register', register.toJson());
}
