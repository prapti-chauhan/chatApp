import 'package:chats_module/packages/config_packages.dart';

class CustomTextField extends StatelessWidget {
  final FormFieldValidator<String>? validator;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? labelText;
  final String hintText;
  final bool? obscureText;
  final InputBorder? enabledBorder;
  final InputBorder? border;

  const CustomTextField(
      {Key? key,
        required this.controller,
        required this.hintText,
        this.validator,
        this.labelText,
        this.obscureText,
        this.enabledBorder,
        this.border,
        this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        ),
      ),
    );
  }
}
