import 'package:chats_module/packages/config_packages.dart';

class AppPref {
  final store = GetStorage();

  static final AppPref instance = AppPref._internal();

  factory AppPref() => instance;

  AppPref._internal();

  set email(String value) => store.write('email', value);

  String get email => store.read('email') ?? '';

  set username(String value) => store.write('username', value);

  String get username => store.read('username') ?? '';

  set name(String value) => store.write('name', value);

  String get name => store.read('name') ?? '';

  String get userId => store.read('userId') ?? '';

  set userId(String value) => store.write('userId', value);

  logout() {
    store.remove(email);
  }
}
