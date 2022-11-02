
import 'dart:convert';

M_producto mproductoFromJson(String str) => M_producto.fromJson(json.decode(str));

String mproductoToJson(M_producto data) => json.encode(data.toJson());

class M_producto {
  M_producto({
    this.id,
    this.name,
    this.partNumber,
    this.description,
    this.img,
    this.disponible,
  });

  int id;
  String name;
  String partNumber;
  String description;
  String img;
  String disponible;

  factory M_producto.fromJson(Map<String, dynamic> json) => M_producto(
    id: json["id"],
    name: json["name"],
    partNumber: json["part_number"],
    description: json["description"],
    img: json["img"],
    disponible: json["disponible"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "part_number": partNumber,
    "description": description,
    "img": img,
    "disponible": disponible,
  };
}
