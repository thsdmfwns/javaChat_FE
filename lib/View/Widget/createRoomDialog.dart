import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:java_chat/Controller/chatPageController.dart';
import 'package:java_chat/Controller/createRoomDialogController.dart';

import 'BoolMessage.dart';
import 'textInputField.dart';

class CreateRoomDialog extends StatelessWidget {
  final controller = Get.put(CreateRoomDialogController());

  CreateRoomDialog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, bcs) => Dialog(
          insetPadding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.30, vertical: Get.height * 0.30),
          child: _buildDialog()),
    );
  }

  Widget _buildDialog() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Get.height * 0.015,
        horizontal: Get.width * 0.015,
      ),
      child: Column(
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              alignment: Alignment.topLeft,
              child: const Text('Create Room'),
            ),
          ),
          Flexible(
            flex: 5,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BoolMessage(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    bool: controller.roomNameCheck,
                    text: "사용가능한 채팅방 이름 입니다.",
                    color: Colors.green,
                    icon: Icons.check),
                TextInputField(
                  model: controller.createRoomTextModel,
                  width: Get.width * 0.25,
                  height: 90,
                  mainAxisAlignment: MainAxisAlignment.center,
                  checkButton: _bulldCheckButton(
                      onPressed: () => controller.onRoomNameCheck()),
                ),
                const Padding(padding: EdgeInsets.all(10)),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    child: const Text("OK"),
                    onPressed: () => controller.onCreateRoom() // <<<<<< 수정필요
                    ),
                TextButton(
                  child: const Text("Close"),
                  onPressed: () => controller.onClose(),
                )
              ],
            ),
          )
        ],
      ),
    );
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
