// ignore_for_file:must_be_immutable, unnecessary_brace_in_string_interps

import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  var ctrl = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ctrl.hideKeyboard(),
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Chats"),
          ),
          drawer: Drawer(
            child: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        DrawerHeader(
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.account_circle,
                                  size: 100,
                                  color: Colors.white,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppPref.instance.username,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      AppPref.instance.email,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                  ],
                                )
                              ],
                            )),
                        ListTile(
                          leading: const Icon(
                            Icons.password,
                            color: Colors.blue,
                          ),
                          title: const Text('Update Password'),
                          onTap: () {
                            Get.to(() => ResetPassword());
                          },
                        ),
                        ListTile(
                            leading: const Icon(
                              Icons.switch_account_rounded,
                              color: Colors.blue,
                            ),
                            title: const Text('Update Profile'),
                            onTap: () {
                              Get.to(() => UpdateProfile());
                            }),
                        ListTile(
                          leading: const Icon(
                            Icons.logout,
                            color: Colors.blue,
                          ),
                          title: const Text('Logout'),
                          onTap: () => ctrl.logoutDialog(context),
                        ),
                        const Spacer(),
                        ListTile(
                          leading: const Icon(
                            Icons.exit_to_app,
                            color: Colors.blue,
                          ),
                          title: const Text('Exit'),
                          onTap: () => ctrl.logoutDialog(context),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          body: GetBuilder<HomeController>(builder: (context) {
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
                            color: Colors.grey,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(24)),
                    child: TextField(
                      controller: ctrl.searchController,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: "Search here"),
                      onChanged: (value) {
                        ctrl.finalUserList(value);
                      },
                    ),
                  ),
                  ListView.builder(
                      itemCount: ctrl.users.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Users _user = ctrl.users[index];
                        return Padding(
                          padding:
                              const EdgeInsets.only(left: 12.0, bottom: 12.0),
                          child: InkWell(
                            onTap: () {
                              ctrl.forChat(_user);
                            },
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'name : ${_user.name}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 3),
                                  Text('username : ${_user.username}')
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
}
