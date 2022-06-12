import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:java_chat/Controller/RegisterPageController.dart';

import 'Widget/BoolMessage.dart';
import 'Widget/textInputField.dart';

class RegisterPage extends GetView<RegisterPageController> {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            Center(child: LayoutBuilder(builder: (ctx, bcs) => _buildBody())));
  }

  Widget _buildBody() {
    return Container(
        alignment: Alignment.center,
        width: Get.mediaQuery.size.width * 0.6,
        height: Get.mediaQuery.size.height * 0.85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            width: 1,
            color: Colors.black38,
          ),
        ), //  POINT: BoxDecoration
        child: SingleChildScrollView(
          child: Row(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.mediaQuery.size.width * 0.02)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'JavaChat',
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                  Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Get.mediaQuery.size.height * 0.03)),
                      const Text(
                        'JavaChat 회원가입',
                        style: TextStyle(fontSize: 24, color: Colors.black),
                      )
                    ],
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 7)),
                  BoolMessage(
                      bool: controller.idCheck,
                      text: "사용가능한 ID 입니다.",
                      color: Colors.green,
                      icon: Icons.check),
                  TextInputField(
                      width: Get.mediaQuery.size.width * 0.25,
                      model: controller.IdRegisterText,
                      checkButton: _bulldCheckButton(
                        onPressed: () => controller.onIdCheck(),
                      )),
                  const Padding(
                      padding: EdgeInsets.symmetric(
                    vertical: 7,
                  )),
                  TextInputField(
                    width: Get.mediaQuery.size.width * 0.25,
                    model: controller.Pw1RegisterText,
                    isPassword: true,
                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(
                    vertical: 7,
                  )),
                  TextInputField(
                    width: Get.mediaQuery.size.width * 0.25,
                    model: controller.Pw2RegisterText,
                    isPassword: true,
                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(
                    vertical: 7,
                  )),
                  BoolMessage(
                      bool: controller.nickCheck,
                      text: "사용가능한 닉네임 입니다.",
                      color: Colors.green,
                      icon: Icons.check),
                  TextInputField(
                    width: Get.mediaQuery.size.width * 0.25,
                    model: controller.NickRegisterText,
                    checkButton: _bulldCheckButton(
                        onPressed: () => controller.onNickCheck()),
                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(
                    vertical: 7,
                  )),
                  BoolMessage(
                      bool: controller.isError, text: "입력한 값을 한번더 체크 해주세요."),
                  SizedBox(
                    width: 150,
                    height: 45,
                    child: TextButton(
                        onPressed: () => controller.onRegister(),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          "회원가입",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: Get.mediaQuery.size.width * 0.2,
                    alignment: Alignment.center,
                    child: Image.network(
                      'https://sonserver.xyz:8888/image/register/register.webp',
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _bulldCheckButton({required Function() onPressed}) {
    return SizedBox(
        height: 50,
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          alignment: Alignment.topCenter,
          onPressed: () => onPressed(),
          child: const Text("확인",
              style: TextStyle(
                fontSize: 16,
              )),
        ));
  }
}
