import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:one_purina/Utilidades/Offline.dart';
import 'package:one_purina/Utilidades/config.dart';
import 'package:one_purina/Utilidades/widget_globales.dart';

import 'Inventario_especial_pages/Categorias_especiales_page.dart';
import 'Inventario_pages.dart';

class Drawer_admin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _Drawer_repartidorState();
}

class _Drawer_repartidorState extends State<Drawer_admin> {
  var _progreso;
  var _progreso_Text;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget icon_drawer(String path) {
    // "assets/icon_svgs/cartelera.svg",
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return ExcludeSemantics(
      child: Container(
        decoration:BoxDecoration(     ) ,
        width: screenWidth * 0.13,
        height:screenWidth * 0.13,
        padding: EdgeInsets.all(1),
        child: Image.asset(
          path,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

//  " Cartelera"
  Widget title_drawer(String title) {
    // "assets/icon_svgs/cartelera.svg",
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return Padding(
        padding: EdgeInsets.only(left: 5),
        child: ExcludeSemantics(
          child: Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
        ));
  }
  dialoFunsionNoDisp( ) async {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: screenHeight * 0.3,
                width: screenWidth,
                padding: EdgeInsets.all( 10),
                child: Column(
                  children: <Widget>[

                    SizedBox(height: screenHeight * 0.01),



                    AutoSizeText(
                      "Función no disponible. Debes iniciar sesión.",
                      minFontSize: 13,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize:16,
                          color: secondaryColor),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: MaterialButton(
                            shape: shape_boton_p,
                            color: Colors.grey,
                            onPressed: () => setState(() {
                              Navigator.pop(context);
                            }),
                            child: Text(
                              "Cerrar",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          child: FlatButton(
                            shape: shape_boton_p,
                            color: primaryColor,
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              //Guarda el token del usuario logeado
                              guardar_data(name: "token", data:null);
                              //Guarda el id del dealer logeado
                              guardar_data(name: "dealer", data:null);
                              //Guarda el id del invetario del dealer
                              guardar_data(name: "inventario", data: null);
                              guardar_data( name: "Acepto_politica",data: "NO");
                              guardar_data(name:"userDemo", data: "no");
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(
                                  context, "LoginPage");
                            },
                            child: Text(
                              "Iniciar sesión",style: TextStyle(color: Colors.white),),
                          ),flex: 1,)


                      ],
                    ),

                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              );
            },

          ),
          contentPadding: EdgeInsets.all(screenWidth * 0.00),
          shape: shape_dialog,
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return Drawer(
      child: Container(
       // color: primaryColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height * 0.26,
                width: MediaQuery.of(context).size.width,
                margin:  EdgeInsets.only(top: 25,),
               padding: EdgeInsets.only(top: 25,),
                child:Image.asset("assets/logo.png")  ),

            SizedBox(height: 20,),

            Container(
                height: MediaQuery.of(context).size.height * 0.20,
                width: MediaQuery.of(context).size.width,

                padding: EdgeInsets.symmetric( horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: GestureDetector(
                          child: card_home(
                              assetImg: "assets/iconos/p1.png",
                              title: "Mi Inventario"),
                          onTap: () async {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => Mis_ordenes ()));

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Inventario()));


                          },
                        )),
                    Expanded(
                        child: GestureDetector(
                          child: card_home(
                              assetImg: "assets/iconos/p2.png",
                              title: "Ordenes Especiales"),
                          onTap: () async {

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Categoria_especial()));



                            //Navigator.pushReplacementNamed(context, "Orden_especial_page");
                          },
                        )),

                  ],
                )  ),

            Container(
                height: MediaQuery.of(context).size.height * 0.20,
                width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric( horizontal: 10),
                child: Row(
                  children: <Widget>[


                    Expanded(
                        child: GestureDetector(
                          child: card_home(
                              assetImg: "assets/iconos/p3.png",
                              title: "Reporte de Ordenes"),
                          onTap: () async {
                            //Navigator.pushReplacementNamed(context, "Inventario");



                            String  userDemo= await Obtener_data(name:"userDemo" );
                            if(userDemo=="no")
                            {

                              Navigator.pushReplacementNamed(
                                  context, "Mis_ordenes",
                                  arguments: "normal");
                            } else
                            {
                              dialoFunsionNoDisp( );

                            }


                          },
                        )),
                    Expanded(
                        child: GestureDetector(
                          child: card_home(
                              assetImg: "assets/iconos/p4.png",
                              title: "Salir"),
                          onTap: () {
                            //Guarda el token del usuario logeado
                            guardar_data(name: "token", data:null);
                            //Guarda el id del dealer logeado
                            guardar_data(name: "dealer", data:null);
                            //Guarda el id del invetario del dealer
                            guardar_data(name: "inventario", data: null);
                            guardar_data( name: "Acepto_politica",data: "NO");
                            guardar_data(name:"userDemo", data: "no");
                            Navigator.pushReplacementNamed(context, "LoginPage");

                            //Navigator.pushReplacementNamed(context, "Orden_especial_page");
                          },
                        )),
                  ],
                ),  ),


          ],
        ),
      ),
    );
  }
}
