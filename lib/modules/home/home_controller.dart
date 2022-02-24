// ignore_for_file: unnecessary_string_escapes

import 'dart:async';

import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';
import 'package:flutter/services.dart';

class HomeController extends GetxController {
  String myUserName = "";
  List<QueryDocumentSnapshot> searchedUsers = <QueryDocumentSnapshot>[];
  List<QueryDocumentSnapshot> getUsers = <QueryDocumentSnapshot>[];

  TextEditingController searchController = TextEditingController();

  final List<StreamSubscription> _usersStream = <StreamSubscription>[];

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  @override
  void onClose() {
    for (var element in _usersStream) {
      element.cancel();
    }
    super.onClose();
  }

  forUpdateUser() {
    var presence = Users(
        isOnline: isDeviceConnected, lastSeen: DateTime.now(), isTyping: false);
    FireStoreMethods().updatePresence(AppPref().userId, presence.toMap());
  }

  _init() {
    FireStoreMethods().getUserByUserName().then((value) {
      _usersStream.add(value.listen((event) {
        getUsers = event.docs;
        searchedUsers = getUsers;
        // finalUserList(searchController.text);
        update();
      }));
    });
    myUserName = AppPref().username;
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
    searchController.clear();
  }

  exitDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Exit"),
            content: const Text("Are you sure to exit?"),
            actions: [
              ElevatedButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.greenAccent),
                onPressed: () {
                  SystemNavigator.pop();
                },
              ),
              ElevatedButton(
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                  onPressed: () {
                    Get.back();
                  })
            ],
          );
        });
  }

  logoutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Logout'),
            content: const Text("Are you sure to logout?"),
            actions: <Widget>[
              ElevatedButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.greenAccent),
                onPressed: () {
                  AppPref().logout();
                  var isOnline = Users(isOnline: false);
                  FireStoreMethods()
                      .updatePresence(AppPref().userId, isOnline.toMap());
                  Get.offAllNamed(AppRoutes.signIn);
                },
              ),
              ElevatedButton(
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                  onPressed: () {
                    Get.back();
                  })
            ],
          );
        });
  }

  forChat(String username, email) {
    var chatRoomId = getChatRoomIdByUsernames(myUserName, username);

    Map<String, dynamic> chatRoomInfoMap = {
      "users": [myUserName, username],
    };
    FireStoreMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
    forUpdateUser();
    Get.toNamed(AppRoutes.chat, arguments: {
      'myUserName': myUserName,
      "otherUser": username,
      "email": email,
      "chatRoomId": chatRoomId
    });
  }

  finalUserList(String text) {
    searchedUsers.clear();
    searchedUsers.addAll(
      getUsers.where(
        (element) =>
            (element['name'] as String).isCaseInsensitiveContains(text),
      ),
    );
    update();
  }
}
