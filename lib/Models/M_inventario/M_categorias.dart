
import 'dart:convert';

M_Categorias mCategoriasFromJson(String str) => M_Categorias.fromJson(json.decode(str));

String mCategoriasToJson(M_Categorias data) => json.encode(data.toJson());

class M_Categorias {
  M_Categorias({
    this.id,
    this.mCategoriasId,
    this.name,
    this.description,
    this.img,
    this.createdDate,
    this.v,
    this.products,
  });

  String id;
  String mCategoriasId;
  String name;
  String description;
  String img;
  DateTime createdDate;
  int v;
  var products;

  factory M_Categorias.fromJson(Map<String, dynamic> json) => M_Categorias(
    id: json["_id"],
    mCategoriasId: json["id"],
    name: json["name"],
    description: json["description"],
    img:json["img"]==null?"https://rpautopartes.com/wp-content/uploads/2020/09/bateria-interstate-300x300.jpg":json["img"],
    //createdDate:json["created_date"]!=null?  DateTime.parse(json["created_date"]):"" ,
    v: json["__v"],
    products: json["products"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "id": mCategoriasId,
    "name": name,
    "description": description,
    "img": img,
    "created_date": createdDate.toIso8601String(),
    "__v": v,
    "products": products,
  };
}