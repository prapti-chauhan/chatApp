import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';

class FireStoreMethods {
  static final FireStoreMethods instance = FireStoreMethods._pvtConstructor();

  factory FireStoreMethods() => instance;

  FireStoreMethods._pvtConstructor();

  addUserInfoToDB(String userId, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }

  createChatRoom(String chatRoomId, Map<String, dynamic> chatRoomInfoMap) {
    var snapShot;
    FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get()
        .then((value) {
      snapShot = value;
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
    });
  }

  addOthersPresence(Map<String, dynamic> othersCurrentPresenceInfoMap) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc()
        .set(othersCurrentPresenceInfoMap);
  }

  Stream<QuerySnapshot> getUserByUserName() {
    return FirebaseFirestore.instance
        .collection("users")
        .where('username', isNotEqualTo: AppPref.instance.username)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatRoomMessages(chatRoomId) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  addMessage(
      String chatRoomId, String messageId, Map<String, dynamic> msgInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(msgInfoMap);
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
        .then((value) {})
        .onError((error, stackTrace) {});
  }

  Stream<QuerySnapshot> getPresence(String email) {
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
