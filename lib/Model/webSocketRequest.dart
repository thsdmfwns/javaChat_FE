import 'dart:convert';

class WebSocketRequest {
  final String auth;
  final int roomId;
  final String type;
  final String? message;

  WebSocketRequest(
      {required this.auth,
      required this.roomId,
      required this.type,
      this.message});

  String toJson() {
    return jsonEncode({
      "auth": auth,
      "roomId": roomId,
      "type": type,
      "message": message,
    });
  }
}
