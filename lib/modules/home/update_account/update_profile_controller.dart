import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';

class UpdateProfileController extends GetxController {
  final GlobalKey<FormState> rstFormStateKey = GlobalKey<FormState>();
  final TextEditingController rstNameController = TextEditingController();
  final TextEditingController rstEmailController = TextEditingController();
  String password = '';

  @override
  void onInit() {
    super.onInit();

    updateControl();
  }

  updateControl() {
    FireStoreMethods.instance.getProfileDetails().then((value) {
      rstNameController.text = value.docs[0]['name'];
      rstEmailController.text = value.docs[0]['email'];
      password = value.docs[0]['password'];
      update();
    });
  }

  rstProfile() {
    var username = rstEmailController.text.replaceAll('@gmail.com', '');
    if (rstFormStateKey.currentState!.validate()) {
      var profileDetails = Users(
          id: AppPref.instance.userId,
          email: rstEmailController.text,
          password: password,
          username: username,
          name: rstNameController.text,
          lastSeen: AppPref.instance.lastSeen,
          isOnline: AppPref.instance.isOnline,
          isTyping: AppPref.instance.isTyping);

      User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        firebaseUser
            .updateEmail(rstEmailController.text)
            .then((value) {})
            .catchError((onError) {});
        FireStoreMethods.instance
            .updateProfile(AppPref.instance.userId, profileDetails.toMap());
        update();
      }

      AppPref.instance.email = rstEmailController.text;
      AppPref.instance.name = rstNameController.text;
      AppPref.instance.username = username;
      Get.offAllNamed(AppRoutes.home);
    }
  }
}
