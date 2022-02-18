import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';

class FireStoreMethods {
  Future addUserInfoToDB(String userId, Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance.collection("users").doc(userId).set(userInfoMap);
  }

  Future<QuerySnapshot> getUserInfo(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    String userName = AppPref().username;
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("lastMessageSendTs", descending: true)
        .where("users", arrayContains: userName)
        .snapshots();
  }

  createChatRoom(String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapShot =
        await FirebaseFirestore.instance.collection("chatrooms").doc(chatRoomId).get();

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

  Future addOthersPresence(Map<String, dynamic> othersCurrentPresenceInfoMap) async {
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
      String chatRoomId, String messageId, Map<String, dynamic> messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSend(String chatRoomId, Map<String, dynamic> lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  delete(messageId){
    return FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
      await myTransaction.delete(messageId);
    });
  }

  deleteMessage(String chatRoomId,messageId) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .delete();
  }

  Future<Stream<QuerySnapshot>> getPresence(email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: email)
        .snapshots();
  }

  updatePresence(String userId, Map<String, dynamic> updatedPresenceInfoMap) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update(updatedPresenceInfoMap);
  }
}
