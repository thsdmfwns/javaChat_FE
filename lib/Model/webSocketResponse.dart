import 'package:java_chat/Model/user.dart';

class WebSocketResponse {
  final User? user;
  final int roomId;
  final String type;
  final String? message;

  WebSocketResponse(
      {this.user, required this.roomId, required this.type, this.message});

  factory WebSocketResponse.fromJson(Map<String, dynamic> json) {
    return WebSocketResponse(
        user: User.nullfromjson(json['user']),
        roomId: json['roomId'],
        type: json['type'],
        message: json['message']);
  }
}
