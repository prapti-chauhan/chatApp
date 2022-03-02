import 'package:chats_module/packages/config_packages.dart';
import 'package:chats_module/packages/screen_packages.dart';

class SignUpController extends GetxController {
  GlobalKey<FormState> formStateKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  var obscureText = false;

  toSignIn() {
    Get.offAllNamed(AppRoutes.signIn);
  }

  signUp(BuildContext context) async {
    final form = formStateKey.currentState!;
    UserCredential? user;
    var username = emailController.text.replaceAll('@gmail.com', '');

    if (form.validate()) {
      try {
        user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text));

        AppPref.instance.email = user.user!.email!;
        AppPref.instance.userId = user.user!.uid;
        AppPref.instance.username = username;
        AppPref.instance.name = nameController.text;
        AppPref.instance.password = passwordController.text;
        AppPref.instance.lastSeen = DateTime.now();
        AppPref.instance.isOnline = isDeviceConnected;
        AppPref.instance.isTyping = false;

        var userDetails = Users(
            id: user.user!.uid,
            email: emailController.text,
            username: username,
            name: nameController.text,
            password: passwordController.text,
            isOnline: isDeviceConnected,
            lastSeen: DateTime.now(),
            isTyping: false);

        FireStoreMethods()
            .addUserInfoToDB(user.user!.uid, userDetails.toMap())
            .then((value) => Get.offNamed(AppRoutes.home));
        print(userDetails.toMap());

        passwordController.clear();
        emailController.clear();
        nameController.clear();

        update();
      } catch (signUpError) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('ERROR!'),
                content: const Text("Email already exist!!"),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Ok"),
                  )
                ],
              );
            });
        emailController.clear();
        passwordController.clear();
      }
    }
  }
}
