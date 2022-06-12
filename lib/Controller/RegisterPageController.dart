import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:java_chat/Connect/UserProvider.dart';
import 'package:java_chat/Model/registerRequest.dart';

import '../View/Widget/textFieldModel.dart';

class RegisterPageController extends GetxController {
  final userProvider = Get.put(UserProvider());

  TextFieldModel IdRegisterText = TextFieldModel(
    label: '아이디',
    textEditingController: TextEditingController(),
    helpText: '아이디가 중복되었는지 확인해야 합니다.',
  );
  TextFieldModel Pw1RegisterText = TextFieldModel(
      label: '비밀번호',
      textEditingController: TextEditingController(),
      helpText: '문자, 숫자, 기호를 조합하여 8자 이상을 사용하세요.');
  TextFieldModel Pw2RegisterText = TextFieldModel(
    label: '비밀번호 확인',
    textEditingController: TextEditingController(),
    helpText: '위에서 입력한 비밀번호와 같은값을 입력해주세요.',
  );
  TextFieldModel NickRegisterText = TextFieldModel(
    label: '닉네임',
    textEditingController: TextEditingController(),
    helpText: '닉네임이 중복되었는지 확인해야 합니다.',
  );

  List<TextFieldModel> get _textList =>
      [IdRegisterText, Pw1RegisterText, Pw2RegisterText, NickRegisterText];

  RxBool isError = false.obs;
  RxBool idCheck = false.obs;
  RxBool nickCheck = false.obs;

  void onNickCheck() async {
    var res = await userProvider.postNickCheck(NickRegisterText.text.value);
    if (res.body['data'] as bool) {
      nickCheck(true);
      return;
    }
    NickRegisterText.errorText('사용할 수 없는 닉네임 입니다.');
  }

  void onIdCheck() async {
    var res = await userProvider.postIdCheck(IdRegisterText.text.value);
    if (res.body['data'] as bool) {
      idCheck(true);
      return;
    }
    NickRegisterText.errorText('사용할 수 없는 Id 입니다.');
  }

  void onRegister() async {
    _emptyCheck();
    if (_errorCheck()) return;
    var req = RegisterRequest(
        userId: IdRegisterText.text.value,
        userPw: Pw1RegisterText.text.value,
        userNick: NickRegisterText.text.value,
        userProfileColor: Random().nextInt(Colors.primaries.length - 1) + 1);
    var res = await userProvider.postRegister(req);
    if (res.hasError || res.body['error'] != null || !res.body['data']) {
      isError(true);
      return;
    }
    Get.offNamed('/login');
  }

  bool _errorCheck() {
    for (var item in _textList) {
      if (item.errorText.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  void _emptyCheck() {
    for (var item in _textList) {
      if (item.text.isEmpty) {
        item.errorText('이 항목은 빈칸입니다.');
      }
    }
    if (IdRegisterText.text.isNotEmpty && idCheck.isFalse) {
      IdRegisterText.errorText('중복체크를 해주세요.');
    }
  }

  void _debounce(
      {required TextFieldModel text,
      Duration duration = const Duration(milliseconds: 10)}) {
    debounce(text.text, (_) => _onDebounce(text), time: duration);
  }

  void _onDebounce(TextFieldModel text) {
    if (text == IdRegisterText) return _onDebounceId();
    if (text == Pw1RegisterText) return _onDebouncePW1();
    if (text == Pw2RegisterText) return _onDebouncePw2();
    if (text == NickRegisterText) return _onDebounceNick();
  }

  void _onDebouncePW1() {
    if (Pw1RegisterText.text.isEmpty) {
      Pw1RegisterText.errorText('');
      return;
    }
    var reg = RegExp(
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,}$');
    if (!reg.hasMatch(Pw1RegisterText.text.value)) {
      Pw1RegisterText.errorText('올바른 비밀번호의 형식이 아닙니다.');
      return;
    }
    Pw1RegisterText.errorText('');
  }

  void _onDebounceNick() {
    !nickCheck(false);
    NickRegisterText.errorText('');
  }

  void _onDebounceId() {
    idCheck(false);
    if (IdRegisterText.text.isEmpty) {
      IdRegisterText.errorText('');
      return;
    }
    if (IdRegisterText.text.value.length < 6) {
      IdRegisterText.errorText('아이디는 6자 이상 작성해야 합니다.');
      return;
    }
    IdRegisterText.errorText('');
  }

  void _onDebouncePw2() {
    if (Pw2RegisterText.text.isEmpty) {
      Pw2RegisterText.errorText('');
      return;
    }
    if (Pw2RegisterText.text.value != Pw1RegisterText.text.value) {
      Pw2RegisterText.errorText('입력한 비밀번호가 위의 비밀번호와 다릅니다');
      return;
    }
    Pw2RegisterText.errorText('');
  }

  @override
  void onInit() {
    _debounce(text: IdRegisterText);
    _debounce(text: Pw1RegisterText);
    _debounce(text: Pw2RegisterText);
    _debounce(text: NickRegisterText);

    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
