// import 'package:flutter/material.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:project1/controllers/edit_profile_controller.dart';
// import 'package:get/get.dart';
// import 'package:project1/models/user_model.dart';
// import 'package:project1/views/login_page.dart';
// import '../components/auth_button.dart';
//
// class EditProfilePage extends StatelessWidget {
//   EditProfilePage({super.key, required this.user});
//   //todo: make a proper address text field
//   final UserModel user;
//   final firstName = TextEditingController();
//   final lastName = TextEditingController();
//   final phone = TextEditingController();
//   final address = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     ColorScheme cs = Theme.of(context).colorScheme;
//     EditProfileController ePC = Get.put(EditProfileController());
//     return Scaffold(
//       backgroundColor: Get.isDarkMode ? cs.background : Colors.grey[300],
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 50),
//                 Text(
//                   'edit account'.tr,
//                   style: TextStyle(
//                     color: Get.isDarkMode ? cs.onBackground : Colors.grey[700],
//                     fontSize: 40,
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 //text field for first name wrapped with Obx to handle errors
//                 Obx(
//                   () => Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                     child: TextField(
//                       controller: firstName,
//                       onChanged: (val) {
//                         if (rC.additionalFlag2.value) {
//                           rC.nameFlag.value = firstName.text.trim().length >= 4;
//                         }
//                       },
//                       style: const TextStyle(color: Colors.black),
//                       decoration: InputDecoration(
//                           enabledBorder: const OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey.shade400),
//                           ),
//                           errorBorder: rC.nameFlag.value
//                               ? null
//                               : const OutlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.red),
//                                 ),
//                           errorText: rC.nameFlag.value ? null : "not valid".tr,
//                           fillColor: Colors.grey.shade200,
//                           filled: true,
//                           hintText: "first name".tr,
//                           hintStyle: TextStyle(color: Colors.grey[500])),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                   child: TextField(
//                     controller: lastName,
//                     style: const TextStyle(color: Colors.black),
//                     decoration: InputDecoration(
//                         enabledBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.white),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.grey.shade400),
//                         ),
//                         fillColor: Colors.grey.shade200,
//                         filled: true,
//                         hintText: "last name (optional)".tr,
//                         hintStyle: TextStyle(color: Colors.grey[500])),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25),
//                   child: IntlPhoneField(
//                     //todo:don't let user create account if number is not valid
//                     //todo: find a way to not let user write weird names
//                     style: const TextStyle(color: Colors.black),
//                     dropdownTextStyle: const TextStyle(color: Colors.black),
//                     decoration: InputDecoration(
//                         enabledBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.white),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.grey.shade400),
//                         ),
//                         fillColor: Colors.grey.shade200,
//                         filled: true,
//                         hintText: "phone".tr,
//                         errorText: "invalid number".tr,
//                         hintStyle: TextStyle(color: Colors.grey[500])),
//                     initialCountryCode: 'SY',
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Obx(
//                   () => Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                     child: TextField(
//                       controller: address,
//                       onChanged: (val) {
//                         rC.addressFlag.value = address.text.trim().isNotEmpty;
//                       },
//                       style: const TextStyle(color: Colors.black),
//                       decoration: InputDecoration(
//                           enabledBorder: const OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey.shade400),
//                           ),
//                           errorBorder: rC.addressFlag.value
//                               ? null
//                               : const OutlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.red),
//                                 ),
//                           errorText: rC.addressFlag.value ? null : "cannot be empty".tr,
//                           fillColor: Colors.grey.shade200,
//                           filled: true,
//                           hintText: "address".tr,
//                           hintStyle: TextStyle(color: Colors.grey[500])),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 25),
//                 //todo: wrap button with obx
//                 AuthButton(
//                   widget: Text(
//                     "create account!".tr,
//                     style: TextStyle(
//                       color: cs.onPrimary,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   onTap: () {
//                     if (firstName.text.trim().length >= 4 && address.text.trim().isNotEmpty) {
//                       rC.setAccountInfo(
//                           firstName.text.trim(), lastName.text.trim(), phone.text.trim(), address.text.trim());
//                       rC.createUser();
//                       //if user is created
//                       Get.offAll(() => LoginPage());
//                       Get.defaultDialog(middleText: "account created successfully, please login".tr);
//                     } else {
//                       if (firstName.text.trim().length < 4) {
//                         rC.nameFlag.value = false;
//                         rC.additionalFlag2.value = true;
//                       }
//                       if (address.text.trim().isEmpty) {
//                         rC.addressFlag.value = false;
//                       }
//                     }
//                   },
//                 ),
//                 const SizedBox(height: 50),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "already have an account?".tr,
//                       style: TextStyle(color: Get.isDarkMode ? cs.onBackground : Colors.grey[700]),
//                     ),
//                     const SizedBox(width: 4),
//                     GestureDetector(
//                       onTap: () {
//                         Get.defaultDialog(
//                           middleText: "are you sure? your progress will be lost".tr,
//                           confirm: GestureDetector(
//                             onTap: () {
//                               Get.offAll(() => LoginPage());
//                             },
//                             child: Text(
//                               "yes".tr,
//                               style: TextStyle(color: cs.error),
//                             ),
//                           ),
//                           cancel: GestureDetector(
//                             onTap: () {
//                               Get.back();
//                             },
//                             child: Text("no".tr),
//                           ),
//                         );
//                       },
//                       child: Text(
//                         'Login now'.tr,
//                         style: const TextStyle(
//                           color: Colors.blue,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
