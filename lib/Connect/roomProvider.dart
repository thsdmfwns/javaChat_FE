import 'package:get/get.dart';

class RoomProvider extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    httpClient.baseUrl = 'https://sonserver.xyz/javaChat/api/room/';
    httpClient.defaultContentType = 'application/json';
  }

  Future<Response> getRooms() => get('');

  Future<Response> getRoomById(int id) => get('$id');

  Future<Response> getRoomMember(int id) => get('member/$id');

  Future<Response> postCheckName(String name) =>
      post('checkName', null, query: {'name': name});

  Future<Response> postCreateRoom(String name) =>
      post('create', null, query: {'name': name});
}
