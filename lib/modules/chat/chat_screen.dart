// ignore_for_file: must_be_immutable
import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  var ctrl = Get.put(ChatScreenController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ctrl.hideKeyboard(),
      child: Scaffold(
        appBar: AppBar(
          title: GetBuilder<ChatScreenController>(builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  ctrl.chatWithUsername,
                  style: const TextStyle(fontSize: 20),
                ),
                checkUserPresence(ctrl.isOnline, ctrl.isTyping,
                    ctrl.lastSeen ?? DateTime.now()),
              ],
            );
          }),
          actions: [
            IconButton(
              onPressed: () => ctrl.onClearAll(),
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: GetBuilder<ChatScreenController>(builder: (context) {
          return Column(
            children: [
              Expanded(
                  child: GroupedListView<Chat, DateTime>(
                      elements: ctrl.chatList,
                      order: GroupedListOrder.DESC,
                      reverse: true,
                      floatingHeader: true,
                      useStickyGroupSeparators: true,
                      groupHeaderBuilder: (Chat element) {
                        return Container(
                          color: Colors.transparent,
                          height: 50,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.blue[300],
                                border: Border.all(
                                  color: Colors.blue[300]!,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  DateFormat.EEEE().format(element.ts),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      groupBy: (Chat element) {
                        return DateTime(
                          element.ts.day,
                          element.ts.weekday,
                          element.ts.month,
                          element.ts.year,
                        );
                      },
                      itemBuilder: (context, Chat chat) {
                        return Padding(
                          padding: ctrl.myUserName == chat.sendBy
                              ? const EdgeInsets.only(left: 150.0, bottom: 8)
                              : const EdgeInsets.only(right: 150, bottom: 8),
                          child: Row(
                            mainAxisAlignment: ctrl.myUserName == chat.sendBy
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onLongPress: () =>
                                      ctrl.myUserName == chat.sendBy
                                          ? ctrl.onMsgLongPress(
                                              chat.messageId) //ADD MESSAGEID
                                          : null,
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                          bottom: 1, left: 7),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(24),
                                          bottomRight:
                                              ctrl.myUserName == chat.sendBy
                                                  ? const Radius.circular(0)
                                                  : const Radius.circular(24),
                                          topRight: const Radius.circular(24),
                                          bottomLeft:
                                              ctrl.myUserName == chat.sendBy
                                                  ? const Radius.circular(24)
                                                  : const Radius.circular(0),
                                        ),
                                        color: ctrl.myUserName == chat.sendBy
                                            ? Colors.blue
                                            : Colors.deepOrangeAccent,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            ctrl.myUserName == chat.sendBy
                                                ? CrossAxisAlignment.end
                                                : CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Flexible(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 2,
                                                          top: 8,
                                                          left: 12,
                                                          right: 12),
                                                  child: Text(
                                                    chat.message,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                    softWrap: true,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 7.0),
                                            child: Text(
                                                ctrl.msgTimeFormat(chat.ts),
                                                textAlign: ctrl.myUserName ==
                                                        chat.sendBy
                                                    ? TextAlign.end
                                                    : TextAlign.start),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            ],
                          ),
                        );
                      })),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.black,
                  child: Column(
                    children: [
                      Obx(
                        () => (ctrl.isDelete.value)
                            ? Container(
                                width: double.infinity,
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Delete this message ? '),
                                    TextButton(
                                        onPressed: () => ctrl.onDeleteMsg(),
                                        child: const Text("Delete"))
                                  ],
                                ),
                              )
                            : Container(),
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: TextField(
                            controller: ctrl.msgController,
                            onTap: () => ctrl.whenTyping(),
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "type a message",
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.6))),
                          )),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () => ctrl.addMessage(true),
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget checkUserPresence(bool isOnline, isTyping, DateTime lastSeen) {
    if (isOnline == true) {
      if (isTyping == true) {
        return Row(children: [
          const Text(
            'typing',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(
            width: 3,
          ),
          JumpingDotsProgressIndicator(
            fontSize: 25,
            color: Colors.white,
          )
        ]);
      } else {
        return const Text("online");
      }
    } else {
      String _lastSeen = ctrl.lastSeenFormat(lastSeen) ?? '';
      if (_lastSeen.isNotEmpty) {
        return Text(_lastSeen);
      }
    }
    return Container();
  }
}
