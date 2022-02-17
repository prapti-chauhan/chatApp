import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  var ctrl = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        ctrl.searchController.clear();
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Home"),
            actions: [
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Logout'),
                          content: const Text("Are you sure to logout?"),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text(
                                "Yes",
                                style: TextStyle(color: Colors.white),
                              ),
                              style:
                                  ElevatedButton.styleFrom(primary: Colors.greenAccent),
                              onPressed: () {
                                AppPref().logout();
                                Get.offNamed(AppRoutes.signIn);
                              },
                            ),
                            ElevatedButton(
                                child: const Text(
                                  "No",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style:
                                    ElevatedButton.styleFrom(primary: Colors.redAccent),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        );
                      });
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Icon(Icons.exit_to_app)),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: GetBuilder<HomeController>(builder: (context) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey, width: 1, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(24)),
                      child: search(ctrl.searchController.text),
                    ),
                  ),
                  ListView.builder(
                      itemCount: ctrl.searchedUsers.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        DocumentSnapshot _user = ctrl.searchedUsers[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 12.0, bottom: 12.0),
                          child: InkWell(
                            onTap: () {
                              ctrl.forChat(_user["username"], _user["email"]);
                            },
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _user["name"],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(_user["username"])
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                ],
              ),
            );
          })),
    );
  }

  Widget search(String controller) {
    if (controller.isNotEmpty) {
      return Row(
        children: [
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.clear)),
          Expanded(
            child: TextField(
              controller: ctrl.searchController,
              decoration:
                  const InputDecoration(border: InputBorder.none, hintText: "Search"),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller: ctrl.searchController,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "//Search (still in progress)"),
            ),
          ),
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.search))
        ],
      );
    }
  }
/*
  Widget searchUsersList() {
    return StreamBuilder(
      stream: ctrl.usersStream,
      builder: (context, snapshot) {
        QuerySnapshot<Map<String, dynamic>> data =
            snapshot.data as QuerySnapshot<Map<String, dynamic>>;
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: data.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = data.docs[index];
              return searchListUserTile(
                  name: ds["name"], email: ds["email"], username: ds["username"]);
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget searchListUserTile({required String name, username, email}) {
    return GestureDetector(
        onTap: () {
          var chatRoomId = ctrl.getChatRoomIdByUsernames(ctrl.myUserName, username);
          Map<String, dynamic> chatRoomInfoMap = {
            "users": [ctrl.myUserName, username]
          };
          FireStoreMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
          Get.toNamed(AppRoutes.chat, arguments: {
            'myUserName': ctrl.myUserName,
            "otherUser": username,
            "email": email,
          });
        },
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Row(children: [
              const SizedBox(width: 12),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(username), Text(email)])
            ])));
  }*/
}
