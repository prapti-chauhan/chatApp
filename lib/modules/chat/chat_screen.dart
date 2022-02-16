// ignore_for_file: avoid_print, must_be_immutable
import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  var ctrl = Get.put(ChatScreenController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Map<String, dynamic> presenceInfoMap = {
          "isTyping": false,
        };
        FocusManager.instance.primaryFocus?.unfocus();
        FireStoreMethods().updatePresence(AppPref().userId, presenceInfoMap);
      },
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
        ),
        body: GetBuilder<ChatScreenController>(builder: (context) {
          return Stack(
            children: [
              ListView.builder(
                  padding: const EdgeInsets.only(bottom: 70, top: 16),
                  itemCount: ctrl.getMessages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = ctrl.getMessages[index];
                    return Row(
                      mainAxisAlignment: ctrl.myUserName == ds["sendBy"]
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                ds["message"],
                                style: const TextStyle(color: Colors.white),
                              )),
                        ),
                      ],
                    );
                  }),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: ctrl.msgController,
                        onTap: () {
                          Map<String, dynamic> othersUpdatedPresenceInfoMap = {
                            "isTyping": true,
                          };
                          print('update$othersUpdatedPresenceInfoMap');
                          FireStoreMethods().updatePresence(
                              AppPref().userId, othersUpdatedPresenceInfoMap);
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "type a message",
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.6))),
                      )),
                      GestureDetector(
                        onTap: () {
                          ctrl.addMessage(true);
                        },
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      )
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
