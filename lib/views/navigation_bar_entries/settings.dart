import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project1/components/auth_button.dart';
import 'package:project1/controllers/home_controller.dart';
import 'package:project1/views/login_page.dart';
import 'package:project1/views/orders_page.dart';
import '../../components/auth_field.dart';
import '../../constants.dart';
import '../../controllers/locale_controller.dart';
import '../../controllers/theme _controller.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    LocaleController lC = LocaleController();
    HomeController hC = Get.find();
    final password = TextEditingController();
    final bool isLoggedIn = GetStorage().hasData("token");

    return ListView(
      children: [
        const SizedBox(height: 15),
        isLoggedIn
            ? GetBuilder<HomeController>(
                builder: (con) {
                  if (con.isLoadingUser) {
                    return Center(
                      child: ListTile(
                        tileColor: cs.surface,
                        title: Text(
                          "loading".tr,
                          style: kTextStyle20.copyWith(color: cs.onSurface),
                        ),
                        trailing: CircularProgressIndicator(color: cs.onSurface),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: ExpansionTile(
                        leading: Icon(
                          Icons.account_box,
                          color: cs.onSurface,
                          size: 30,
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text("${con.currentUser.firstName} ${con.currentUser.lastName}",
                              style: kTextStyle30.copyWith(color: cs.onSurface)),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Account details".tr,
                            style: kTextStyle16,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        collapsedShape: RoundedRectangleBorder(
                          side: const BorderSide(width: 0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: cs.surface,
                        collapsedBackgroundColor: cs.surface,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: Icon(
                                    Icons.mail,
                                    color: cs.onBackground,
                                  ),
                                  title: Text("email".tr),
                                  subtitle: Text(
                                    con.currentUser.email,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.phone_android,
                                    color: cs.onBackground,
                                  ),
                                  title: Text("phone".tr),
                                  subtitle: const Text(
                                    "0969696969",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.location_pin,
                                    color: cs.onBackground,
                                  ),
                                  title: Text("address".tr),
                                  subtitle: const Text(
                                    "Syria, Damascus",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        //todo: go to edit profile page after showing a dialog to type password
                                        Get.dialog(
                                          AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            title: Text("please enter your password first:".tr),
                                            content: Form(
                                              key: con.settingsFormKey,
                                              child: GetBuilder<HomeController>(
                                                builder: (con) => AuthField(
                                                  textController: password,
                                                  keyboardType: TextInputType.text,
                                                  obscure: !con.passwordVisible,
                                                  hintText: "password".tr,
                                                  label: "password",
                                                  prefixIconData: Icons.lock_outline,
                                                  suffixIconData: con.passwordVisible
                                                      ? CupertinoIcons.eye_slash
                                                      : CupertinoIcons.eye,
                                                  onIconPress: () {
                                                    con.togglePasswordVisibility(!con.passwordVisible);
                                                  },
                                                  validator: (val) {
                                                    return validateInput(password.text, 4, 50, "password");
                                                  },
                                                  onChanged: (val) {
                                                    if (con.buttonPressed) con.settingsFormKey.currentState!.validate();
                                                  },
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 16.0),
                                                child: GetBuilder<HomeController>(
                                                  builder: (con) => AuthButton(
                                                    onTap: () {
                                                      hideKeyboard(context);
                                                      con.confirmPassword(password.text);
                                                    },
                                                    widget: con.isLoadingConfirmPassword
                                                        ? SpinKitThreeBounce(color: cs.onPrimary, size: 24)
                                                        : Text(
                                                            "submit".tr,
                                                            style: kTextStyle16Bold.copyWith(color: cs.onPrimary),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "edit".tr,
                                        style: kTextStyle18.copyWith(color: cs.onPrimary),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: ListTile(
                    onTap: () {
                      Get.offAll(() => LoginPage());
                    },
                    tileColor: cs.surface,
                    leading: Icon(Icons.login, color: cs.primary, size: 30),
                    title: Text(
                      "login".tr,
                      style: kTextStyle24.copyWith(color: cs.onSurface),
                    ),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
        const SizedBox(height: 10),
        isLoggedIn
            ? ListTile(
                onTap: () {
                  Get.to(() => const OrdersPage());
                },
                leading: Icon(Icons.checklist, color: cs.onBackground),
                title: Text(
                  "my orders".tr,
                  style: kTextStyle20.copyWith(color: cs.onBackground),
                ),
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 10),
        ListTile(
          title: Text(
            "dark theme".tr,
            style: kTextStyle20.copyWith(color: cs.onBackground),
          ),
          leading: Icon(
            Icons.dark_mode_outlined,
            color: cs.onBackground,
          ),
          trailing: GetBuilder<ThemeController>(
            init: ThemeController(),
            builder: (con) => Switch(
              value: con.switchValue,
              onChanged: (bool value) {
                con.updateTheme(value);
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        ListTile(
          leading: Icon(
            Icons.language,
            color: cs.onBackground,
          ),
          title: DropdownButton(
            elevation: 50,
            iconEnabledColor: cs.onBackground,
            dropdownColor: Get.isDarkMode ? cs.surface : Colors.grey.shade200,
            hint: Text(
              lC.getCurrentLanguageLabel(),
              style: kTextStyle20.copyWith(color: cs.onBackground),
            ),
            //button label is updating cuz whole app is rebuilt after changing locale
            items: [
              DropdownMenuItem(
                value: "ar",
                child: Text("Arabic ".tr),
              ),
              DropdownMenuItem(
                value: "en",
                child: Text("English ".tr),
              ),
            ],
            onChanged: (val) {
              lC.updateLocale(val!);
            },
          ),
        ),
        const SizedBox(height: 10),
        ListTile(
          leading: Icon(Icons.privacy_tip_outlined, color: cs.onBackground),
          title: Text(
            "privacy policy".tr,
            style: kTextStyle20.copyWith(color: cs.onBackground),
          ),
        ),
        const SizedBox(height: 10),
        ListTile(
          leading: Icon(Icons.phone, color: cs.onBackground),
          title: Text(
            "contact us".tr,
            style: kTextStyle20.copyWith(color: cs.onBackground),
          ),
        ),
        const SizedBox(height: 10),
        ListTile(
          leading: Icon(Icons.info_outlined, color: cs.onBackground),
          title: Text(
            "about".tr,
            style: kTextStyle20.copyWith(color: cs.onBackground),
          ),
        ),
        const SizedBox(height: 10),
        isLoggedIn
            ? ListTile(
                leading: Icon(Icons.logout, color: cs.error),
                title: Text(
                  "log out".tr,
                  style: kTextStyle20.copyWith(color: cs.error),
                ),
                onTap: () {
                  //delete token and end session
                  //clear cart
                  hC.logOut();
                },
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
