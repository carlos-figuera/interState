import 'dart:convert';
M_orden mOrdenFromJson(String str) => M_orden.fromJson(json.decode(str));
String mOrdenToJson(M_orden data) => json.encode(data.toJson());
class M_orden {
  M_orden({
    this.id,
    this.mOrdenId,
    this.type,
    this.n_order,
    this.createdDate,
    this.v,
    this.products,
  });


  String id;
  String mOrdenId;
  String type;
  int n_order;
  DateTime createdDate;
  int v;
  var products;

  factory M_orden.fromJson(Map<String, dynamic> json) => M_orden(
    id: json["_id"],
    mOrdenId: json["id"],
    type: json["type"],
    n_order: json["n_order"],
    createdDate: DateTime.parse(json["created_date"]),
    v: json["__v"],
    products: json["products"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "id": mOrdenId,
    "type": type,
    "n_order": n_order,
    "created_date": createdDate.toIso8601String(),
    "__v": v,
    "products": products,
  };
}