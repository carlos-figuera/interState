import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_purina/Utilidades/Load.dart';
import 'package:one_purina/Utilidades/Toast_util.dart';
import 'package:one_purina/Utilidades/metodos_globales.dart';


class Recuperar_Contrasena_Provider {
  String enviar_codigo =
      "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=";

  String url_login =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=";
  String _Firebase_Token = "AIzaSyC09uKg6pJQod9_TQAgeNQ0kdFdB4DUMOE";

  BuildContext context;
  Loads loads;
  Recuperar_Contrasena_Provider({this.context, this.loads});

  Future<Map<String, dynamic>> enviar_codigo_reseteo(String email) async {
    print('Enviar  codigo de reseteo');
    final authData = {
      'email': email,
      'requestType': "PASSWORD_RESET",
    };
    http.Response resp;
    loads.dialo_Carga('Verificando...');
    bool conexion = await checkConnection();

    if (conexion == true) {
      try {
        resp = await http.post(enviar_codigo + _Firebase_Token,
            body: json.encode(authData));
        Map<String, dynamic> decodedResp = jsonDecode(resp.body);
        print(resp.body);
        if (decodedResp.containsKey('email')) {
          // Toat_mensaje_center(color: 2, mensaje:"Bienvenido"  );

          loads.cerrar();
          //  print(decodedResp['idToken']);
          return {'ok': true, 'email': decodedResp['email']};
        } else {
          loads.cerrar();
          Toat_mensaje_center(color: 1, mensaje: decodedResp.toString());
          return {'ok': false, 'mensaje': decodedResp.toString()};
        }
      } catch (_) {
        // Navigator.popAndPushNamed(context, "login");
        loads.cerrar();
        Toat_mensaje_center(
            color: 1,
            mensaje:
                "Error al enviar código de recuperación, intenta nuevamente");
        //print('WTF');
      }
    } else {
      loads.cerrar();
      Toat_mensaje_center(color: 1, mensaje: "Verifica tu conexión a internet");
    }

//  loads.cerrar();
  }

  Future<Map<String, dynamic>> login_usuario1(
      String email, String clave) async {
    print('logeando');
    final authData = {
      'email': email,
      'password': clave,
      'returnSecureToken': true
    };
    http.Response resp;
    try {
      resp = await http.post(url_login + _Firebase_Token,
          body: json.encode(authData));
      Map<String, dynamic> decodedResp = jsonDecode(resp.body);
      print(decodedResp);
      if (decodedResp.containsKey('idToken')) {
        Toat_mensaje_center(color: 2, mensaje: "Bienvenido");
        return {'ok': true, 'token': decodedResp['idToken']};
      } else {
        Toat_mensaje_center(color: 1, mensaje: decodedResp['error']['message']);
        return {'ok': false, 'mensaje': decodedResp['error']['message']};
      }
    } catch (_) {
      //Navigator.popAndPushNamed(context, "login");
      Toat_mensaje_center(
          color: 1, mensaje: "Error al iniciar sesión, intenta nuevamente");
      print('WTF');
      return {
        'ok': false,
        'mensaje': "Error al iniciar sesión, intenta nuevamente"
      };
    }
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
        resp = await http.post(url_login + _Firebase_Token,
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
