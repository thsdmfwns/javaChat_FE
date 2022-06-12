import 'package:java_chat/Model/user.dart';

enum WebSocketMessageType {
  chat,
  inOutMessage,
}

class WebSocketMessage {
  final User? user;
  final WebSocketMessageType type;
  final String? message;

  WebSocketMessage({this.user, required this.type, this.message});
}
