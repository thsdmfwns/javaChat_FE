import 'dart:convert';

class RegisterRequest {
  final String userId;
  final String userPw;
  final String userNick;
  final int userProfileColor;

  RegisterRequest(
      {required this.userId,
      required this.userPw,
      required this.userNick,
      required this.userProfileColor});

  String toJson() {
    return jsonEncode({
      "userId": userId,
      "userPw": userPw,
      "userNick": userNick,
      "userProfileColor": userProfileColor,
    });
  }
}
