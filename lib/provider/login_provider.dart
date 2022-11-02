import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_purina/Utilidades/Load.dart';
import 'package:one_purina/Utilidades/Toast_util.dart';
import 'package:one_purina/Utilidades/config.dart';

class LoginProvider {
  String url_registro =
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=";
  String _Firebase_Token = "AIzaSyC09uKg6pJQod9_TQAgeNQ0kdFdB4DUMOE";

  BuildContext context;
  Loads loads;

  LoginProvider({this.context, this.loads});

  Future<bool> checkConnection() async {
    bool hasConnection = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    return hasConnection;
  }

  Future<Map<String, dynamic>> login_usuario(
      {String username, String password, String tipo_login}) async {
    loads = new Loads(context);

    var url = ulr_base + "/dealers/login";

    print(url);
    final body = {tipo_login: username, "password": password};
    final header = {
      "Accept": "application/json"
      //"Content-Type": "application/x-www-form-urlencoded"
    };
print(body.toString());
    http.Response resp;
    loads.dialo_Carga('Verificando...');
    bool conexion = await checkConnection();

    if (conexion == true) {
      try {
        resp = await http.post(url, body: body, headers: header);
        if (resp != null) {

          if (resp.statusCode == 200) {
            print(resp.body.toString());
            loads.cerrar();

            return {'ok': true, 'data': resp.body};
          } else {
            loads.cerrar();
            Toat_mensaje_center(
                color: 1, mensaje: "Los datos ingresados son incorrectos");
          }
        }
      } catch (_) {
        loads.cerrar();
        Toat_mensaje_center(
            color: 1, mensaje: "Error al iniciar sesión, intenta nuevamente");
        return {
          'ok': false,
          'mensaje': "Error al iniciar sesión, intenta nuevamente"
        };
      }
    } else {
      loads.cerrar();
      Toat_mensaje_center(color: 1, mensaje: "Verifica tu conexión a internet");
    }

//  loads.cerrar();
  }

  Future<Map<String, dynamic>> registrar_usuario(
      String email, String clave) async {
    final authData = {
      'email': email,
      'password': clave,
      'returnSecureToken': true
    };

    http.Response resp;
    bool conexion = await checkConnection();
    if (conexion == true) {
      loads.dialo_Carga('Creando...');
      try {
        resp = await http.post(url_registro + _Firebase_Token,
            body: json.encode(authData));
        Map<String, dynamic> decodedResp = jsonDecode(resp.body);

        if (decodedResp.containsKey('idToken')) {
          // print(decodedResp);
          // loads.cerrar();
          // Toat_mensaje_center(color: 2, mensaje: "Bienvenido");
          print("udi del  nuevo usuario ${decodedResp['localId']}");
          return {'ok': true, 'token': decodedResp['localId']};
        } else {
          loads.cerrar();
          Toat_mensaje_center(
              color: 1, mensaje: decodedResp['error']['message']);
          return {'ok': false, 'mensaje': decodedResp['error']['message']};
        }
      } catch (_) {
        // Navigator.popAndPushNamed(context, "login");
        Toat_mensaje_center(color: 1, mensaje: "Error,intenta nuevamente");
        // print('WTF');
      }
    } else {
      // loads.cerrar();
      Toat_mensaje_center(color: 1, mensaje: "Verifica tu conexión a internet");
    }
  }
}
