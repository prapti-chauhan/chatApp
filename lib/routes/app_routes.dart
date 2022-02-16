import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';


class AppRoutes{
  static const splash = '/splash';
  static const signIn = '/signIn';
  static const signUp = '/signUp';
  static const home = '/home';
  static const chat = '/chat';


  static List<GetPage> getPages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: signIn, page: () =>  SignInScreen()),
    GetPage(name: signUp, page: () =>  SignUpScreen()),
    GetPage(name: home, page: () =>  HomeScreen()),
    GetPage(name: chat, page: () =>  ChatScreen()),

  ];


}