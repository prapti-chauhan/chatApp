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
      Map<String, dynamic> resetProfileInfoMap = {
        'name': rstNameController.text,
        'email': rstEmailController.text,
        'username': username
      };
      //pn sani error aave a batavu

      User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        firebaseUser.updateEmail(rstEmailController.text).then((value) {
          print('success');
        }).catchError((onError) {
          print('error -${onError}');
        });
        FireStoreMethods.instance
            .updateProfile(AppPref.instance.userId, resetProfileInfoMap);
        update();
      }


      AppPref.instance.email = rstEmailController.text;
      AppPref.instance.name = rstNameController.text;
      AppPref.instance.username = username;
      Get.offAllNamed(AppRoutes.home);
    }
  }
}
