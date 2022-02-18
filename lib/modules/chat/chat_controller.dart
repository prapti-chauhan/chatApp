// ignore_for_file: unnecessary_string_escapes, unrelated_type_equality_checks
import 'dart:async';

import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';

class ChatScreenController extends GetxController {
  final List<StreamSubscription> _streams = <StreamSubscription>[];
  List<QueryDocumentSnapshot> getMessages = <QueryDocumentSnapshot>[];
  bool isOnline = false, isTyping = false ;
  RxBool isDelete = false.obs;
  DateTime? lastSeen;

  String chatWithUsername = '', _email = '';

  Map<String, dynamic> _arguments = {};
  String _messageId = "", _chatRoomId = '';
  String myUserName = '';

  TextEditingController msgController = TextEditingController();

  @override
  void onInit() {
    _arguments = Get.arguments as Map<String, dynamic>;
    _email = _arguments['email'] ?? '';
    chatWithUsername = _arguments['otherUser'] ?? '';
    _chatRoomId = _arguments['chatRoomId'] ?? '';
    _init();
    super.onInit();
  }

  String? lastSeenFormat(DateTime lastSeen) {
    Rx<Duration> diff = DateTime.now().difference(lastSeen).obs;
    if (diff.value.inDays > 365) {
      return "last seen ${(diff.value.inDays / 365).floor()} ${(diff.value.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    } else if (diff.value.inDays > 30) {
      return "last seen ${(diff.value.inDays / 30).floor()} ${(diff.value.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    } else if (diff.value.inDays > 7) {
      return "last seen ${(diff.value.inDays / 7).floor()} ${(diff.value.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    } else if (diff.value.inDays > 0) {
      return "last seen ${diff.value.inDays} ${diff.value.inDays == 1 ? "day" : "days"} ago";
    } else if (diff.value.inHours > 0) {
      return "last seen ${diff.value.inHours} ${diff.value.inHours == 1 ? "hour" : "hours"} ago";
    } else if (diff.value.inMinutes > 0) {
      return "last seen ${diff.value.inMinutes} ${diff.value.inMinutes == 1 ? "minute" : "minutes"} ago";
    } else if (diff.value.inSeconds > 0) {
      return "last seen ${diff.value.inSeconds} ${diff.value.inSeconds == 1 ? "second" : "seconds"} ago";
    }
    return "last seen ${diff.value.inSeconds} ${diff.value.inSeconds == 1 ? "second" : "seconds"} ago";
  }

  @override
  void onClose() {
    for (var element in _streams) {
      element.cancel();
    }
    super.onClose();
  }

  onMsgLongPress(int index){
    _messageId = getMessages[index].id;
    isDelete.toggle();
  }

  onDeleteMsg(){
    FireStoreMethods().deleteMessage(_chatRoomId, _messageId);
  }

  addMessage(bool sendClicked) {
    if (msgController.text != "") {
      String message = msgController.text;
      var lastMessageTs = DateTime.now();
      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": lastMessageTs,
      };

      //messageId
      if (_messageId == "") {
        _messageId = randomAlphaNumeric(12);
      }

      FireStoreMethods()
          .addMessage(_chatRoomId, _messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": myUserName
        };

        FireStoreMethods().updateLastMessageSend(_chatRoomId, lastMessageInfoMap);

        if (sendClicked) {
          // remove the text in the message input field
          msgController.clear();
          // make message id blank to get regenerated on next message send
          _messageId = "";
        }
      });
    }
  }

  hideKeyboard() {
    Map<String, dynamic> presenceInfoMap = {
      "isTyping": false,
    };
    isDelete.value = false;
    FocusManager.instance.primaryFocus?.unfocus();
    FireStoreMethods().updatePresence(AppPref().userId, presenceInfoMap);
  }


  whenTyping() {
    Map<String, dynamic> othersUpdatedPresenceInfoMap = {
      "isTyping": true,
    };
    FireStoreMethods().updatePresence(AppPref().userId, othersUpdatedPresenceInfoMap);
  }

  _init() async {
    myUserName = AppPref.instance.username;
    FireStoreMethods().getChatRoomMessages(_chatRoomId).then((value) {
      _streams.add(value.listen((event) {
        getMessages = event.docs;
        update();
      }));
    });
    FireStoreMethods().getPresence(_email).then((value) {
      _streams.add(value.listen((event) {
        isOnline = event.docs[0]['isOnline'];
        isTyping = event.docs[0]['isTyping'];
        lastSeen = (event.docs[0]['lastSeen'] as Timestamp).toDate();
        update();
      }));
      return null;
    });
  }
}
