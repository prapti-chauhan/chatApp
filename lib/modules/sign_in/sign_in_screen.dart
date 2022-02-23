import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/custom_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';

class SignInScreen extends StatelessWidget {
  final ctrl = Get.put(SignInController());

  SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Login Page",
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: Form(
        key: ctrl.loginKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/img.png', height: 150, width: 200),
                CustomTextField(
                  labelText: 'Email',
                  controller: ctrl.loginEmailController,
                  hintText: 'Enter valid email id as abc@gmail.com',
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
                ),
                const SizedBox(height: 10),
                CustomTextField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter valid input";
                      }
                      return null;
                    },
                    controller: ctrl.loginPasswordController,
                    obscureText: true,
                    labelText: "Password",
                    hintText: "Enter a secure password"),
                const SizedBox(height: 10),
                CustomButton(
                  onPressed: () => ctrl.signIn(context),
                  text: 'Login',
                ),
                const SizedBox(height: 50),
                TextButton(
                  onPressed: () => ctrl.toSignUp(),
                  child: const Text("Don't have an account?" "Sign Up",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
