// To parse this JSON data, do
//
//     final morderDb = morderDbFromJson(jsonString);

import 'dart:convert';

M_orderDb morderDbFromJson(String str) => M_orderDb.fromJson(json.decode(str));

String morderDbToJson(M_orderDb data) => json.encode(data.toJson());

class M_orderDb {
  M_orderDb({
    this.id,
    this.morderDbId,
    this.dealer,
    this.createdDate,
    this.type,
    this.nOrder,
    this.products,
    this.v,
  });

  String id;
  String morderDbId;
  String dealer;
  String createdDate;
  String type;
  int nOrder;
  var products;
  int v;

  factory M_orderDb.fromJson(Map<String, dynamic> json) => M_orderDb(
    id: json["_id"],
    morderDbId: json["id"],
    dealer: json["dealer"],
    createdDate: json["created_date"],
    type: json["type"],
    nOrder: json["n_order"],
    products: json["products"],
    v: json["__v"],
  );

  M_orderDb.fromJsonBase(Map<String, dynamic> json) {
    id= json["_id"];
    morderDbId= json["id"];
    dealer=json["dealer"];
    createdDate= json["created_date"];
    type= json["type"];
    nOrder= json["n_order"];
    products= json["products"];
    v= json["__v"];
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "id": morderDbId,
    "dealer": dealer,
    "created_date": createdDate,
    "type": type,
    "n_order": nOrder,
    "products": products,
    "__v": v,
  };
}
