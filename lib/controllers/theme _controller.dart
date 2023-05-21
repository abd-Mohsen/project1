import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _getStorage = GetStorage();
  bool _switchValue = Get.isDarkMode;
  bool get switchValue => _switchValue;

  void updateTheme(bool value) {
    if (Get.isDarkMode) {
      Get.changeThemeMode(ThemeMode.light);
      _switchValue = false;
      _getStorage.write('is dark', "false");
    } else {
      Get.changeThemeMode(ThemeMode.dark);
      _switchValue = true;
      _getStorage.write('is dark', "true");
    }
    update();
  }

  ThemeMode getThemeMode() {
    //todo: method being called twice at launch and once when changing language
    if (_getStorage.read('is dark') == "true") {
      print("dark");
      _switchValue = true;
      return ThemeMode.dark;
    } else {
      print("light");
      _switchValue = false;
      return ThemeMode.light;
    }
  }
}
