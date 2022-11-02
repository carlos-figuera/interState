import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_purina/Utilidades/Load.dart';
import 'package:one_purina/Utilidades/Offline.dart';
import 'package:one_purina/Utilidades/Toast_util.dart';
import 'dart:async';
import 'package:one_purina/Utilidades/config.dart';
import 'package:one_purina/Utilidades/metodos_globales.dart';
import 'package:one_purina/Utilidades/notificacion_firebase.dart';

class Solicitud_Http {
  BuildContext context;
  Loads loads;

  Solicitud_Http({this.context, this.loads});

  Future<Map<String, dynamic>> upload_data(
      {String api_name, String id, Map<String, dynamic> data}) async {
    var url = ulr_base + api_name + id;
    loads = new Loads(context);
    print('enviando carrito');
    final body = {
      "products": [
        {
          "_id": "5f7765ac232d00000405ea46",
          "quantity": 200,
          "description": "Gomas para carros",
          "img": "5f7765ac232d00000405ea46-891.png",
          "part_number": "GMS2020"
        },
        {
          "_id": "5f7765d7232d00000405ea48",
          "quantity": 300,
          "description": "Gomas para carros",
          "img": "5f7765d7232d00000405ea48-979.png",
          "part_number": "test02"
        }
      ],
      "type": "especial_orders"
    };

    String token = await Obtener_data(name: "token");

    final header = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'token': token
    };

    http.Response resp;
    loads.dialo_Carga('Someter Inventario');
    bool conexion = await checkConnection();

    if (conexion == true) {
      try {
        resp = await http.post(url, body: json.encode(data), headers: header);
        Map<String, dynamic> decodedResp = jsonDecode(resp.body);
        if (resp != null) {
          loads.cerrar();
          if (resp.statusCode == 201) {
            // Toat_mensaje_center(color: 2, mensaje: "Orden Enviada");
            //  print(decodedResp);
            return {'codigo': resp.statusCode, 'data': decodedResp};
          } else if (resp.statusCode == 401) {
            //  loads.cerrar();
            Toat_mensaje_center(
                color: 1, mensaje: "Los datos ingresados son incorrectos");
            return {
              'codigo': resp.statusCode,
              'mensaje': decodedResp['error']['message']
            };
          }

          print(resp.statusCode);
        }
      } catch (_r) {
        print("error $_r");

        loads.cerrar();
      }
    } else {
      loads.cerrar();
      Toat_mensaje_center(color: 1, mensaje: "Verifica tu conexión a internet");
    }

//  loads.cerrar();
  }

  Future<Map<String, dynamic>> upload_token() async {
    Notificacion_firebase notificacion_firebase = new Notificacion_firebase();
    String firebase_token =await notificacion_firebase.firebaseMessaging.getToken();
    String dealer = await Obtener_data(name: "dealer");
    var url = ulr_base + "/route/" + dealer + "/" + firebase_token;
    print('enviando token');
    print(url);
    http.Response resp;
    bool conexion = await checkConnection();
    if (conexion == true) {
      try {
        resp = await http.post(url);
        Map<String, dynamic> decodedResp = jsonDecode(resp.body);
        if (resp != null) {
          if (resp.statusCode == 200) {
          //  Toat_mensaje_center(color: 1, mensaje: "Token enviado");
           // guardar_data(name: "fToken", data: "si");
            return {'codigo': resp.statusCode, 'data': decodedResp};
          } else if (resp.statusCode == 401) {
          //  Toat_mensaje_center(color: 1, mensaje: "Token  no enviado");
            return {
              'codigo': resp.statusCode,
              'mensaje': decodedResp['error']['message']
            };
          }
          print(resp.statusCode);
        }
      } catch (_r) {
        print("error $_r");
      }
    } else {
      //Toat_mensaje_center(color: 1, mensaje: "Verifica tu conexión a internet");
    }
  }



  //Buscar extensiones y administradores
  Future<Map<String, dynamic>> getData({String api_name, String id, bool loa}) async {
    loads = new Loads(context);
    String token = await Obtener_data(name: "token");
    var headers = {'token': token};
    if(loa!=null)
    {
      if(loa)
      {
        loads.dialo_Carga('Obteniendo Datos...');
      }
    }


    bool conexion = await checkConnection();
    Map<String, dynamic> map_respuesta = {"data": null, "codigo": "100"};
    if (conexion) {
      var url = ulr_base + api_name + id;
      //encode Map to JSON
      http.Response response = await http.get(url, headers: headers);
      print(url);
      print(response.statusCode);
      if(response!=null)
      {
       loads.cerrar();



      if (response.statusCode <= 210) {
        print(response.body);
        map_respuesta = {
          "codigo": response.statusCode.toString(),
          "datos": response.body
        };
        new Future.delayed(new Duration(seconds: 2), () async {
          if(loa!=null)
          {
            if(loa)
            {
              loads.cerrar();
            }
          }

        });



      } else if (response.statusCode == 401) {
        Toat_mensaje_center(
            color: 1, mensaje: " La sesión expiro, debes iniciar sesión nuevamente.");
        print(response.body);
        map_respuesta = {
          "codigo": response.statusCode.toString(),
          "datos": response.body
        };
      } else if (response.statusCode == 500) {
        Toat_mensaje_center(
            color: 1, mensaje: "Error en el servidor central.");
        print(response.body);
        map_respuesta = {
          "codigo": response.statusCode.toString(),
          "datos": response.body
        };
      }else {
        loads.cerrar();
        map_respuesta = {
          "codigo": response.statusCode.toString(),
          "datos": null
        };
      }
    }
    }
    return map_respuesta;
  }


  Future<Map<String, dynamic>> deleteData({String api_name, String id, bool loa}) async {
    loads = new Loads(context);
    String token = await Obtener_data(name: "token");
    var headers = {'token': token};
    if(loa!=null)
    {
      if(loa)
      {
        loads.dialo_Carga('Borrando...');
      }
    }


    bool conexion = await checkConnection();
    Map<String, dynamic> map_respuesta = {"data": null, "codigo": "100"};
    if (conexion) {
      var url = ulr_base + api_name + id;

      http.Response response = await http.delete(url, headers: headers);
      print(url);
      print(response.statusCode);
      if(response!=null)
      {
        loads.cerrar();
        if (response.statusCode <= 210) {
          print(response.body);
          map_respuesta = {
            "codigo": response.statusCode.toString(),
            "datos": response.body
          };
          new Future.delayed(new Duration(seconds: 2), () async {
            if(loa!=null)
            {
              if(loa)
              {
                loads.cerrar();
              }
            }

          });



        } else if (response.statusCode == 401) {
          Toat_mensaje_center(
              color: 1, mensaje: " La sesión expiro, debes iniciar sesión nuevamente.");
          print(response.body);
          map_respuesta = {
            "codigo": response.statusCode.toString(),
            "datos": response.body
          };
        } else if (response.statusCode == 500) {
          Toat_mensaje_center(
              color: 1, mensaje: "Error en el servidor central.");
          print(response.body);
          map_respuesta = {
            "codigo": response.statusCode.toString(),
            "datos": response.body
          };
        }else {
          loads.cerrar();
          map_respuesta = {
            "codigo": response.statusCode.toString(),
            "datos": null
          };
        }
      }
    }
    return map_respuesta;
  }
}
