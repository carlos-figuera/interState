// To parse this JSON data, do
//
//     final mRegistro = mRegistroFromJson(jsonString);

import 'dart:convert';

MRegistro mRegistroFromJson(String str) => MRegistro.fromJson(json.decode(str));

String mRegistroToJson(MRegistro data) => json.encode(data.toJson());

class MRegistro {
    MRegistro({
        this.nombre,
        this.email,
        this.celular,
        this.contrasena,
    });

    String nombre;
    String email;
    String celular;
    String contrasena;

    factory MRegistro.fromJson(Map<String, dynamic> json) => MRegistro(
        nombre: json["nombre"],
        email: json["email"],
        celular: json["celular"],
        contrasena: json["contrasena"],
    );

    Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "email": email,
        "celular": celular,
        "contrasena": contrasena,
    };
}
