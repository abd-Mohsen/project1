import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project1/constants.dart';

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.textController,
    required this.keyboardType,
    required this.hintText,
    this.prefixIconData,
    this.suffixIconData,
    this.onIconPress,
    required this.validator,
    required this.label,
    required this.onChanged,
    required this.obscure,
  });

  final TextEditingController textController;
  final TextInputType keyboardType;
  final String hintText;
  final String label;
  final IconData? prefixIconData;
  final IconData? suffixIconData;
  final void Function()? onIconPress;
  final bool obscure;
  final String? Function(String?) validator;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: textController,
        validator: validator,
        keyboardType: keyboardType,
        style: kTextStyle14.copyWith(color: Colors.black),
        onChanged: onChanged,
        obscureText: obscure,
        decoration: InputDecoration(
          //floatingLabelBehavior: FloatingLabelBehavior.always,
          //label: Text(label),
          prefixIcon: Icon(prefixIconData, color: Colors.grey[500]),
          suffixIcon: GestureDetector(
            onTap: onIconPress,
            child: Icon(suffixIconData, color: cs.primary),
          ),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: kTextStyle14.copyWith(color: Colors.grey[500]),
        ),
      ),
    );
  }
}

String? validateInput(String val, int min, int max, String type) {
  //todo: localize
  if (val.trim().isEmpty) return "cant be empty";

  if (type == "username") {
    if (!GetUtils.isUsername(val)) return "not a valid user name";
  }
  if (type == "email") {
    if (!GetUtils.isEmail(val)) return "not a valid email";
  }
  if (type == "phone") {
    if (!GetUtils.isPhoneNumber(val)) return "not a valid phone";
  }
  if (val.length < min) return "value cant be smaller than $min";

  if (val.length > max) return "value cant be greater than $max";

  return null;
}
