import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project1/constants.dart';
import '../services/remote_services.dart';
import 'package:flutter/material.dart';
import '../views/home_page.dart';

class LoginController extends GetxController {
  final _getStorage = GetStorage(); //local storage instance

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  bool buttonPressed = false;

  void toggleLoading(bool value) {
    _isLoading = value;
    update();
  }

  void login(String email, String password) async {
    buttonPressed = true;
    bool isValid = loginFormKey.currentState!.validate();
    if (isValid) {
      toggleLoading(true);
      try {
        _getStorage.write("token", await RemoteServices.signUserIn(email, password).timeout(kTimeOutDuration));
        Get.offAll(() => const HomePage());
      } on TimeoutException {
        Get.defaultDialog(
            title: "error".tr,
            middleText: "operation is taking so long, please check your internet "
                "connection or try again later.");
      } catch (e) {
        //print(e.toString());
      } finally {
        toggleLoading(false);
      }
    }
  }
  //"eve.holt@reqres.in"
}
