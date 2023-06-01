import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../components/auth_button.dart';
import '../components/auth_field.dart';
import '../constants.dart';
import '../controllers/forgot_password_controller.dart';

///to enter the email for the account you want to reset its password
class ForgotPasswordPage1 extends StatelessWidget {
  ForgotPasswordPage1({super.key});

  final email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    ForgotPasswordController fC = Get.put(ForgotPasswordController());
    return Scaffold(
      backgroundColor: Get.isDarkMode ? cs.background : Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Hero(
                  tag: "logo",
                  child: Image.asset(
                    kLogoPath,
                    height: MediaQuery.of(context).size.width / 1.7,
                    width: MediaQuery.of(context).size.width / 1.7,
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'rest pass'.tr,
                    style: kTextStyle16.copyWith(color: Get.isDarkMode ? cs.onBackground : Colors.grey[700]),
                  ),
                ),
                const SizedBox(height: 25),
                Form(
                  key: fC.firstFormKey,
                  child: AuthField(
                    textController: email,
                    keyboardType: TextInputType.emailAddress,
                    obscure: false,
                    hintText: "email".tr,
                    label: "email",
                    prefixIconData: Icons.email_outlined,
                    validator: (val) {
                      return validateInput(email.text, 4, 100, "email");
                    },
                    onChanged: (val) {
                      if (fC.button1Pressed) fC.firstFormKey.currentState!.validate();
                    },
                  ),
                ),
                const SizedBox(height: 25),
                //todo: when i press confirm and it times out the otp is sent but i cant go to otp screen
                GetBuilder<ForgotPasswordController>(
                  builder: (con) => AuthButton(
                    widget: con.isLoading1
                        ? SpinKitThreeBounce(color: cs.onPrimary, size: 24)
                        : Text(
                            "confirm".tr,
                            style: kTextStyle16Bold.copyWith(color: cs.onPrimary),
                          ),
                    onTap: () {
                      fC.toggleTimerState(false);
                      fC.toOtp(email.text.trim());
                      hideKeyboard(context);
                    },
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
