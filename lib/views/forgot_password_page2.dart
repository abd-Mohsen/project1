import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../components/auth_button.dart';
import '../components/auth_field.dart';
import '../constants.dart';
import '../controllers/forgot_password_controller.dart';

//todo: recheck if field validators are working properly

///if otp is correct , set a new password for the account with the email entered earlier
class ForgotPasswordPage2 extends StatelessWidget {
  ForgotPasswordPage2({super.key});

  final newPassword = TextEditingController();
  final rePassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    ForgotPasswordController fC = Get.find();
    return Scaffold(
      backgroundColor: Get.isDarkMode ? cs.background : Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: fC.secondFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Hero(
                    tag: "logo",
                    child: Image.asset(
                      kLogoPath,
                      height: MediaQuery.of(context).size.width / 1.8,
                      width: MediaQuery.of(context).size.width / 1.8,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'rest pass2'.tr,
                    style: kTextStyle16.copyWith(color: Get.isDarkMode ? cs.onBackground : Colors.grey[700]),
                  ),
                  const SizedBox(height: 25),
                  GetBuilder<ForgotPasswordController>(
                    builder: (con) => AuthField(
                      textController: newPassword,
                      keyboardType: TextInputType.text,
                      obscure: !con.passwordVisible,
                      hintText: "enter a new password".tr,
                      label: "password",
                      prefixIconData: Icons.lock_outline,
                      suffixIconData: con.passwordVisible ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                      onIconPress: () {
                        con.togglePasswordVisibility(!con.passwordVisible);
                      },
                      validator: (val) {
                        return validateInput(newPassword.text, 4, 50, "password");
                      },
                      onChanged: (val) {
                        if (con.button2Pressed) con.secondFormKey.currentState!.validate();
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  GetBuilder<ForgotPasswordController>(
                    builder: (con) => AuthField(
                      textController: rePassword,
                      keyboardType: TextInputType.text,
                      obscure: !con.rePasswordVisible,
                      hintText: "re enter password".tr,
                      label: "",
                      prefixIconData: Icons.lock_outline,
                      suffixIconData: con.rePasswordVisible ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                      onIconPress: () {
                        con.toggleRePasswordVisibility(!con.rePasswordVisible);
                      },
                      validator: (val) {
                        return validateInput(rePassword.text, 4, 50, "password");
                      },
                      onChanged: (val) {
                        if (con.button2Pressed) con.secondFormKey.currentState!.validate();
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  GetBuilder<ForgotPasswordController>(
                    builder: (con) => AuthButton(
                      widget: fC.isLoading2
                          ? SpinKitThreeBounce(color: cs.onPrimary, size: 24)
                          : Text(
                              "reset password".tr,
                              style: kTextStyle16Bold.copyWith(color: cs.onPrimary),
                            ),
                      onTap: () {
                        if (newPassword.text == rePassword.text) {
                          fC.resetPass(newPassword.text);
                          hideKeyboard(context);
                        } else {
                          Get.defaultDialog(middleText: "not matched");
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
