import 'dart:convert';

class User {
  final int? idx;
  final String userNick;
  final int userProfileColor;
  final String? userImage;

  User(
      {this.idx,
      required this.userNick,
      required this.userProfileColor,
      this.userImage});

  String toJson() {
    return jsonEncode({
      "idx": idx,
      "userNick": userNick,
      "userProfileColor": userProfileColor,
      "userImage": userImage,
    });
  }

  static User? nullfromjson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return User.fromJson(json);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        idx: json['idx'],
        userNick: json['userNick'],
        userProfileColor: json['userProfileColor'],
        userImage: json['userImage']);
  }

  static User get blank => User(userNick: "", userProfileColor: 0);
  bool get isBlank => userNick.isEmpty || userProfileColor == 0;
}
