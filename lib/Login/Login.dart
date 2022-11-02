import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:one_purina/Models/M_Login/M_Login_data.dart';
import 'package:one_purina/Models/M_Login/M_User_DB.dart';
import 'package:one_purina/Models/M_dealer/M_dealers.dart';
import 'package:one_purina/Models/M_dealer/M_dealersDB.dart';
import 'package:one_purina/Utilidades/Load.dart';
import 'package:one_purina/Utilidades/Offline.dart';
import 'package:one_purina/Utilidades/Pantalla/Pantalla_util.dart';
import 'package:one_purina/Utilidades/componentes/formularios/fomulario.dart';
import 'package:one_purina/Utilidades/config.dart';
import 'package:one_purina/Utilidades/notificacion_firebase.dart';
import 'package:one_purina/Utilidades/widget_globales.dart';
import 'package:one_purina/Views/Home_page.dart';
import 'package:one_purina/provider/db_sqlite.dart';
import 'package:one_purina/provider/login_provider.dart';
import 'package:one_purina/provider/solicitudes_http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Registar.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Loads loads;
  Formularios _formularios;
  final shape = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Colors.transparent));


  Notificacion_firebase notificacion_firebase = new Notificacion_firebase();
  Pantalla_util pantalla_util = new Pantalla_util();
  LoginProvider loginProvider;
  TextEditingController _usuarioController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  bool _lights = false;
  Solicitud_Http _solicitud_http;
  var _ver=true;
  String usuario = "";
  String passwor = "";
  String tipo_user;
  Future obteber_contasena() async {
    List<String> datos_user = await Obtener_contrasena(); //consulta la  apiKey guardada anteriormente

    if (datos_user != null) {
      if (datos_user[0] != "null") {
        print("inicio" + datos_user[0]);

        _usuarioController.text = datos_user[0];
        _lights = true;
        setState(() {});
      }
      if (datos_user[1] != "null") {
        print("inicio");
        _passwordController.text = datos_user[1];

        _lights = true;
        setState(() {});
      }
    } else {
      _passwordController.text = "";
      _usuarioController.text = "";
      _lights = false;
      setState(() {});
    }
  } //asigna un valor  a la  variable  apikey utilizada en el segundo paso del login
  Db_sqlite db_sqlite = new Db_sqlite();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db_sqlite.Load();
      loads = new Loads(context);
    _formularios = new Formularios(context: context);
    loginProvider = new LoginProvider(context: context);
    _solicitud_http = new Solicitud_Http(context: context);
    obteber_contasena();
  }

  Future<bool> _willPopCallback() async {
    return false; // return true if the route to be popped
  }

  final _formKey = GlobalKey<FormState>();
  final FocusNode _usuario = FocusNode();
  final FocusNode _clave = FocusNode();
  final FocusNode _fake = FocusNode();

  String usu="";
  String cla="";
  loginLocal()
  async {
    var exiteUsuario= await db_sqlite.existeUsuario(email:_usuarioController.text );

    if(exiteUsuario.length >0)
    {
     // guardar_data(name: "dealer", data:"604b9405c82ff005abc9f6e0");
      //_Dialo_privacidad(idInventario: "604b942cc82ff005abc9f6e1");
      if(exiteUsuario[0].email==_usuarioController.text && exiteUsuario[0].contrasena==_passwordController.text  )
      {
        usu="carlos@carlos.com";
        cla="carlos";
        Login();
      }else
      {
        usu=_usuarioController.text;
        cla=_passwordController.text;
        Login();
      }

    } else
      {
          usu=_usuarioController.text;
          cla=_passwordController.text;
        Login();
      }
  }



  Login() async {
    if (_formKey.currentState.validate()) {
        comprobar_user();
        print(usu);
        print(cla);

      var resultado = await loginProvider.login_usuario(
        password: cla.trim(),
        username: usu.trim(),
        tipo_login: tipo_user
      );
      if (resultado != null) {
        if (resultado['ok']) {
          //Obtiene todos los datos del usuario y los guarda en un mapa llamado user
          Map<String, dynamic> DealerData = jsonDecode(resultado["data"]);

          //Convierte el mapa user en una instancia de LoginData
          final m_Dealer = new M_Dealer.fromJsonBase(DealerData);
          print("id dealer    ${m_Dealer.message}");

          final dealerDb = new DealerDb.fromJsonBase(m_Dealer.dealerDb);

          //Guarda el token del usuario logeado
          print("Token de usuario  ${m_Dealer.token}");

          guardar_data(name: "token", data: m_Dealer.token);
          //Guarda el id del dealer logeado
          guardar_data(name: "dealer", data: dealerDb.id.toString());
          print("id dealer    ${dealerDb.id}");
           //Envia el token de firebase al servidor de InterState
           _solicitud_http. upload_token();

          // Obtiene los datos del dealer

           new Future.delayed(new Duration(seconds: 2), () {
            getDataDealer();
          });



        }
      }
    }
  }

  loginExplorarSinConexion() async {
    usu="12345678";
    cla="123456789";
    tipo_user = "dealer_id";
    var resultado = await loginProvider.login_usuario(
        password: cla.trim(),
        username: usu.trim(),
        tipo_login: tipo_user
    );
    if (resultado != null) {
      if (resultado['ok']) {

        guardar_data(name:"userDemo", data: "si");
        //Obtiene todos los datos del usuario y los guarda en un mapa llamado user
        Map<String, dynamic> DealerData = jsonDecode(resultado["data"]);

        //Convierte el mapa user en una instancia de LoginData
        final m_Dealer = new M_Dealer.fromJsonBase(DealerData);
        print("id dealer    ${m_Dealer.message}");

        final dealerDb = new DealerDb.fromJsonBase(m_Dealer.dealerDb);

        //Guarda el token del usuario logeado
        print("Token de usuario  ${m_Dealer.token}");

        guardar_data(name: "token", data: m_Dealer.token);
        //Guarda el id del dealer logeado
        guardar_data(name: "dealer", data: dealerDb.id.toString());
        print("id dealer    ${dealerDb.id}");
        //Envia el token de firebase al servidor de InterState
        _solicitud_http. upload_token();

        // Obtiene los datos del dealer

        new Future.delayed(new Duration(seconds: 2), () {
          getDataDealer();
        });



      }
    }
  }


    comprobar_user() {
    var tipo = _formularios.validateEmail(_usuarioController.text);
    if (tipo == "Requerido*") {
      print("vacio");
    } else if (tipo == null) {
      tipo_user = "email";
      print("es correo");
    } else {
      tipo_user = "dealer_id";
      print("user id");
    }

  }

  getDataDealer() async {

    //Obtiene el id de dealer y lo guarda en la variable dealerId
    String dealerId = await Obtener_data(name: "dealer");

    //Realiza la peticion de los datos del dealer
    var resultado = await _solicitud_http.getData(api_name: "/dealer/", id: dealerId.toString(),loa: true);

    if (resultado != null) {
      if (resultado['codigo'] == "200") {

        //guarda en un mapa todos los datos obtenidos del dealer
        Map<String, dynamic> DealerData = jsonDecode(resultado["datos"]);

         //Convierte todos los datos del dealer en una instancia de  M_Dealer
        final dealerDb = new M_Dealer.fromJsonBase(DealerData);
        print("id dealer    ${dealerDb.message}");

        final userDb = new DealerDb.fromJsonBase(dealerDb.dealerDb);
        print("inventario  ${userDb.inventory}");

        new Future.delayed(new Duration(seconds: 2), () {
          _Dialo_privacidad( idInventario:userDb.inventory );
        });




      }else
        {

        }
    }
  }



  Future<void> _Dialo_privacidad({String idInventario}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            "Entiendo que Interstate protegerá mis datos como se describe en el aviso de privacidad y Tus datos. Autorizo expresamente a Interstate y/o sus afiliados a contactarme vía email,notificaciones push, campañas de remarketing,correo directo, teléfono fijo y/o celular.",
            textAlign: TextAlign.justify,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Salir'),
              onPressed: () {
                Navigator.of(context).pop();


                guardar_data( name: "Acepto_politica",data: "NO");
              },
            ),
            FlatButton(
              child: Text('Aceptar'),
              onPressed: () {
               // Navigator.of(context).pop();

                guardar_data( name: "Acepto_politica",data: "SI");
                //Guarda el id del invetario del dealer
                guardar_data(name: "inventario", data:idInventario  );
                //Redirecciona al usuario hacia el home
                new Future.delayed(new Duration(seconds: 1), () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                });

              },
            ),
          ],
        );
      },
    );
  }

  Future get_politica() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var idInventario= await Obtener_data( name:'Acepto_politica' );
    print(idInventario);
    if (prefs != null) {
      if (idInventario == "SI") {

        print("lo acepte");

      } else if (idInventario == "NO") {
        _Dialo_privacidad();


      } else {
        _Dialo_privacidad();


      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    pantalla_util.portraitModeOnly();
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => _willPopCallback(),
        child: Stack(
          overflow: Overflow.clip,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: SafeArea(
                      left: true,
                      top: true,
                      right: true,
                      bottom: true,
                      minimum: const EdgeInsets.fromLTRB(1.0, 10.0, 1.0, 1.0),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                                height: screenHeight * 0.95,
                                width: screenWidth,
                                color: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.05),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: screenHeight * 0.33,
                                        child: imagen_asset_plantilla(
                                            url: "assets/logo.jpg"),
                                        padding: EdgeInsets.all(20),
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.01,
                                      ),

                                      _formularios.campo_Texto(
                                          currentFocus: _usuario,
                                          nextFocus: _clave,
                                          nombre: 'Usuario',
                                          flex: 2,
                                          nombreController: _usuarioController),

                                      SizedBox(
                                        height: 3,
                                      ),

                                      Expanded(
                                        child: TextFormField(
                                          focusNode: _clave,
                                          decoration: InputDecoration(
                                             // prefixIcon: Icon(Icons.https),
                                              border: shape_boton_p,
                                              labelText: 'Contraseña',
                                              suffixIcon: IconButton(
                                                  icon: Icon(
                                                    _ver
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color: Colors.grey,
                                                  ),
                                                  onPressed: () {
                                                    _ver = !_ver;
                                                    setState(() {});
                                                  })
                                            //icon: Icon(Icons.check_circle,color: Colors.green,),
                                          ),
                                          obscureText: _ver,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Requerido*';
                                            }
                                            return null;
                                          },
                                          textInputAction: TextInputAction.done,
                                          controller: _passwordController,
                                          keyboardType: TextInputType.text,
                                        ),
                                        flex: 2,
                                      ),


                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 0),
                                          child: SwitchListTile(
                                            selected: true,
                                            title: new Text(
                                                'Recordar contraseña',
                                                style: new TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: textColor1,
                                                    fontSize: 12)),
                                            value: _lights,
                                            onChanged: (bool value) {
                                              setState(() {
                                                _lights = value;

                                                print(_lights);
                                                if (_lights == true) {
                                                  guardar_contrasena(
                                                      _usuarioController.text,
                                                      _passwordController.text);
                                                } else {
                                                  guardar_contrasena("", "");
                                                  _passwordController.text = "";
                                                  _usuarioController.text = "";
                                                }

                                                print(usuario);
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),

                                      Container(
                                        padding: EdgeInsets.only(bottom: 5),
                                        width: screenWidth,
                                        child: MaterialButton(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          shape: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent)),
                                          color: primaryColor,
                                          onPressed: () => setState(() {


                                            loginLocal();

                                           // Login();
                                          }),
                                          child: Text(
                                            "Ingresar",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(bottom: 5),
                                        width: screenWidth,
                                        child: MaterialButton(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          shape: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: primaryColor)),
                                          color: Colors.white,
                                          onPressed: ()   {


                                            loginExplorarSinConexion();


                                          },
                                          child: Text(
                                            "Explorar sin registro",
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      //Recuperar contraseña

                                      Platform.isAndroid
                                          ? Expanded(
                                              child: Center(
                                              child: FlatButton(
                                                  onPressed: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Registarse()));
                                                  },
                                                  child: new Text(
                                                      '¿No tienes cuenta?, Regístrate.',
                                                      style: new TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: textColor1,
                                                          fontSize: 12))),
                                            ))
                                          : SizedBox(),
                                      Expanded(child: Text(""))
                                    ],
                                  ),
                                )
                                //Forma  2  GridView

                                //fin columna
                                )
                          ],
                        ),
                      )),
                )),
          ],
        ),
      ),
    );
  }
}
