// ignore_for_file: unnecessary_string_escapes

import 'dart:async';

import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';

class HomeController extends GetxController {
  String myUserName = "";
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

  updateUser() {
    Map<String, dynamic> othersUpdatedPresenceInfoMap = {
      "isOnline": isDeviceConnected,
      "lastSeen": DateTime.now(),
      "isTyping": false,
    };
    FireStoreMethods().updatePresence(AppPref().userId, othersUpdatedPresenceInfoMap);
  }

/*
  onSearchBtnClick() async {
    isSearching = true;
    FireStoreMethods().getUserByUserName().then((value) {
      usersStream = value;
      update();
    });
  }
*/

  _init() {
    FireStoreMethods().getUserByUserName().then((value) {
      _usersStream.add(value.listen((event) {
        getUsers = event.docs;
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
}
