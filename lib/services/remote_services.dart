import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:project1/models/product_model.dart';
import 'package:project1/models/reset_password_model.dart';
import 'package:project1/models/user_model.dart';

//https://fakestoreapi.com/products
//https://api.escuelajs.co/api/v1/products
// 10.0.2.2
// 192.168.1.40

class RemoteServices {
  static const String _hostUrl = "http://10.0.2.2:8000/api";

  static var client = http.Client();

  static Future<List<ProductModel>?> fetchAllProducts() async {
    var response = await http.get(Uri.parse("https://fakestoreapi.com/products"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return productModelFromJson(response.body);
    } else {
      Get.defaultDialog(title: "error", middleText: "network or server error\nerror code: ${response.statusCode}");
      return null;
    }
  }

  static Future<bool> sendCart(Map<int, int> cartMap, String token) async {
    var response = await client.post(
      Uri.parse(""),
      body: jsonEncode(cartMap),
      headers: {'Content-Type': 'application/json', 'Bearer_token': "bearer $token"},
    );
    if (response.statusCode == 200) {
      return true;
      //show a dialog to ask user to delete his cart
    } else {
      return false;
    }
  }

  static Future<String?> createUser(String email, String password, String name) async {
    var response = await client.post(
      Uri.parse("$_hostUrl/register"),
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": password,
      }),
      headers: {'Content-Type': 'application/json', "Accept": 'application/json'},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body)["access_token"];
    } else {
      Get.defaultDialog(title: "error", middleText: jsonDecode(response.body)["message"]);
      return null;
    }
  }

  static Future<String?> sendRegisterOtp(String token) async {
    var response = await http.get(
      Uri.parse("$_hostUrl/email/send-otp-code"),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body)["url"];
    } else {
      Get.defaultDialog(title: "error", middleText: jsonDecode(response.body)["message"]);
      return null;
    }
  }

  static Future<bool> verifyRegisterOtp(String apiUrl, String token, String otp) async {
    var response = await client.post(
      Uri.parse(apiUrl),
      body: jsonEncode({"otp_code": otp}),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      Get.defaultDialog(title: "error", middleText: jsonDecode(response.body)["message"]);
      return false;
    }
  }

  static Future<String?> signUserIn(String email, String password) async {
    var response = await client.post(
      Uri.parse("$_hostUrl/login"),
      body: jsonEncode({"email": email, "password": password}),
      headers: {'Content-Type': 'application/json', "Accept": 'application/json'},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body)["AccessToken"];
    } else {
      Get.defaultDialog(title: "error", middleText: jsonDecode(response.body)["message"]);
      return null;
    }
  }

  static Future<UserModel?> fetchCurrentUser(String token) async {
    var response = await client.get(
      Uri.parse(""),
      headers: {'Content-Type': 'application/json', "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return UserModel.fromJson(jsonDecode(response.body)["data"]);
    } else {
      Get.defaultDialog(title: "error", middleText: jsonDecode(response.body)["error"]);
      return null;
    }
  }

  static Future<bool> signOut(String token) async {
    var response = await http.get(
      Uri.parse("$_hostUrl/logout"),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      Get.defaultDialog(title: "error", middleText: jsonDecode(response.body)["message"]);
      return false;
    }
  }

  static Future<bool> sendForgotPasswordOtp(String email) async {
    var response = await http.get(
      Uri.parse("$_hostUrl/forgot-password/$email"),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        //"Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      Get.defaultDialog(title: "error", middleText: jsonDecode(response.body)["message"]);
      return false;
    }
  }

  static Future<ResetPassModel?> verifyForgotPasswordOtp(String email, String otp) async {
    var response = await client.post(
      Uri.parse("$_hostUrl/forgot-password/check-OTP"),
      body: jsonEncode({"email": email, "code": otp}),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
        //"Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ResetPassModel.fromJson(jsonDecode(response.body));
    } else {
      Get.defaultDialog(title: "error", middleText: jsonDecode(response.body)["message"]);
      return null;
    }
  }

  static Future<bool> resetPassword(String email, String password, String resetToken) async {
    var response = await client.post(
      Uri.parse("$_hostUrl/forgot-password/reset"),
      body: jsonEncode({
        "email": email,
        "password": password,
        "password_confirmation": password,
        "token": resetToken,
      }),
      headers: {
        'Content-Type': 'application/json',
        "Accept": 'application/json',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      Get.defaultDialog(title: "error", middleText: jsonDecode(response.body)["message"]);
      return false;
    }
  }
}
