import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:project1/controllers/edit_profile_controller.dart';
import 'package:get/get.dart';
import 'package:project1/models/user_model.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key, required this.user});
  //todo: make a proper address text field
  final UserModel user;
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    EditProfileController ePC = Get.put(EditProfileController());
    return Scaffold(
      backgroundColor: cs.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          ),
        ),
      ),
    );
  }
}
