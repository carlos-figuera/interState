import 'dart:convert';

M_UserDb mUserDbFromJson(String str) => M_UserDb.fromJson(json.decode(str));

String mUserDbToJson(M_UserDb data) => json.encode(data.toJson());

class M_UserDb {
  M_UserDb({
    this.role,
    this.dealer,
    this.id,
    this.mUserDbId,
    this.name,
    this.email,
    this.password,
    this.img,
    this.createdDate,
    this.v,
  });

  String role;
  String dealer;
  String id;
  String mUserDbId;
  String name;
  String email;
  String password;
  String img;
  String createdDate;
  int v;

  factory M_UserDb.fromJson(Map<String, dynamic> json) => M_UserDb(
    role: json["role"],
    dealer:json["dealer"],
    id: json["_id"],
    mUserDbId: json["id"],
    name: json["name"],
    email: json["email"],
    password: json["password"],
    img: json["img"],
    createdDate: json["created_date"],
    v: json["__v"],
  );
  M_UserDb.fromJsonBase(Map<String, dynamic> json) {
    role= json["role"];
    dealer= json["dealer"];
    id= json["_id"];
    mUserDbId= json["id"];
    name= json["name"];
    email= json["email"];
    password= json["password"];
    img= json["img"];
    createdDate= json["created_date"];
    v=json["__v"];
      }
  Map<String, dynamic> toJson() => {
    "role": role,
    "dealer":dealer,
    "_id": id,
    "id": mUserDbId,
    "name": name,
    "email": email,
    "password": password,
    "img": img,
    "created_date": createdDate,
    "__v": v,
  };
}