import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';

class FireStoreMethods {
  static final FireStoreMethods instance = FireStoreMethods._pvtConstructor();

  factory FireStoreMethods() => instance;

  FireStoreMethods._pvtConstructor();

  Future addUserInfoToDB(
      String userId, Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }

  createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      // chatroom does not exists
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future addOthersPresence(
      Map<String, dynamic> othersCurrentPresenceInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc()
        .set(othersCurrentPresenceInfoMap);
  }

  Future<Stream<QuerySnapshot>> getUserByUserName() async {
    return FirebaseFirestore.instance
        .collection("users")
        .where('username', isNotEqualTo: AppPref.instance.username)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  Future addMessage(
    String chatRoomId,
    String messageId,
      Chat chat
  ) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(chat.toMap());
  }

  updateLastMessageSend(
      String chatRoomId, Map<String, dynamic> lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  deleteMessage(String chatRoomId, messageId) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .delete();
  }

  deleteAllMessages(String chatRoomId, messageId) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('chats')
        .doc(messageId)
        .delete()
        .then((value) {
    }).onError((error, stackTrace) {
    });
  }

  Future<Stream<QuerySnapshot>> getPresence(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: email)
        .snapshots();
  }

  Future<QuerySnapshot> getProfileDetails() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: AppPref.instance.email)
        .get();
  }

  updateProfile(String userId, Map<String, dynamic> resetProfileInfoMap) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update(resetProfileInfoMap);
  }

  updatePresence(String userId, Map<String, dynamic> updatedPresenceInfoMap) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update(updatedPresenceInfoMap);
  }
}
