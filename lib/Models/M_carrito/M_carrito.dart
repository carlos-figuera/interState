import 'dart:convert';

M_Carrito mCarritoFromJson(String str) => M_Carrito.fromJson(json.decode(str));

String mCarritoToJson(M_Carrito data) => json.encode(data.toJson());

class M_Carrito {
  M_Carrito(
      {this.idproducto,
      this.brand,
      this.quantity,
      this.img,
      this.description,
      this.partNumber,
      this.id,
      this.tipo,
      this.rated,
      this.group,this.cca});

  String idproducto;
  int id;
  String brand;
  String quantity;
  String img;
  String description;
  String partNumber;
  String tipo;
  String rated;
  String group;
  String cca;
  factory M_Carrito.fromJson(Map<String, dynamic> json) => M_Carrito(
      idproducto: json["idproducto"],
      brand: json["brand"],
      quantity: json["quantity"],
      img: json["img"],
      description: json["description"],
      partNumber: json["part_number"],
      id: json["id"],
      rated: json["rated"],
      group: json["grou"],
      tipo: json["tipo"],
    cca: json["cca"],);

  Map<String, dynamic> toJson() => {
        "_id": idproducto,
        "brand": brand,
        "quantity": quantity,
        "rated": rated,
        "group": group,
        "img": img,
    "cca": cca,
        "description": description,
        "part_number": partNumber,
      };
}
