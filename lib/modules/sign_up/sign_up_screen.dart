// ignore_for_file: must_be_immutable
import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/custom_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';

class SignUpScreen extends StatelessWidget {
  var ctrl = Get.put(SignUpController());

  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Sign up",
            style: TextStyle(fontSize: 22),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                    key: ctrl.formStateKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        CustomTextField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter valid input";
                            }
                            if (value.trim() == '') {
                              return "Only space is not allowed!!";
                            }
                            return null;
                          },
                          controller: ctrl.nameController,
                          labelText: "Name",
                          hintText: "Enter your name here",
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter valid input";
                            }
                            if (value.isEmail) {
                              return null;
                            } else {
                              return "Enter a valid email address";
                            }
                          },
                          controller: ctrl.emailController,
                          labelText: "Email-id",
                          hintText: "Enter your email-id here",
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter valid input";
                            }
                            if (validatePassword(value)) {
                              return null;
                            } else {
                              return "Password must contain capital letters,"
                                  " \nsmall letters,\nspecial characters, \nnumbers and "
                                  "\n8 characters long";
                            }
                          },
                          controller: ctrl.passwordController,
                          obscureText: false,
                          labelText: "Password",
                          hintText: "Enter a secure password",
                        ),
                        const SizedBox(height: 5),
                      ],
                    )),
                CustomButton(
                  onPressed: () => ctrl.signUp(context)
                  // debugPrint(email);
                  ,
                  text: 'Submit',
                ),
                const SizedBox(height: 35),
                TextButton(
                  onPressed: () => ctrl.toSignIn(),
                  child: const Text(
                    "Already have an account? " "Login",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  bool validatePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
