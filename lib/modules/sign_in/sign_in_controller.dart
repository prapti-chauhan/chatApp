// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';

class SignInController extends GetxController {
  final TextEditingController loginPasswordController = TextEditingController();
  final TextEditingController loginEmailController = TextEditingController();

  GlobalKey<FormState> loginKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  toSignUp() {
    Get.offAllNamed(AppRoutes.signUp);
  }

  signIn(BuildContext context) async {
    UserCredential? user;

    if (loginKey.currentState!.validate()) {
      try {
        user = await _auth.signInWithEmailAndPassword(
            email: loginEmailController.text,
            password: loginPasswordController.text);
        if (user != null) {
          AppPref.instance.email = loginEmailController.text;
          AppPref.instance.password = loginPasswordController.text;
          AppPref.instance.userId = user.user!.uid;

          FireStoreMethods.instance
              .getPresence(loginEmailController.text)
              .listen((event) {
            AppPref.instance.name = event.docs[0]['name'];
            AppPref.instance.username = event.docs[0]['username'];
            AppPref.instance.isOnline = event.docs[0]['isOnline'];
            AppPref.instance.isTyping = event.docs[0]['isTyping'];
            print("name ${AppPref.instance.name}");
            print("username: ${AppPref.instance.username}");
            update();
          });
          loginEmailController.clear();
          loginPasswordController.clear();
          Get.off(() => HomeScreen());
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
