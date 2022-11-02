import 'dart:convert';

M_InventoryDb inventoryDbFromJson(String str) => M_InventoryDb.fromJson(json.decode(str));

String inventoryDbToJson(M_InventoryDb data) => json.encode(data.toJson());

class M_InventoryDb {
  M_InventoryDb({
    this.products,
    this.id,
    this.inventoryDbId,
    this.dealer,
  });

  var products;
  String id;
  String inventoryDbId;
  var dealer;

  factory M_InventoryDb.fromJson(Map<String, dynamic> json) => M_InventoryDb(
    products: json["products"],
    id: json["_id"],
    inventoryDbId: json["id"],
    dealer: json["dealer"],
  );


  M_InventoryDb.fromJsonBase(Map<String, dynamic> json) {
    products= json["products"];
    id= json["_id"];
    inventoryDbId= json["id"];
    dealer= json["dealer"];
  }
  Map<String, dynamic> toJson() => {
    "products": products,
    "_id": id,
    "id": inventoryDbId,
    "dealer": dealer,
  };
}
