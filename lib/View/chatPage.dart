import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:java_chat/Controller/chatPageController.dart';
import 'package:java_chat/Model/room.dart';
import 'package:java_chat/Model/user.dart';

class ChatPage extends StatelessWidget {
  final controller = Get.put(
      ChatPageController(int.parse(Get.parameters['id'] ?? '1')),
      tag: '#${Get.parameters['id'] ?? '1'}');
  ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 75)),
              Expanded(
                  child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) =>
                    _Buildbody(),
              )),
            ],
          ),
          _buildHeader(),
          Obx(() => controller.isRoomsOpen.isTrue
              ? Container(color: const Color.fromRGBO(0, 0, 0, 0.5))
              : Container()),
          _buildCategory(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      height: 75,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(child: _buildLogo()),
            Obx(() => controller.authService.user.value.isBlank
                ? const SpinKitRing(color: Colors.green)
                : _buildUser(controller.authService.user.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildUser(User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            user.userNick,
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
        Container(
          height: double.infinity,
          width: 130,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 7.5),
          child: TextButton(
            style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.blue,
                textStyle: const TextStyle(
                  fontSize: 15,
                )),
            onPressed: () {},
            child: const Text("Make Room"),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => controller.isRoomsOpen(true),
          icon: const Icon(Icons.dehaze),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: const Text(
            'Java Chat',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Obx _buildCategory() {
    return Obx(() => AnimatedContainer(
          color: Colors.white,
          width: controller.isRoomsOpen.isTrue ? 250 : 0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.fastOutSlowIn,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "Rooms",
                      softWrap: false,
                    ),
                  )),
                  Container(
                    margin: const EdgeInsets.all(10),
                    height: 50,
                    width: 50,
                    child: IconButton(
                      onPressed: () => controller.isRoomsOpen(false),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                    controller: ScrollController(),
                    itemCount: controller.roomList.length,
                    itemBuilder: (ctx, idx) =>
                        roomButton(controller.roomList.elementAt(idx))),
              ),
            ],
          ),
        ));
  }

  Widget roomButton(Room room) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextButton(
        onPressed: () => Get.toNamed('/chat?id=${room.idx}'),
        style: TextButton.styleFrom(
            fixedSize: const Size(double.infinity, double.infinity)),
        child: Row(
          children: [
            const Icon(
              Icons.room,
              size: 32,
            ),
            const Padding(padding: EdgeInsets.all(5)),
            Text(room.roomName, style: const TextStyle(color: Colors.black))
          ],
        ),
      ),
    );
  }

  Widget _Buildbody() {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        color: Colors.black,
        width: Get.width * 0.5,
        height: Get.height * 0.5,
      ),
    );
  }
/*
  void openDialog() {
    Get.dialog(
      ChannelCreateDialog(),
    );
  }
  */
}
