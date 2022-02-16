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
    update();
    super.onInit();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        isDeviceConnected = false;
        Map<String, dynamic> updatedPresenceInfoMap = {
          'isOnline': isDeviceConnected,
          "lastSeen": DateTime.now(),
        };
        FireStoreMethods()
            .updatePresence(AppPref.instance.userId, updatedPresenceInfoMap);
        print('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        isDeviceConnected = true;
        Map<String, dynamic> updatedPresenceInfoMap = {
          'isOnline': isDeviceConnected,
          "lastSeen": DateTime.now(),
        };

        FireStoreMethods()
            .updatePresence(AppPref.instance.userId, updatedPresenceInfoMap);
        print('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        isDeviceConnected = false;
        Map<String, dynamic> updatedPresenceInfoMap = {
          'isOnline': isDeviceConnected,
        };
        FireStoreMethods()
            .updatePresence(AppPref.instance.userId, updatedPresenceInfoMap);
        print('appLifeCycleState paused');
        break;
      case AppLifecycleState.detached:
        isDeviceConnected = false;
        Map<String, dynamic> updatedPresenceInfoMap = {
          'isOnline': isDeviceConnected,
          "lastSeen": DateTime.now(),
        };
        FireStoreMethods()
            .updatePresence(AppPref.instance.userId, updatedPresenceInfoMap);
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
