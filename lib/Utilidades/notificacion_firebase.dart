import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_purina/Utilidades/Offline.dart';
import 'package:one_purina/Views/Inventario_especial_pages/Categorias_especiales_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notificacion_firebase {



  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  static Future<dynamic> _myBackgroundMessageHandler(
      Map<String, dynamic> message) {
    //https://via.placeholder.com/150

    //   C/O https://placeholder.com/

    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      print('on data $data');
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print('on notification $notification');
    }
    print('on message $message');
    // Or do other work.
  }


  Future Redirecion_clik_notificacion( ) async {
    String InvetarioId = await Obtener_data(name: "inventario");

    new Future.delayed(new Duration(seconds: 2), () {
      try {
        if (InvetarioId == null) {
          print(InvetarioId);
          //Navigator.pushReplacementNamed(context, "Inventario");
          print(' si esta logeado');
        } else if (InvetarioId != null) {
        //  Navigator.pushReplacementNamed(context, "LoginPage");
          guardar_data( name:'desde_login',data:"1" );

          print(' no esta logeado');
        }
      } catch (e) {
       // Navigator.pushReplacementNamed(context, "LoginPage");
        guardar_data( name:'desde_login',data:"1" );
        print(' no esta logeado');
      }
    });


  }

  Future<void> firebaseCloudMessaging_Listeners({BuildContext context}) async {
    print(' firebaseCloudMessaging_Listeners');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (Platform.isIOS) iOS_Permission();
    firebaseMessaging.getToken();

      firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          //SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('notificacion', json.encode(message));
          if (message.containsKey('notification')) {
           // Redirecion_clik_notificacion(context: context);
          }
        },

        onResume: (Map<String, dynamic> message) async {
          prefs.setString('notificacion', json.encode(message));
          if (message.containsKey('notification')) {

            Redirecion_clik_notificacion( );
          }

        },
        onLaunch: (Map<String, dynamic> message) async {
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('notificacion', json.encode(message));
          if (message.containsKey('notification')) {
            Redirecion_clik_notificacion( );
          }

        },
      );

  }

  void iOS_Permission() {
    firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }



  Future<void> Dialo_notificacion(
      {BuildContext context, String title, String body, String type}) async {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
    Future.delayed(const Duration(milliseconds: 4000), () {
      if(    Navigator.canPop(context))
      {
         Navigator.pop(context);
      }

    });
        return AlertDialog(
          title: AutoSizeText(
            title,
            maxLines: 2,
            style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w900,
                wordSpacing: 1,
                height: 1.2),
            softWrap: true,
            maxFontSize: 16,
            minFontSize: 14,
            textAlign: TextAlign.justify,
          ),
          contentPadding: EdgeInsets.all(5),
          titlePadding: EdgeInsets.all(8),
          content: Container(
              height: screenHeight * 0.21,
              width: screenWidth * 2,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(width: screenWidth * 0.02),
                      Container(
                        width: screenWidth * 0.65,
                        height: screenWidth * 0.2,
                        child: AutoSizeText(
                          body,
                          maxLines: 5,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              wordSpacing: 1,
                              height: 1.2),
                          softWrap: true,
                          maxFontSize: 14,
                          minFontSize: 12,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(width: screenWidth * 0.03),
                      Expanded(
                          child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child:
                            //icon: _Categoria_icon[position],
                            Text(
                          "Cerrar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        //padding: EdgeInsets.only(right: ),
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      )),
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(
                          child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                         // ObtenerSesion(context: context, type: type);
                        },
                        child:
                            //icon: _Categoria_icon[position],
                            Text(
                          "Abrir",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      )),
                      SizedBox(width: screenWidth * 0.03),
                    ],
                  )
                ],
              )),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.transparent, width: 2)),
        );
      },
    );
  }
}
