import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:get/get.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../constants.dart';
import '../controllers/register_controller.dart';

class RegisterOTPScreen extends StatelessWidget {
  const RegisterOTPScreen({super.key});

  //todo: make resend button with loading indicator
  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    RegisterController rC = Get.find();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Get.isDarkMode ? cs.background : Colors.grey[300],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GetBuilder<RegisterController>(
                builder: (con) => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      !con.isTimeUp ? "valid till:".tr : "OTP expired".tr,
                      style: kTextStyle24.copyWith(color: con.isTimeUp ? Colors.red : cs.onBackground),
                    ),
                    const SizedBox(width: 8),
                    Countdown(
                      controller: con.timeController,
                      seconds: 180,
                      build: (_, double time) => Text(
                        time.toString(),
                        style: kTextStyle24.copyWith(color: con.isTimeUp ? Colors.red : cs.onBackground),
                      ),
                      onFinished: () {
                        con.toggleTimerState(true);
                      },
                    ),
                  ],
                ),
              ),
              Hero(
                tag: "logo",
                child: Image.asset(
                  kLogoPath,
                  height: MediaQuery.of(context).size.width / 3.5,
                  width: MediaQuery.of(context).size.width / 3.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  'otp text'.tr,
                  style: kTextStyle20.copyWith(color: Get.isDarkMode ? cs.onBackground : Colors.grey[700]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GetBuilder<RegisterController>(
                  builder: (con) => OTPTextField(
                    controller: con.otpController,
                    otpFieldStyle: OtpFieldStyle(
                      focusBorderColor: cs.primary,
                      backgroundColor: Colors.grey.shade200,
                    ),
                    hasError: con.isTimeUp,
                    outlineBorderRadius: 15,
                    length: 5,
                    width: MediaQuery.of(context).size.width / 1.2,
                    fieldWidth: MediaQuery.of(context).size.width / 8,
                    style: kTextStyle17.copyWith(color: Colors.black),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.box,
                    onCompleted: (pin) {
                      con.verifyOtp(pin);
                    },
                    onChanged: (val) {},
                  ),
                ),
              ),
              GetBuilder<RegisterController>(
                builder: (con) => ElevatedButton(
                    onPressed: () {
                      con.resendOtp();
                    },
                    child: con.isLoadingOtp
                        ? Text(
                            "resend otp".tr,
                            style: kTextStyle20.copyWith(color: cs.onPrimary),
                          )
                        : SpinKitThreeBounce(color: cs.onPrimary, size: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
