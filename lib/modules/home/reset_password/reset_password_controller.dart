import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController rstPasswordController = TextEditingController();
  final TextEditingController rstCfPasswordController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final GlobalKey<FormState> rstKey = GlobalKey<FormState>();
  String oldPsd = '';

  @override
  void onInit() {
    FireStoreMethods.instance.getProfileDetails().then((value) {
      oldPsd = value.docs[0]['password'];
    });
    super.onInit();
  }

  rstButton(BuildContext context) {
    if (rstKey.currentState!.validate()) {
      var password = Users(
          id: AppPref.instance.userId,
          email: AppPref.instance.email,
          password: rstPasswordController.text,
          username: AppPref.instance.username,
          name: AppPref.instance.name,
          lastSeen: AppPref.instance.lastSeen,
          isOnline: AppPref.instance.isOnline,
          isTyping: AppPref.instance.isTyping);
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        firebaseUser
            .updatePassword(rstPasswordController.text)
            .then((value) {})
            .catchError((onError) {});
        FireStoreMethods.instance
            .updateProfile(AppPref.instance.userId, password.toMap());
      }

      Get.back();
      debugPrint('Reset');
    }
  }
}
