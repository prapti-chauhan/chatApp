// ignore_for_file: avoid_print

import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';

class SplashController extends GetxController with WidgetsBindingObserver {
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

    // print(AppPref.instance.name);
    // print(AppPref.instance.isOnline);
    // print(AppPref.instance.userId);
    // print(AppPref.instance.isTyping);
    // print(AppPref.instance.lastSeen);
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
            lastSeen: AppPref.instance.lastSeen,
            isTyping: AppPref.instance.isTyping,
            name: AppPref.instance.name,
            password: AppPref.instance.password,
            id: AppPref.instance.userId,
            email: AppPref.instance.email,
            username: AppPref.instance.username);
        FireStoreMethods()
            .updatePresence(AppPref.instance.userId, presence.toMap());
        print('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        isDeviceConnected = true;
        var presence = Users(
            isOnline: isDeviceConnected,
            lastSeen: DateTime.now(),
            isTyping: AppPref.instance.isTyping,
            name: AppPref.instance.name,
            password: AppPref.instance.password,
            id: AppPref.instance.userId,
            email: AppPref.instance.email,
            username: AppPref.instance.username);

        FireStoreMethods()
            .updatePresence(AppPref.instance.userId, presence.toMap());
        print('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        isDeviceConnected = false;
        var presence = Users(
            isOnline: isDeviceConnected,
            lastSeen: AppPref.instance.lastSeen,
            isTyping: AppPref.instance.isTyping,
            name: AppPref.instance.name,
            password: AppPref.instance.password,
            id: AppPref.instance.userId,
            email: AppPref.instance.email,
            username: AppPref.instance.username);
        FireStoreMethods()
            .updatePresence(AppPref.instance.userId, presence.toMap());
        print('appLifeCycleState paused');
        break;
      case AppLifecycleState.detached:
        isDeviceConnected = false;
        var presence = Users(
            isOnline: isDeviceConnected,
            lastSeen: AppPref.instance.lastSeen,
            isTyping: AppPref.instance.isTyping,
            name: AppPref.instance.name,
            password: AppPref.instance.password,
            id: AppPref.instance.userId,
            email: AppPref.instance.email,
            username: AppPref.instance.username);
        FireStoreMethods()
            .updatePresence(AppPref.instance.userId, presence.toMap());
        print('appLifeCycleState detached');
        break;
    }
    update();
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
