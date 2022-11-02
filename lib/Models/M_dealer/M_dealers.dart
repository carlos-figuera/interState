import 'dart:convert';
M_Dealer mDealerFromJson(String str) => M_Dealer.fromJson(json.decode(str));
String mDealerToJson(M_Dealer data) => json.encode(data.toJson());

class M_Dealer {
  M_Dealer({
    this.ok,
    this.message,
    this.dealerDb,
    this.token
  });

  bool ok;
  String message;
  var dealerDb;
  String token;

  factory M_Dealer.fromJson(Map<String, dynamic> json) => M_Dealer(
    ok: json["ok"],
    message: json["message"],
    dealerDb: json["dealerDB"],
    token: json["token"]
  );
  M_Dealer.fromJsonBase(Map<String, dynamic> json) {
    ok= json["ok"];
    message= json["message"];
    dealerDb= json["dealerDB"];
    token= json["token"];
  }

  Map<String, dynamic> toJson() => {
    "ok": ok,
    "message": message,
    "dealerDB": dealerDb,
  };
}
