import 'dart:convert';

LoginData loginDataFromJson(String str) => LoginData.fromJson(json.decode(str));

String loginDataToJson(LoginData data) => json.encode(data.toJson());

class LoginData {
  LoginData({
    this.ok,
    this.message,
    this.userDb,
    this.token,
  });

  bool ok;
  String message;
  Map<String, dynamic> userDb;
  String token;

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        ok: json["ok"],
        message: json["message"],
        userDb: json["userDB"],
        token: json["token"],
      );

  LoginData.fromJson_base(Map<String, dynamic> json) {
    ok = json["ok"];
    message = json["message"];
    userDb = json["userDB"];
    token = json["token"];
  }

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "message": message,
        "userDB": userDb,
        "token": token,
      };
}
