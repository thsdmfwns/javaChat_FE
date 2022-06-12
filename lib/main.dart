import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:java_chat/Controller/RegisterPageController.dart';
import 'package:java_chat/Controller/chatPageController.dart';
import 'package:java_chat/Controller/initPageController.dart';
import 'package:java_chat/Controller/loginController.dart';
import 'package:java_chat/Service/authService.dart';
import 'package:java_chat/Service/webSocketService.dart';
import 'package:java_chat/View/RegisterPage.dart';
import 'package:java_chat/View/chatPage.dart';
import 'package:java_chat/View/initPage.dart';
import 'package:java_chat/View/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'JavaChat',
      initialRoute: '/',
      theme: ThemeData(fontFamily: "NotoSansKR"),
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage(), bindings: [
          BindingsBuilder.put(() => LoginPageController()),
        ]),
        GetPage(name: '/', page: () => const InitPage(), bindings: [
          BindingsBuilder.put(() => InitPageController()),
        ]),
        GetPage(
            name: '/register',
            page: () => const RegisterPage(),
            bindings: [BindingsBuilder.put(() => RegisterPageController())]),
        GetPage(
          name: '/chat',
          page: () => ChatPage(),
        )
      ],
    );
  }
}
