import 'package:get/get.dart';
import 'package:java_chat/Service/authService.dart';
import 'package:java_chat/Service/webSocketService.dart';

class InitPageController extends GetxController {
  final authService = Get.put(AuthService());
  final webSocketService = Get.put(WebSocketService());

  @override
  Future<void> onInit() async {
    super.onInit();
    await authService.getTokenFromStorage();
    if (authService.token.isEmpty) {
      Get.offAndToNamed('/login');
      return;
    }
    Get.offAndToNamed('/chat');
  }
}
