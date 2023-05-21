import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../components/auth_button.dart';
import '../components/auth_field.dart';
import '../constants.dart';
import '../controllers/forgot_password_controller.dart';

//todo: recheck if field errors are working properly

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
                  AuthField(
                    textController: newPassword,
                    keyboardType: TextInputType.text,
                    obscure: true, //todo: make a button to show password
                    hintText: "enter a new password".tr,
                    label: "password",
                    iconData: Icons.lock_outline,
                    validator: (val) {
                      return validateInput(newPassword.text, 4, 50, "password");
                    },
                    onChanged: (val) {
                      if (fC.button2Pressed) fC.secondFormKey.currentState!.validate();
                    },
                  ),
                  const SizedBox(height: 10),
                  AuthField(
                    textController: rePassword,
                    keyboardType: TextInputType.text,
                    obscure: true, //todo: make a button to show password
                    hintText: "re enter new password".tr,
                    label: "password",
                    iconData: Icons.lock_outline,
                    validator: (val) {
                      return validateInput(rePassword.text, 4, 50, "password");
                    },
                    onChanged: (val) {
                      if (fC.button2Pressed) fC.secondFormKey.currentState!.validate();
                    },
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
