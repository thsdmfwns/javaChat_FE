import 'dart:convert';

import 'package:get/get.dart';
import 'package:java_chat/Model/webSocketRequest.dart';
import 'package:java_chat/Model/webSocketResponse.dart';
import 'package:java_chat/Service/authService.dart';

class WebSocketService extends GetxService {
  final authService = Get.put(AuthService());
  GetSocket? websocket;
  RxBool isRunning = false.obs;
  List<void Function(WebSocketResponse msg)> onChat = [];
  List<void Function(WebSocketResponse msg)> onInOutMessage = [];

  void setWebSocket() {
    if (isRunning.isTrue) disposeWebSocket();
    var url = "wss://sonserver.xyz/javaChat/ws";
    websocket = GetSocket(url);
  }

  void disposeWebSocket() {
    if (websocket == null) {
      isRunning(false);
      return;
    }
    websocket?.close(1000);
    isRunning(false);
  }

  Future connect() async {
    setWebSocket();
    websocket?.onOpen(() {
      print('WebSocket open => ${websocket?.url}');
    });
    websocket?.onClose((close) {
      print('WebSocket Close => ${close.message}');
    });
    websocket?.onError((e) {
      print('WebSocket Close => ${e.message}');
    });
    websocket?.onMessage((data) {
      var msg = WebSocketResponse.fromJson(jsonDecode(data));
      switch (msg.type) {
        case "Chat":
          onChat.map((e) => e.call(msg));
          break;
        case "InOutMessage":
          onInOutMessage.map((e) => e.call(msg));
          break;
        default:
          return;
      }
    });

    websocket?.connect();
    isRunning(true);
  }

  Future<void> sendMessage(WebSocketRequest request) async {
    if (isRunning.isFalse) return;
    websocket?.send(request.toJson());
  }

  Future sendRoomIn(int id) async {
    if (authService.token.isEmpty) {
      Get.offAllNamed('/login');
      return;
    }
    var req =
        WebSocketRequest(auth: authService.token, roomId: id, type: 'RoomIn');
    await sendMessage(req);
  }

  Future sendRoomOut(int id) async {
    if (authService.token.isEmpty) {
      Get.offAllNamed('/login');
      return;
    }
    var req =
        WebSocketRequest(auth: authService.token, roomId: id, type: 'RoomOut');
    await sendMessage(req);
  }

  Future sendChat(int id, String text) async {
    if (authService.token.isEmpty) {
      Get.offAllNamed('/login');
      return;
    }
    var req = WebSocketRequest(
        auth: authService.token, roomId: id, type: 'chat', message: text);
    await sendMessage(req);
  }

  @override
  void onInit() {
    connect();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    disposeWebSocket();
  }
}
