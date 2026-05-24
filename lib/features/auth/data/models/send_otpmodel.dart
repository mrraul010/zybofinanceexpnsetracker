import 'dart:convert';

SendOtpResponse sendOtpFromJson(String str) =>
    SendOtpResponse.fromJson(json.decode(str));

String sendOtpToJson(SendOtpResponse data) => json.encode(data.toJson());

class SendOtpResponse {
  final String status;
  final String? otp;
  final bool userExists;
  final String? nickname;
  final String? token;

  SendOtpResponse({
    required this.status,
    this.otp,
    required this.userExists,
    this.nickname,
    this.token,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return SendOtpResponse(status: 'error', userExists: false);
    }

    return SendOtpResponse(
      status: json["status"]?.toString() ?? 'unknown',

      otp: json["otp"]?.toString(),

      userExists: json["user_exists"] as bool? ?? false,

      nickname: json["nickname"]?.toString(),
      token: json["token"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "otp": otp,
    "user_exists": userExists,
    "nickname": nickname,
    "token": token,
  };
}
