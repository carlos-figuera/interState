
import 'dart:convert';

M_Producto mProductoFromJson(String str) => M_Producto.fromJson(json.decode(str));

String mProductoToJson(M_Producto data) => json.encode(data.toJson());

class M_Producto {
  M_Producto({
    this.id,
    this.brand,
    this.rated,
    this.group,
    this.description,
    this.partNumber,
    this.img,
    this.quantity,this.cca,this.ca
  });

  String id;
  String brand;
  String rated;
  String group;
  String description;
  String partNumber;
  String img;
  String cca;
  String ca;
  var quantity;

  factory M_Producto.fromJson(Map<String, dynamic> json) => M_Producto(
    id:json["_id"]!=null? json["_id"]:"",
    brand: json["brand"]!=null?  json["brand"]:""   ,
    rated: json["rated"]!=null?  json["rated"]:"" ,
    group: json["group"]!=null?  json["group"]:"" ,
    img:json["img"]!=null? json["img"]:"" ,
    quantity:json["quantity"]!=null? json["quantity"]:"" ,
    description: json["description"]!=null? json["description"]:"" ,
    partNumber:json["part_number"]!=null? json["part_number"]:"" ,
      cca: json["cca"]!=null? json["cca"]:"",
      ca: json["ca"]!=null? json["ca"]:""
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "brand": brand,
    "rated": rated,
    "group": group,
    "description": description,
    "part_number": partNumber,
  };
}