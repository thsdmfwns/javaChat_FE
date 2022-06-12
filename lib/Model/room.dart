class Room {
  final int idx;
  final String roomName;

  Room({required this.idx, required this.roomName});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(idx: json['idx'], roomName: json['roomName']);
  }

  static Room get blank => Room(idx: 0, roomName: '');
  bool get isBlank => idx == 0 || roomName.isEmpty;
}
