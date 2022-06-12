import 'package:get/get.dart';
import 'package:java_chat/Connect/roomProvider.dart';
import 'package:java_chat/Model/WebSocketMessage.dart';
import 'package:java_chat/Model/user.dart';
import 'package:java_chat/Service/authService.dart';
import 'package:java_chat/Service/webSocketService.dart';

import '../Model/room.dart';
import '../Model/webSocketResponse.dart';

class ChatPageController extends GetxController {
  final int id;
  final roomProvider = Get.put(RoomProvider());
  final webSocketService = Get.put(WebSocketService());
  final authService = Get.find<AuthService>();

  RxList<WebSocketMessage> chatList = <WebSocketMessage>[].obs;
  RxList<User> userList = <User>[].obs;
  RxList<Room> roomList = <Room>[].obs;
  Rx<Room> room = Room.blank.obs;
  RxBool isRoomsOpen = false.obs;

  ChatPageController(this.id);

  Future<List<User>> getusers() async {
    var res = await roomProvider.getRoomMember(id);
    if (res.hasError || res.body['error'] != null) {
      return [];
    }
    return (res.body['data'] as List).map((e) => User.fromJson(e)).toList();
  }

  Future<List<Room>> getrooms() async {
    var res = await roomProvider.getRooms();
    if (res.hasError || res.body['error'] != null) {
      return [];
    }
    return (res.body['data'] as List).map((e) => Room.fromJson(e)).toList();
  }

  Future<Room> getroom() async {
    var res = await roomProvider.getRoomById(id);
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
    userList(await getusers());
  }

  void addCallBack() {
    webSocketService.onChat.add((msg) => _onChat(msg));
    webSocketService.onInOutMessage.add((msg) => _onInoutMessage(msg));
  }

  void removeCallBack() {
    webSocketService.onChat.remove((msg) => _onChat(msg));
    webSocketService.onInOutMessage.remove((msg) => _onInoutMessage(msg));
  }

  @override
  void onReady() async {
    super.onReady();
    await authService.getTokenFromStorage();
    if (authService.token.isEmpty) {
      Get.offAllNamed('/login');
      return;
    }
    roomList(await getrooms());
    room(await getroom());
    addCallBack();
    webSocketService.sendRoomIn(id);
  }

  @override
  void onClose() {
    super.onClose();
    webSocketService.sendRoomOut(id);
    removeCallBack();
  }
}
