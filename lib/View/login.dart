import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:java_chat/Controller/loginController.dart';
import 'package:java_chat/View/Widget/BoolMessage.dart';
import 'package:java_chat/View/Widget/TextInputField.dart';

class LoginPage extends GetView<LoginPageController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    double height = Get.height.clamp(730, 1080) * 0.55;
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: Get.height * 0.15),
        child: SizedBox(
          height: height,
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5)),
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildTitle(height),
                      Padding(padding: EdgeInsets.all(height * 0.05)),
                      _buildInput(height),
                      Padding(padding: EdgeInsets.all(height * 0.025)),
                      _buildButton(height)
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'JavaChat',
          style: TextStyle(fontSize: height * 0.05),
        ),
        Text(
          'Login',
          style: TextStyle(fontSize: height * 0.075),
        ),
      ],
    );
  }

  _buildInput(double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextInputField(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          model: controller.idTextModel,
          width: height * 0.75,
        ),
        Padding(padding: EdgeInsets.all(5)),
        TextInputField(
          model: controller.pwTextModel,
          isPassword: true,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          width: height * 0.75,
        ),
      ],
    );
  }

  _buildButton(double height) {
    return SizedBox(
      width: height * 0.75,
      child: Column(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Text(
                '클릭하여 회원가입',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () => Get.toNamed('/register'),
            ),
          ),
          SizedBox(
              width: height * 0.75,
              height: 50,
              child: TextButton(
                  onPressed: () => controller.onLoginButton(),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "로그인",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ))),
          BoolMessage(bool: controller.loginError, text: "입력한 값을 한번더 체크 해주세요."),
        ],
      ),
    );
  }
}
