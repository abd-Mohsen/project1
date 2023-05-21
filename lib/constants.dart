import 'package:flutter/material.dart';

String kLogoPath = "assets/images/logo.png";
//todo: fix fonts

String get chooseFontFamily {
  //String currentLang = GetStorage().read("lang");
  // if (currentLang == "ar") {
  //   return "KufiArabic";
  // } else if (currentLang == "en") {
  //   return "defaultEnglish";
  // } else {
  return "defaultEnglish";
  // }
}

TextStyle kTextStyle50 = TextStyle(fontSize: 50, fontFamily: chooseFontFamily);
TextStyle kTextStyle30 = TextStyle(fontSize: 30, fontFamily: chooseFontFamily);
TextStyle kTextStyle30Bold = TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: chooseFontFamily);
TextStyle kTextStyle26 = TextStyle(fontSize: 26, fontFamily: chooseFontFamily);
TextStyle kTextStyle26Bold = TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: chooseFontFamily);
TextStyle kTextStyle24 = TextStyle(fontSize: 24, fontFamily: chooseFontFamily);
TextStyle kTextStyle24Bold = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: chooseFontFamily);
TextStyle kTextStyle22 = TextStyle(fontSize: 22, fontFamily: chooseFontFamily);
TextStyle kTextStyle22Bold = TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: chooseFontFamily);
TextStyle kTextStyle20 = TextStyle(fontSize: 20, fontFamily: chooseFontFamily);
TextStyle kTextStyle18 = TextStyle(fontSize: 18, fontFamily: chooseFontFamily);
TextStyle kTextStyle18Bold = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: chooseFontFamily);
TextStyle kTextStyle17 = TextStyle(fontSize: 17, fontFamily: chooseFontFamily);
TextStyle kTextStyle16 = TextStyle(fontSize: 16, fontFamily: chooseFontFamily);
TextStyle kTextStyle16Bold = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: chooseFontFamily);
TextStyle kTextStyle14 = TextStyle(fontSize: 14, fontFamily: chooseFontFamily);
TextStyle kTextStyle14Bold = TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: chooseFontFamily);

Duration kTimeOutDuration = const Duration(seconds: 15);
