import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:one_purina/Models/M_carrito/M_carrito.dart';
import 'package:one_purina/Models/M_inventario/M_productos.dart';
import 'package:one_purina/Models/M_ordenes/M_ordenes.dart';
import 'package:one_purina/Utilidades/Load.dart';
import 'package:one_purina/Utilidades/Offline.dart';
import 'package:one_purina/Utilidades/Toast_util.dart';
import 'package:one_purina/Utilidades/config.dart';
import 'package:one_purina/Utilidades/widget_globales.dart';
import 'package:one_purina/provider/db_sqlite.dart';
import 'package:one_purina/provider/solicitudes_http.dart';

class Detalle_page extends StatefulWidget {
  M_orden m_orden;
  Detalle_page({this.m_orden});
  @override
  Detalle_pageState createState() => new Detalle_pageState();
}

class Detalle_pageState extends State<Detalle_page>
    with WidgetsBindingObserver {
  List<M_Producto> _list_producto;
  bool carga = true;
  Loads loads;
  TextStyle SubTitulo = TextStyle(fontWeight: FontWeight.w600, fontSize: 16);
  TextStyle Titulo = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  Solicitud_Http _solicitud_http;


  String tipo_orden = "normal";
  var _numero_orden = "";



  ScrollController _controller;
  bool isStopped = false; //global
  int contador = 0;
  int total = 0;

  extraer()
  {
    _numero_orden=widget.m_orden.n_order.toString();
    _list_producto = new List();
    _list_producto.clear();
    var List_producto = widget.m_orden.products as List;
    List_producto.forEach((snapshot) {
      print(snapshot);
      var List_producto = snapshot as List;
      List<M_Producto> List_products_temp = new List();
      List_products_temp = List_producto.map((model) => M_Producto.fromJson(model)).toList();
      _list_producto.addAll(List_products_temp);
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();


    loads = new Loads(context);
    _solicitud_http = Solicitud_Http(context: context, loads: loads);
    extraer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("Current state = $state");
    switch (state.index) {
      case 0: // resumed
        break;
      case 1: // inactive
        break;
    }
  }

  Future<bool> _willPopCallback() async {
    return false; // return true if the route to be popped
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final screenOri = MediaQuery.of(context).orientation;
    final screenPortrait = Orientation.portrait;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Pedido # $_numero_orden", style: Titulo20),
        centerTitle: true,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace),
          padding: EdgeInsets.only(bottom: 4),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: carga == true
          ? Container(
        color: fondo_body,
              child: SingleChildScrollView(
                child: SafeArea(
                  left: true,
                  top: true,
                  right: true,
                  bottom: true,
                  minimum: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
                  child: Container(
                    height: screenHeight * 0.86,
                    width: screenWidth,
                    child: Column(
                      children: <Widget>[
                        //Lista de productos
                        Expanded(
                            child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          // itemCount: _List_products == null ? 0 : _List_products.length,
                          itemCount: _list_producto.length,
                          itemBuilder: (context, position) {
                            print(_list_producto[position].img);
                            return Card(
                              child: Padding(
                                child: Row(
                                  children: <Widget>[
                                    /*Expanded(
                                      child: imagen_cache_plantilla(
                                         // url: "https://interstate-pr.herokuapp.com/api/images/users/" + _list_producto[position].img),
                                  url:  _list_producto[position].img),
                                      flex: 1,
                                    ),*/
                                    Expanded(
                                      child: Container(
                                        height: screenHeight * 0.25,
                                        child: Column(
                                          children: <Widget>[
                                            TitleProd(_list_producto[position].brand),
                                            subTitleProd( _list_producto[position].description,1),
                                            //subTitleProdsNoE( data:"Description :  dos lineas" + _List_products[position].description,direc: 1,color: Colors.black54),
                                            subTitleProdsNoE( data:"Grupo: "+_list_producto[position].group,direc: 1,color: Colors.black54),
                                           subTitleProdsNoE( data:"Numero de Parte: "+_list_producto[position].partNumber,direc: 1,color: Colors.black54),
                                            subTitleProdsNoE( data:"CCA: "+_list_producto[position].cca,direc: 1,color: Colors.black54),
                                            Row(
                                              children: <Widget>[

                                                RateProd(_list_producto[position].rated, 1),
                                                subTitleProd("Cant: "+  _list_producto[position].quantity, 1),
                                              ],
                                            )
                                          ],
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                        ),
                                      ),
                                      flex: 2,
                                    )
                                  ],
                                ),
                                padding: EdgeInsets.all(2),
                              ),
                              elevation: 5,
                            );
                          },
                        )),



                      ],
                    ),
                    //fin columna
                  ),
                ),
                physics: ScrollPhysics(),
              ),
            )
          : widget_Cargando(),
    );
  }
}
