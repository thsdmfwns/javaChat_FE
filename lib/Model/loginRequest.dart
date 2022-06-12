import 'dart:convert';

class LoginRequest {
  LoginRequest({required this.id, required this.pw});
  final String id;
  final String pw;

  String toJson() {
    return jsonEncode({
      "id": id,
      "pw": pw,
    });
  }
}
