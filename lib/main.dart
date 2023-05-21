import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project1/controllers/locale_controller.dart';
import 'package:project1/themes.dart';
import 'package:project1/views/welcome_screen.dart';
import 'locale.dart';
import 'controllers/theme _controller.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

///some self notes
//todo: fix display and text factor
//todo: responsive design
//todo: optimize routes and controllers
//todo: localize all text
//todo: change status bar color
//todo: change fonts for both ar and en
//todo: fix stutter when changing themes

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    ThemeController t = Get.put(ThemeController()); //to get the initial theme
    LocaleController l = LocaleController(); //to get the initial language
    return GetMaterialApp(
      translations: MyLocale(),
      locale: l.initialLang,
      title: 'Flutter Demo',
      home: const WelcomeScreen(),
      theme: MyThemes.myLightMode, //custom light theme
      darkTheme: MyThemes.myDarkMode, //custom dark theme
      themeMode: t.getThemeMode(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          ///to make text factor 1 for all text widgets (user cant fuck it up from phone settings)
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1, devicePixelRatio: 1),
          child: child!,
        );
      },
    );
  }
}
