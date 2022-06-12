import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:java_chat/Connect/roomProvider.dart';
import 'package:java_chat/Model/WebSocketMessage.dart';
import 'package:java_chat/Model/user.dart';
import 'package:java_chat/Service/authService.dart';
import 'package:java_chat/Service/webSocketService.dart';
import 'package:java_chat/View/Widget/textFieldModel.dart';

import '../Model/room.dart';
import '../Model/webSocketResponse.dart';

class ChatPageController extends GetxController {
  final int id;
  final _roomProvider = Get.put(RoomProvider());
  final webSocketService = Get.put(WebSocketService());
  final authService = Get.find<AuthService>();

  TextFieldModel chatTextModel = TextFieldModel(
    label: '채팅',
    textEditingController: TextEditingController(),
  );

  RxList<WebSocketMessage> chatList = <WebSocketMessage>[].obs;
  RxList<User> userList = <User>[].obs;
  RxList<Room> roomList = <Room>[].obs;
  Rx<Room> room = Room.blank.obs;
  RxBool isRoomsOpen = false.obs;

  ChatPageController(this.id);

  Future<void> onSubmit() async {
    _emptyCheck();
    if (chatTextModel.errorText.isNotEmpty) return;
    await webSocketService.sendChat(id, chatTextModel.text.value);
    chatTextModel.clearText();
  }

  Future<void> onLogout() async {
    await webSocketService.sendRoomOut(id);
    authService.logout();
  }

  void _emptyCheck() {
    if (chatTextModel.text.isEmpty) chatTextModel.errorText('이 항목은 비어 있습니다.');
  }

  void _debounce({required TextFieldModel text, required Duration duration}) {
    debounce(text.text, (_) => _onDebounce(text), time: duration);
  }

  void _onDebounce(TextFieldModel text) {
    if (text == chatTextModel) return _onDebounceChat();
  }

  void _onDebounceChat() {
    chatTextModel.errorText('');
  }

  Future<List<User>> _getusers() async {
    var res = await _roomProvider.getRoomMember(id);
    if (res.hasError || res.body['error'] != null) {
      return [];
    }
    return (res.body['data'] as List).map((e) => User.fromJson(e)).toList();
  }

  Future<List<Room>> _getrooms() async {
    var res = await _roomProvider.getRooms();
    if (res.hasError || res.body['error'] != null) {
      return [];
    }
    return (res.body['data'] as List).map((e) => Room.fromJson(e)).toList();
  }

  Future<Room> _getroom() async {
    var res = await _roomProvider.getRoomById(id);
    if (res.hasError || res.body['error'] != null) {
      Room.blank;
    }
    return Room.fromJson(res.body['data']);
  }

  void _onChat(WebSocketResponse res) {
    if (res.roomId != id) return;
    var msg = WebSocketMessage(
        user: res.user, type: WebSocketMessageType.chat, message: res.message);
    chatList.add(msg);
  }

  void _onInoutMessage(WebSocketResponse res) async {
    if (res.roomId != id) return;
    var msg = WebSocketMessage(
        type: WebSocketMessageType.inOutMessage, message: res.message);
    chatList.add(msg);
    userList(await _getusers());
  }

  void _addCallBack() {
    webSocketService.onChat.add((msg) => _onChat(msg));
    webSocketService.onInOutMessage.add((msg) => _onInoutMessage(msg));
  }

  void _removeCallBack() {
    webSocketService.onChat.remove((msg) => _onChat(msg));
    webSocketService.onInOutMessage.remove((msg) => _onInoutMessage(msg));
  }

  @override
  void onReady() async {
    super.onReady();
    _debounce(text: chatTextModel, duration: const Duration(milliseconds: 10));

    await authService.getTokenFromStorage();
    if (authService.token.isEmpty) {
      Get.offAllNamed('/login');
      return;
    }
    roomList(await _getrooms());
    room(await _getroom());
    _addCallBack();
    await webSocketService.sendRoomIn(id);
  }

  @override
  Future<void> onClose() async {
    super.onClose();
    await webSocketService.sendRoomOut(id);
    _removeCallBack();
    chatTextModel.textEditingController.dispose();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }
}
