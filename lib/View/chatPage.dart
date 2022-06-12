import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:java_chat/Controller/chatPageController.dart';
import 'package:java_chat/Model/WebSocketMessage.dart';
import 'package:java_chat/Model/room.dart';
import 'package:java_chat/Model/user.dart';
import 'package:java_chat/View/Widget/createRoomDialog.dart';
import 'package:java_chat/View/Widget/textInputField.dart';

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
                : _buildHeaderButtons(controller.authService.user.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderButtons(User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildHeaderUser(user)),
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
            onPressed: () => Get.dialog(
              CreateRoomDialog(),
            ),
            child: const Text("Make Room"),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderUser(User user) {
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
      customButton: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.account_circle,
            color: Colors.primaries[user.userProfileColor],
            size: 30,
          ),
          const Padding(padding: EdgeInsets.all(4)),
          Text(
            user.userNick,
            style: const TextStyle(fontSize: 27, color: Colors.black),
          ),
        ],
      ),
      customItemsHeight: 8,
      items: [
        DropdownMenuItem(
          value: "Logout",
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(
                Icons.logout,
                color: Colors.black,
                size: 23,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Log Out",
                style: TextStyle(color: Colors.black, fontSize: 21),
              ),
            ],
          ),
        ),
      ],
      onChanged: (value) => controller.onLogout(),
      itemHeight: 35,
      itemPadding: const EdgeInsets.only(left: 16, right: 16),
      dropdownWidth: 160,
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      dropdownElevation: 8,
      offset: const Offset(0, -2),
    ));
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
        onPressed: () => room.idx == controller.id
            ? controller.isRoomsOpen(false)
            : Get.offAndToNamed('/chat?id=${room.idx}'),
        style: TextButton.styleFrom(
            backgroundColor: room.idx == controller.id
                ? Colors.green.withOpacity(0.2)
                : Colors.white,
            primary: Colors.white,
            fixedSize: const Size(double.infinity, double.infinity)),
        child: Row(
          children: [
            const Icon(
              Icons.room,
              size: 32,
              color: Colors.blue,
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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        width: double.infinity,
        height: 830,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => controller.room.value.isBlank
                ? const SpinKitRing(
                    color: Colors.green,
                    size: 25,
                  )
                : Text(
                    controller.room.value.roomName,
                    style: const TextStyle(fontSize: 25),
                  )),
            const Padding(padding: EdgeInsets.all(5)),
            Expanded(
              child: Row(children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _buildChatting(),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(5)),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _buildUsers(),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsers() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
                  'Users : ${controller.userList.length}',
                  style: const TextStyle(fontSize: 20),
                )),
            const Padding(padding: EdgeInsets.all(5)),
            Obx(() => ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: ((context, index) =>
                      _buildUser(controller.userList.elementAt(index))),
                  itemCount: controller.userList.length,
                )),
          ]),
    );
  }

  Widget _buildUser(User user) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.account_circle,
            color: Colors.primaries[user.userProfileColor],
            size: 23,
          ),
          const Padding(padding: EdgeInsets.all(4)),
          Text(
            user.userNick,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildChatting() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Obx(() => ListView.builder(
              shrinkWrap: true,
              itemCount: controller.chatList.length,
              itemBuilder: ((context, index) =>
                  _buildChat(controller.chatList.elementAt(index))))),
        )),
        TextInputField(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          model: controller.chatTextModel,
          width: Get.width * 0.5,
          checkButton: SizedBox(
            height: 55,
            child: TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.blue,
                  textStyle: const TextStyle(
                    fontSize: 15,
                  )),
              onPressed: () => controller.onSubmit(),
              child: const Text("Chat"),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChat(WebSocketMessage msg) {
    switch (msg.type) {
      case WebSocketMessageType.chat:
        return Container(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.account_circle,
                color: Colors.primaries[msg.user?.userProfileColor as int],
                size: 28,
              ),
              const Padding(padding: EdgeInsets.all(4)),
              Text(
                msg.user?.userNick as String,
                style: const TextStyle(fontSize: 25),
              ),
              const Padding(padding: EdgeInsets.all(4)),
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.primaries[msg.user?.userProfileColor as int]
                    .withOpacity(0.5),
                child: Text(
                  msg.message as String,
                  style: const TextStyle(color: Colors.black, fontSize: 23),
                ),
              )
            ],
          ),
        );
      case WebSocketMessageType.inOutMessage:
        return Center(
          child: Text(
            msg.message as String,
            style: const TextStyle(color: Colors.black54, fontSize: 20),
          ),
        );
    }
  }
}
