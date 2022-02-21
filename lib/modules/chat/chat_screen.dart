// ignore_for_file: must_be_immutable
import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';

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
                checkUserPresence(
                    ctrl.isOnline, ctrl.isTyping, ctrl.lastSeen ?? DateTime.now()),
              ],
            );
          }),
          actions: [
            PopupMenuButton(
                onSelected: ctrl.onClearAll(),
                itemBuilder: (context) => [
                      const PopupMenuItem(
                        child: Text("Clear all"),
                      ),
                    ])
          ],
        ),
        body: GetBuilder<ChatScreenController>(builder: (context) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    reverse: true,
                    itemCount: ctrl.getMessages.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = ctrl.getMessages[index];
                      return Padding(
                        padding: ctrl.myUserName == ds["sendBy"]
                            ? const EdgeInsets.only(left: 150.0, top: 8)
                            : const EdgeInsets.only(right: 150, top: 8),
                        child: Row(
                          mainAxisAlignment: ctrl.myUserName == ds["sendBy"]
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onLongPress: () => ctrl.myUserName == ds["sendBy"]
                                    ? ctrl.onMsgLongPress(index)
                                    : null,
                                child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(24),
                                        bottomRight: ctrl.myUserName == ds["sendBy"]
                                            ? const Radius.circular(0)
                                            : const Radius.circular(24),
                                        topRight: const Radius.circular(24),
                                        bottomLeft: ctrl.myUserName == ds["sendBy"]
                                            ? const Radius.circular(24)
                                            : const Radius.circular(0),
                                      ),
                                      color: ctrl.myUserName == ds["sendBy"]
                                          ? Colors.blue
                                          : Colors.deepOrangeAccent,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 12.0),
                                                child: Text(
                                                  ds["message"] ?? '',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                  softWrap: true,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(
                                              (ds['ts'] as Timestamp).toDate().toString(),
                                              textAlign: ctrl.myUserName == ds['sendBy']
                                                  ? TextAlign.end
                                                  : TextAlign.start),
                                        ),

                                        /*    ctrl.myUserName == ds["sendBy"]
                                            ? Positioned(
                                            right: 2,
                                            bottom: 0,
                                            child: Text((ds['ts'] as Timestamp)
                                                .toDate()
                                                .toString()))
                                            : Positioned(
                                          left: 2,
                                          bottom: 0,
                                          child: Text((ds['ts'] as Timestamp)
                                              .toDate()
                                              .toString()),
                                        )*/
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                hintStyle:
                                    TextStyle(color: Colors.white.withOpacity(0.6))),
                          )),
                          GestureDetector(
                            onTap: () => ctrl.addMessage(true),
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
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
