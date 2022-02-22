import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/custom_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({Key? key}) : super(key: key);
  final ctrl = Get.put(ResetPasswordController());
  final homeCtrl = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.black,
              )),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Reset Password',
                style: TextStyle(fontSize: 25),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Form(
                  key: ctrl.rstKey,
                  child: Column(
                    children: <Widget>[
                      CustomTextField(
                        controller: ctrl.oldPasswordController,
                        hintText: 'Enter current password',
                        labelText: 'Current Password',
                        obscureText: true,
                        border: const OutlineInputBorder(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter valid input";
                          }
                          if (ctrl.oldPasswordController.text != ctrl.oldPsd) {
                            return "Doesn't matches your current password!";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          controller: ctrl.rstPasswordController,
                          hintText: 'Password',
                          labelText: 'Enter a secure password',
                          obscureText: true,
                          border: const OutlineInputBorder(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter valid input";
                            }
                            if (validateRstPassword(value)) {
                              if (ctrl.rstPasswordController.text ==
                                  ctrl.oldPasswordController.text) {
                                return "Can't use previous password again!";
                              } else {
                                return null;
                              }
                            } else {
                              return "Password must contain capital letter, \nsmall letter,\nspecial character, \nnumber and \n8 characters long";
                            }
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: ctrl.rstCfPasswordController,
                        border: const OutlineInputBorder(),
                        labelText: 'Confirm Password',
                        hintText: 'Enter secure password',
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter valid input";
                          }
                          if (value != ctrl.rstPasswordController.text) {
                            return "Password doesn't matches!";
                          }
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ctrl.rstButton(context);
                        },
                        child: const Text("Reset Password"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  bool validateRstPassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
