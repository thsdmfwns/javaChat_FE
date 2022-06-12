import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:java_chat/Connect/UserProvider.dart';
import 'package:java_chat/Model/loginRequest.dart';
import 'package:java_chat/Service/authService.dart';

import '../View/Widget/textFieldModel.dart';

class LoginPageController extends GetxController {
  final userProvider = Get.put(UserProvider());
  final authservice = Get.put(AuthService());

  TextFieldModel idTextModel = TextFieldModel(
    label: '아이디',
    textEditingController: TextEditingController(),
  );
  TextFieldModel pwTextModel = TextFieldModel(
    label: '비밀번호',
    textEditingController: TextEditingController(),
  );
  RxBool loginError = false.obs;

  void onLoginButton() async {
    _emptyCheck();
    if (idTextModel.errorText.isNotEmpty || pwTextModel.errorText.isNotEmpty) {
      return;
    }
    var req =
        LoginRequest(id: idTextModel.text.value, pw: pwTextModel.text.value);
    var res = await userProvider.postLogin(req);
    if (res.hasError || res.body['error'] != null) {
      loginError(true);
      return;
    }
    await authservice.setToken(res.body['data']['token'] as String);
    print(authservice.token);
    Get.offAndToNamed('/chat');
  }

  void _emptyCheck() {
    if (idTextModel.text.isEmpty) idTextModel.errorText('이 항목은 비어 있습니다.');
    if (pwTextModel.text.isEmpty) pwTextModel.errorText('이 항목은 비어 있습니다.');
  }

  void _debounce({required TextFieldModel text, required Duration duration}) {
    debounce(text.text, (_) => _onDebounce(text), time: duration);
  }

  void _onDebounce(TextFieldModel text) {
    if (text == idTextModel) return _onDebounceId();
    if (text == pwTextModel) return _onDebouncePw();
  }

  void _onDebounceId() {
    idTextModel.errorText('');
  }

  void _onDebouncePw() {
    pwTextModel.errorText('');
  }

  @override
  void onInit() {
    _debounce(text: idTextModel, duration: const Duration(milliseconds: 10));
    _debounce(text: pwTextModel, duration: const Duration(milliseconds: 10));
    super.onInit();
  }
}
