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
      Map<String, dynamic> resetPasswordInfoMap = {
        'password': rstPasswordController.text
      };
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        firebaseUser.updatePassword(rstPasswordController.text).then((value) {
          print('success');
        }).catchError((onError) {
          print('error');
        });
        FireStoreMethods.instance
            .updateProfile(AppPref.instance.userId, resetPasswordInfoMap);
      }

      Get.back();
      debugPrint('Reset');
    }
  }
}
