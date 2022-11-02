import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:one_purina/Utilidades/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login/Login.dart';
import 'Models/M_Participant.dart';
import 'Utilidades/Offline.dart';
import 'Utilidades/notificacion_firebase.dart';
import 'Utilidades/widget_globales.dart';
import 'Views/Home_page.dart';
import 'Views/Inventario_pages.dart';
import 'Views/Ordenes_pages/Reporte de Ordenes_page.dart';
import 'Views/carrito_pages.dart';
import 'Views/Inventario_especial_pages/Categorias_especiales_page.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    HttpClient client = super.createHttpClient(context); //<<--- notice 'super'
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interstate Batteries Puerto Rico Inventory Control',
      initialRoute: "splash",
      routes: {
        "splash": (BuildContext context) => splash(),
        "LoginPage": (BuildContext context) => LoginPage(),
        "HomePage": (BuildContext context) => Home(),
        "Inventario": (BuildContext context) => Inventario(),
        "Carrito_page": (BuildContext context) => Carrito_page(),
        "Orden_especial_page": (BuildContext context) => Categoria_especial(),
        "Mis_ordenes": (BuildContext context) => Mis_ordenes(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.green,
          cursorColor: Colors.green,
         // fontFamily: 'Nexa'
      ),
    );
  }
}

class splash extends StatefulWidget {
  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<splash> {
  M_Participant participant;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    super.initState();

    firebaseCloudMessaging_Listeners(context: context);
    ObtenerSesion();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
            shape: BoxShape.rectangle, color: primaryColor,
            gradient: new LinearGradient(
                colors: [
                  primaryColor,
                  primaryColor1,
                  primaryColor2
                ],

                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                tileMode: TileMode.repeated
            )
            ),
        child: Column(
          children: <Widget>[
            Container(
              height: screenHeight * 0.3,
              child: Text(""),
            ),

            Text(
              "Puerto Rico",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.normal),
            ),
            Container(
              height: screenHeight * 0.25,
              //color: Colors.black,
              width: double.infinity,
              child: imagen_asset_plantilla(url: "assets/logo.png"),
              padding: EdgeInsets.symmetric(  vertical: 5),
            ),
            Container(
              height: screenHeight * 0.10,
              child: Text(
                "Bienvenido",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal),
              ),
            ),
            widget_Cargando(),
          ],
        ),
      ),
    );
  }

  Future ObtenerSesion() async {
    String  userDemo= await Obtener_data(name:"userDemo" );
    String firebase_token =await  firebaseMessaging.getToken();
    print(userDemo);
    if(userDemo=="no")
    {
      new Future.delayed(new Duration(seconds: 5), () async {
        String InvetarioId = await Obtener_data(name: "inventario");
        try {
          if (InvetarioId != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
          } else if (InvetarioId == null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
          }
        } catch (e) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
      });
    }else{
      guardar_data(name:"userDemo", data: "no");
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }




  }



  Future Redirecion_clik_notificacion( ) async {
    String InvetarioId = await Obtener_data(name: "inventario");
    print(context);
    new Future.delayed(new Duration(seconds: 2), () {
      try {
        if (InvetarioId == null) {
          print(InvetarioId);
          Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
          print(' si esta logeado');
        } else if (InvetarioId != null) {
          Navigator.pushReplacementNamed(context, "LoginPage");
          guardar_data( name:'desde_login',data:"1" );

          print(' no esta logeado');
        }
      } catch (e) {
        Navigator.pushReplacementNamed(context, "LoginPage");
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
        Redirecion_clik_notificacion( );

      },
      onLaunch: (Map<String, dynamic> message) async {
        Redirecion_clik_notificacion( );

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




}
