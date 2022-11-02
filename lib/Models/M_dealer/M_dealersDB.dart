import 'dart:convert';
DealerDb dealerDbFromJson(String str) => DealerDb.fromJson(json.decode(str));
String dealerDbToJson(DealerDb data) => json.encode(data.toJson());

class DealerDb {
  DealerDb({
    this.categories,
    this.orders,
    this.specialOrders,
    this.id,
    this.dealerId,
    this.name,
    this.address,
    this.city,
    this.img,
    this.user,
    this.route,
    this.inventory,
  });

  var categories;
  var orders;
  var specialOrders;
  String id;
  int dealerId;
  String name;
  String address;
  String city;
  String img;
  String user;
  var route;
  String inventory;

  factory DealerDb.fromJson(Map<String, dynamic> json) => DealerDb(
    categories: json["categories"],
    orders: json["orders"],
    specialOrders: json["special_orders"],
    id: json["_id"],
    dealerId: json["dealer_id"],
    name: json["name"],
    address: json["address"],
    city: json["city"],
    img: json["img"],
    user: json["user"],
    route: json["route"],
    inventory: json["inventory"],
  );

  DealerDb.fromJsonBase(Map<String, dynamic> json) {
    categories= json["categories"];
    orders=  json["orders"];
    specialOrders=  json["special_orders"];
    id=  json["_id"];
    dealerId=  json["dealer_id"];
    name=  json["name"];
    address=  json["address"];
    city=  json["city"];
    img=  json["img"];
    user=  json["user"];
    route=  json["route"];
    inventory=  json["inventory"];
  }

  Map<String, dynamic> toJson() => {
    "categories": categories,
    "orders": orders,
    "special_orders": specialOrders,
    "_id": id,
    "dealer_id": dealerId,
    "name": name,
    "address": address,
    "city": city,
    "img": img,
    "user": user,
    "route": route,
    "inventory": inventory,
  };
}
