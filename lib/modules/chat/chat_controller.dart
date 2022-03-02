// ignore_for_file: unnecessary_string_escapes, unrelated_type_equality_checks
import 'dart:async';

import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';
import 'package:intl/intl.dart';

class ChatScreenController extends GetxController {
  final List<StreamSubscription> _streams = <StreamSubscription>[];
  List<QueryDocumentSnapshot> getMessages = <QueryDocumentSnapshot>[];
  List<Chat> chatList = [];

  bool isOnline = false, isTyping = false;

  DateTime? lastSeen;

  RxBool isDelete = false.obs;

  String chatWithUsername = '', _email = '';

  String _messageId = "", _chatRoomId = '';
  String myUserName = '';

  TextEditingController msgController = TextEditingController();

  @override
  void onInit() {
    _email = Get.arguments['email'] ?? '';
    chatWithUsername = Get.arguments['otherUser'] ?? '';
    _chatRoomId = Get.arguments['chatRoomId'] ?? '';
    _init();
    super.onInit();
  }

  String msgTimeFormat(DateTime time) {
    String formattedTime = DateFormat.jm().format(time);
    return formattedTime;
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

  onClearAll() {
    for (var i = 0; i < getMessages.length; i++) {
      FireStoreMethods.instance
          .deleteAllMessages(_chatRoomId, getMessages[i].id);
    }
    update();
  }

  onMsgLongPress(String id) {
    _messageId = id;
    isDelete.toggle();
  }

  onDeleteMsg() {
    FireStoreMethods.instance.deleteMessage(_chatRoomId, _messageId);
    isDelete.value = false;
  }

  addMessage(bool sendClicked) {
    if (msgController.text != "") {
      String message = msgController.text;
      var lastMessageTs = DateTime.now();
      //messageId
      _messageId = randomAlphaNumeric(12);

      var chat = Chat(
          message: message,
          sendBy: myUserName,
          ts: lastMessageTs,
          messageId: _messageId);

      FireStoreMethods()
          .addMessage(_chatRoomId, _messageId, chat.toMap())
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": myUserName
        };

        FireStoreMethods()
            .updateLastMessageSend(_chatRoomId, lastMessageInfoMap);

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
    var presence = Users(
        isTyping: false,
        isOnline: AppPref.instance.isOnline,
        name: AppPref.instance.name,
        id: AppPref.instance.userId,
        email: AppPref.instance.email,
        lastSeen: DateTime.now(),
        username: AppPref.instance.username,
        password: AppPref.instance.password);
    print('psd: ${AppPref.instance.password}');
    isDelete.value = false;
    FocusManager.instance.primaryFocus?.unfocus();
    FireStoreMethods().updatePresence(AppPref().userId, presence.toMap());
  }

  whenTyping() {
    var presence = Users(
        isTyping: true,
        isOnline: true,
        name: AppPref.instance.name,
        id: AppPref.instance.userId,
        email: AppPref.instance.email,
        lastSeen: DateTime.now(),
        username: AppPref.instance.username,
        password: AppPref.instance.password);
    print('psds: ${AppPref.instance.password}');

    FireStoreMethods().updatePresence(AppPref().userId, presence.toMap());
  }

  _init() async {
    myUserName = AppPref.instance.username;
    FireStoreMethods().getChatRoomMessages(_chatRoomId).then((value) {
      _streams.add(value.listen((event) {
        getMessages = event.docs;
        update();
        print(getMessages.length);

        // print(getMessages[0]['message']);
        if (event.docs.isNotEmpty) {
          chatList = event.docs.map<Chat>((e) {
            return Chat(
                message: e['message'] ?? '',
                ts: (e['ts'] as Timestamp).toDate(),
                sendBy: e['sendBy'] ?? '',
                messageId: _messageId);
          }).toList();
        }
        print(chatList.length);
      }));
    });
    FireStoreMethods().getPresence(_email).then((value) {
      _streams.add(value.listen((event) {
        if (event.docs.isNotEmpty) {
          isOnline = event.docs[0]['isOnline'];
          isTyping = event.docs[0]['isTyping'];
          lastSeen = (event.docs[0]['lastSeen'] as Timestamp).toDate();
          update();
        }
      }));
      return null;
    });
  }
}
