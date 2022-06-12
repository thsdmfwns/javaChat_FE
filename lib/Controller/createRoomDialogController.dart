import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:java_chat/View/Widget/textFieldModel.dart';

import '../Connect/roomProvider.dart';
import '../Model/Room.dart';
import '../Service/webSocketService.dart';

class CreateRoomDialogController extends GetxController {
  final _roomProvider = Get.put(RoomProvider());
  final webSocketService = Get.put(WebSocketService());

  RxBool roomNameCheck = false.obs;

  TextFieldModel createRoomTextModel = TextFieldModel(
    label: '채팅방 이름',
    textEditingController: TextEditingController(),
    helpText: '채팅방 이름이 중복되었는지 확인해야 합니다.',
  );

  Future<void> onCreateRoom() async {
    if (createRoomTextModel.text.isEmpty) {
      createRoomTextModel.errorText('이 항목은 비어 있습니다.');
      return;
    }
    if (roomNameCheck.isFalse) {
      createRoomTextModel.errorText('중복체크 해주세요.');
      return;
    }
    var res =
        await _roomProvider.postCreateRoom(createRoomTextModel.text.value);

    if (res.hasError || res.body['error'] != null) {
      roomNameCheck(false);
      createRoomTextModel.errorText('값을 한번더 체크해주세요.');
      return;
    }
    var room = Room.fromJson(res.body['data']);
    createRoomTextModel.clearText();
    roomNameCheck(false);
    Get.offAndToNamed('chat?id=${room.idx}');
  }

  void onRoomNameCheck() async {
    var res = await _roomProvider.postCheckName(createRoomTextModel.text.value);
    if (res.body['data'] as bool) {
      roomNameCheck(true);
      createRoomTextModel.errorText('');
      return;
    }
    createRoomTextModel.errorText('사용할 수 없는 채팅방 이름 입니다.');
  }

  void onClose() {
    createRoomTextModel.clearText();
    roomNameCheck(false);
    Get.back();
  }

  void _onDebounceCreateRoom() {
    roomNameCheck(false);
    createRoomTextModel.errorText('');
  }

  void _debounce({required TextFieldModel text, required Duration duration}) {
    debounce(text.text, (_) => _onDebounce(text), time: duration);
  }

  void _onDebounce(TextFieldModel text) {
    if (text == createRoomTextModel) return _onDebounceCreateRoom();
  }

  @override
  void onInit() {
    _debounce(
        text: createRoomTextModel, duration: const Duration(milliseconds: 10));
    super.onInit();
  }
}
