import 'package:chats_module/model/chat.dart';
import 'package:chats_module/packages/config_packages.dart';

List<Chat> getUserTaskLists(data) {
  return data
      .map((doc) =>
      Chat(
        message: doc['message'] ?? '',
        sendBy: doc['sendBy'] ?? '',
        ts: (doc['ts'] as Timestamp).toDate(),
      ))
      .toList();
}
