import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';

class UpdateProfileController extends GetxController {
  final GlobalKey<FormState> rstFormStateKey = GlobalKey<FormState>();
  final TextEditingController rstNameController = TextEditingController();
  final TextEditingController rstEmailController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    updateControl();
  }

  updateControl() {
    FireStoreMethods.instance.getProfileDetails().then((value) {
      rstNameController.text = value.docs[0]['name'];
      rstEmailController.text = value.docs[0]['email'];
    });
  }

  rstProfile() {
    if (rstFormStateKey.currentState!.validate()) {
      Map<String, dynamic> resetProfileInfoMap = {
        'name': rstNameController,
        'email': rstEmailController
      };

      FireStoreMethods.instance
          .updateProfile(AppPref.instance.userId, resetProfileInfoMap);
      /*   DB().dao.updateAccount(rstNameController.text, rstLnameController.text,
          rstEmailController.text, homeCtrl.userData!.email);
      AppPref().email = rstEmailController.text;
      print(AppPref().email);
      DB().dao.retrieveEmail(AppPref().email).listen((event) {
        homeCtrl.userData = event;
        update();
      });*/
      Get.off(HomeScreen());
    }
  }
}
