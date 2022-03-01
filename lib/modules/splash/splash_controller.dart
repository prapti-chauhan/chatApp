// ignore_for_file: avoid_print

import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';

class SplashController extends GetxController with WidgetsBindingObserver {
  Users? users;

  @override
  void onReady() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      checkLogin();
    });
    super.onReady();
  }

  @override
  void onInit() {
    WidgetsBinding.instance?.addObserver(this);
    update();
    users;
    super.onInit();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        isDeviceConnected = false;
        var presence = Users(
            isOnline: isDeviceConnected,
            lastSeen: users!.lastSeen,
            isTyping: users!.isTyping,
            name: users!.name,
            password: users!.password,
            id: users!.id,
            email: users!.email,
            username: users!.username);
        FireStoreMethods()
            .updatePresence(AppPref.instance.userId, presence.toMap());
        print('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        isDeviceConnected = true;
        var presence = Users(
            isOnline: isDeviceConnected,
            lastSeen: DateTime.now(),
            isTyping: users!.isTyping,
            name: users!.name,
            password: users!.password,
            id: users!.id,
            email: users!.email,
            username: users!.username);

        FireStoreMethods()
            .updatePresence(AppPref.instance.userId, presence.toMap());
        print('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        isDeviceConnected = false;
        var presence = Users(
            isOnline: isDeviceConnected,
            lastSeen: users!.lastSeen,
            isTyping: users!.isTyping,
            name: users!.name,
            password: users!.password,
            id: users!.id,
            email: users!.email,
            username: users!.username);
        FireStoreMethods()
            .updatePresence(AppPref.instance.userId, presence.toMap());
        print('appLifeCycleState paused');
        break;
      case AppLifecycleState.detached:
        isDeviceConnected = false;
        var presence = Users(
            isOnline: isDeviceConnected,
            lastSeen: users!.lastSeen,
            isTyping: users!.isTyping,
            name: users!.name,
            password: users!.password,
            id: users!.id,
            email: users!.email,
            username: users!.username);
        FireStoreMethods()
            .updatePresence(AppPref.instance.userId, presence.toMap());
        print('appLifeCycleState detached');
        break;
    }
  }

  checkLogin() {
    if (AppPref().email.isEmpty) {
      AppPref().userId;
      Get.offNamed(AppRoutes.signIn);
    } else {
      Get.offNamed(AppRoutes.home);
    }
  }
}
