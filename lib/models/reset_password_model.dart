// To parse this JSON data, do
//
//     final resetPassModel = resetPassModelFromJson(jsonString);

import 'dart:convert';

ResetPassModel resetPassModelFromJson(String str) => ResetPassModel.fromJson(json.decode(str));

String resetPassModelToJson(ResetPassModel data) => json.encode(data.toJson());

class ResetPassModel {
  final bool status;
  final String message;
  final String resetToken;

  ResetPassModel({
    required this.status,
    required this.message,
    required this.resetToken,
  });

  factory ResetPassModel.fromJson(Map<String, dynamic> json) => ResetPassModel(
        status: json["status"],
        message: json["message"],
        resetToken: json["reset_token"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "reset_token": resetToken,
      };
}
