import 'dart:async';
import 'package:flutter/material.dart';
import 'package:one_purina/Models/M_carrito/M_carrito.dart';
import 'package:one_purina/Models/M_ordenes/M_orderDB.dart';
import 'package:one_purina/Utilidades/Load.dart';
import 'package:one_purina/Utilidades/Offline.dart';
import 'package:one_purina/Utilidades/Toast_util.dart';
import 'package:one_purina/Utilidades/config.dart';
import 'package:one_purina/Utilidades/widget_globales.dart';
import 'package:one_purina/provider/db_sqlite.dart';
import 'package:one_purina/provider/solicitudes_http.dart';

class Carrito_page extends StatefulWidget {
  String tipo_orden;

  Carrito_page({this.tipo_orden});

  @override
  Carrito_pageState createState() => new Carrito_pageState();
}

class Carrito_pageState extends State<Carrito_page>
    with WidgetsBindingObserver {
  List<M_Carrito> _list_carrito;
  bool carga = true;
  Loads loads;
  TextStyle SubTitulo = TextStyle(fontWeight: FontWeight.w600, fontSize: 16);
  TextStyle Titulo = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  Solicitud_Http _solicitud_http;

  Db_sqlite db_sqlite = new Db_sqlite();
  String tipo_orden = "normal";
  var _cantidad_item = "";

  upload_data({Map<String, dynamic> data}) async {
    String dealerId = await Obtener_data(name: "dealer");
    _solicitud_http = new Solicitud_Http(context: context);
    var resultado = await _solicitud_http.upload_data(
        api_name: "/order/", id: dealerId, data: data);
    setState(() {
      if (resultado != null) {
        if (resultado["codigo"] == 201) {
          var resBody = resultado["data"];

          Map<String, dynamic> InventaryData = resultado["data"];
          final ordenDB = new M_orderDb.fromJsonBase(InventaryData["orderDB"]);
          print("Todos los productos    ${ordenDB.nOrder}");

          Eliminar_tipo_producto();
          new Future.delayed(new Duration(seconds: 2), () {
            _Dialo_resultado_pedido(DATA: ordenDB);
          });
        } else if (resultado["codigo"] == 401) {
          print("perdio la session");
        }
      }
    });
  }

  ScrollController _controller;
  bool isStopped = false; //global
  int contador = 0;
  int total = 0;

  Acualizar_cantidad_carrito({String tipo}) async {
    _list_carrito = await db_sqlite.getOrdenes(tipo: tipo);
    if (_list_carrito.length > 0) {
      _cantidad_item = "(${_list_carrito.length})";
    } else {
      _cantidad_item = "";
    }

    setState(() {});
  }

  Actualizar_cantidad({int operacion, int pos}) {
    print(_list_carrito[pos].id);
    contador = 0;
    int quantity = int.parse(_list_carrito[pos].quantity);
    contador = quantity;
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (operacion == 1) {
        timer.tick < 100 ? contador++ : contador = contador + 10;
        print(timer.tick);
      } else if (operacion == 2) {
        if (int.parse(_list_carrito[pos].quantity) > 1) {
          timer.tick < 100 ? contador-- : contador = contador - 10;
        } else {
          timer.cancel();
        }
      }
      _list_carrito[pos].quantity = contador.toString();
      setState(() {});
      if (isStopped) {
        timer.cancel();
        db_sqlite.updatetCard(iten_car: _list_carrito[pos]);
      }

      // print("Dekhi $contador sec por por kisu hy ni :/");
    });
  }

  _Dialo_eliminar_producto({int position}) async {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // Declare your variable outside the builder
        return AlertDialog(
          content: StatefulBuilder(
            // You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: screenHeight * 0.17,
                width: screenWidth,
                child: Column(
                  children: <Widget>[
                    TitleProd(
                        "¿Desea eliminar ${_list_carrito[position].partNumber}? "),
                    SizedBox(height: screenWidth * 0.015),
                    Container(
                      width: screenWidth,
                      // padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: MaterialButton(
                              shape: shape_boton_p,
                              color: Colors.grey,
                              onPressed: () => setState(() {
                                Navigator.pop(context);
                              }),
                              child: Text(
                                "Cancelar",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.01,
                          ),
                          Expanded(
                            child: MaterialButton(
                              shape: shape_boton_p,
                              color: Colors.red,
                              onPressed: () => setState(() {
                                Navigator.pop(context);
                                db_sqlite.delete(_list_carrito[position].id);
                                Acualizar_cantidad_carrito(tipo: tipo_orden);
                              }),
                              child: Text(
                                "Eliminar",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  mainAxisSize: MainAxisSize.max,
             mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
              );
            },
          ),
          shape: shape_dialog,
          contentPadding: EdgeInsets.all(screenWidth * 0.05),
        );
      },
    );
  }

  _Dialo_resultado_pedido({M_orderDb DATA}) async {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // Declare your variable outside the builder
        return AlertDialog(
          content: StatefulBuilder(
            // You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: screenHeight * 0.4,
                width: screenWidth,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle_outline,
                        color: primaryColor,
                        size: screenHeight * 0.11,
                      ),
                    ),
                    TitleDialodResul(
                        name:
                            "Tu pedido $tipo_orden con número #${DATA.nOrder}  fue generado con éxito, Dirígete a la sección Mi Inventario para hacer seguimiento  de su estado.",
                        colo: text_Color_SubTitle),
                    SizedBox(height: screenWidth * 0.01),
                    Container(
                      width: screenWidth,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: MaterialButton(
                              shape: shape_boton_p,
                              padding: EdgeInsets.all(1),
                              color: Colors.grey,
                              onPressed: () => setState(() {
                                Navigator.pop(context);
                              }),
                              child: Text(
                                "Cancelar",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ),
                            flex: 2,
                          ),
                          SizedBox(
                            width: screenWidth * 0.01,
                          ),
                          Expanded(
                            child: MaterialButton(
                              shape: shape_boton_p,
                              color: primaryColor,
                              padding: EdgeInsets.all(1),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushReplacementNamed(
                                    context, "Mis_ordenes",
                                    arguments: tipo_orden);
                              },
                              child: Text(
                                "Mi Inventario",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ),
                            flex: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          shape: shape_dialog,
          contentPadding: EdgeInsets.all(screenWidth * 0.04),
        );
      },
    );
  }

  Eliminar_tipo_producto() async {
    var limpiar = await db_sqlite.delete_all(tipo: tipo_orden);
    Acualizar_cantidad_carrito(tipo: tipo_orden);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    db_sqlite.Load();
    _list_carrito = new List();
    loads = new Loads(context);
    _solicitud_http = Solicitud_Http(context: context, loads: loads);
    tipo_orden = widget.tipo_orden;
    Acualizar_cantidad_carrito(tipo: widget.tipo_orden);
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
        title: Text("Carrito", style: Titulo20),
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
                        //Botones tipo de orden
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: screenWidth * 0.01,
                            ),

                            //Boton normal
                            Expanded(
                                child: MaterialButton(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              shape: shape_boton_p,
                              color: tipo_orden == "normal"
                                  ? primaryColor
                                  : Colors.grey,
                              onPressed: () {
                                tipo_orden = "normal";
                                Acualizar_cantidad_carrito(tipo: tipo_orden);
                                setState(() {});
                              },
                              child: Text(
                                "Reporte de Inventario",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )),
                            SizedBox(
                              width: screenWidth * 0.01,
                            ),

                            //Boton especial
                            Expanded(
                                child: MaterialButton(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              shape: shape_boton_p,
                              color: tipo_orden == "especial"
                                  ? textColor1
                                  : textColor2,
                              onPressed: () {
                                tipo_orden = "especial";
                                Acualizar_cantidad_carrito(tipo: tipo_orden);
                                setState(() {});
                              },
                              child: Text(
                                "Reporte Especial",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            )),
                            SizedBox(
                              width: screenWidth * 0.01,
                            ),
                          ],
                        ),

                        //Lista de productos
                        Expanded(
                            child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          // itemCount: _List_products == null ? 0 : _List_products.length,
                          itemCount: _list_carrito.length,
                          itemBuilder: (context, position) {
                            print(_list_carrito[position].img);
                            return Card(
                              child: Padding(
                                child: Row(
                                  children: <Widget>[
                                    /* Expanded(
                                      child: imagen_cache_plantilla(
                                          url: _list_carrito[position].img),
                                      //  url: "https://interstate-pr.herokuapp.com/api/images/users/" +_list_carrito[position].img),
                                      flex: 1,
                                    ),*/
                                    Expanded(
                                      child: Container(
                                        height: screenHeight * 0.2,
                                        child: Column(
                                          children: <Widget>[
                                            TitleProd(
                                                _list_carrito[position].partNumber),
                                            subTitleProd(
                                                _list_carrito[position]
                                                    .description,
                                                1),
                                            Row(
                                              children: <Widget>[
                                                //restar
                                                Container(
                                                  decoration: new BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(10),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10)),
                                                    color:
                                                        tipo_orden == "especial"
                                                            ? textColor1
                                                            : primaryColor,
                                                  ),
                                                  height: screenHeight * 0.06,
                                                  width: screenWidth * 0.16,
                                                  child: GestureDetector(
                                                    onPanCancel: () {
                                                      print('pan cancel');
                                                      isStopped = true;
                                                      setState(() {});
                                                    },
                                                    onPanDown: (_) {
                                                      isStopped = false;
                                                      setState(() {});
                                                      Actualizar_cantidad(
                                                          operacion: 2,
                                                          pos: position);
                                                    },
                                                    child: Center(child:Text(
                                                      "-",
                                                      style: TextStyle(
                                                          fontSize: 32,
                                                          color: Colors.white,
                                                          fontWeight:
                                                          FontWeight.w900),
                                                      textAlign:
                                                      TextAlign.center,
                                                    )),
                                                  ),
                                                ),

                                                //Cantidad
                                                Container(
                                                    color: Colors.grey,
                                                    height: screenHeight * 0.06,
                                                    width: contador > 1000
                                                        ? screenWidth * 0.18
                                                        : screenWidth * 0.19,
                                                    child: Center(
                                                      child: Text(
                                                        _list_carrito[position]
                                                            .quantity,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    )),

                                                //Sumar
                                                Container(
                                                  decoration: new BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomRight: Radius
                                                                .circular(10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10)),
                                                    color:
                                                        tipo_orden == "especial"
                                                            ? textColor1
                                                            : primaryColor,
                                                  ),
                                                  height: screenHeight * 0.06,
                                                  width: screenWidth * 0.16,
                                                  child: GestureDetector(
                                                    onPanCancel: () {
                                                      print('pan cancel');
                                                      isStopped = true;
                                                      setState(() {});
                                                    },
                                                    onPanDown: (_) {
                                                      isStopped = false;
                                                      setState(() {});
                                                      print('pan down');
                                                      Actualizar_cantidad(
                                                          operacion: 1,
                                                          pos: position);
                                                    },
                                                    child:Center(child:  Text(
                                                      "+",
                                                      style: TextStyle(
                                                          fontSize: 32,
                                                          color: Colors.white,
                                                          fontWeight:
                                                          FontWeight.w900),
                                                      textAlign:
                                                      TextAlign.center,
                                                    )),
                                                  ),
                                                ),

                                                   Expanded(child:  SizedBox()),

                                                ExcludeSemantics(
                                                    child: FlatButton.icon(
                                                        onPressed: () {
                                                          _Dialo_eliminar_producto(
                                                              position:
                                                              position);
                                                        },
                                                        icon: Icon(
                                                          Icons.delete_forever,
                                                          color: Colors.red,
                                                        ),

                                                        label: Text("Borrar"))),
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
                        Container(
                          width: screenWidth,
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05),
                          child: MaterialButton(
                            shape: shape_boton_p,
                            color: tipo_orden == "especial"
                                ? textColor1
                                : primaryColor,
                            onPressed: () => setState(() {
                              if (_list_carrito.length > 0) {
                                Map<String, dynamic> paload_carrito;
                                paload_carrito = {
                                  "products": [],
                                  "type": tipo_orden
                                };
                                //Iterar entre la lista de productos y agregarlos a nuestro Map paload_carrito
                                var listMap = _list_carrito
                                    .map((ingreso) => ingreso.toJson());
                                paload_carrito['products'].addAll(listMap);
                                print('${listMap}');
                                print('${paload_carrito}');
                                upload_data(data: paload_carrito);
                              } else {
                                Toat_mensaje_center(
                                    color: 1,
                                    mensaje:
                                        "El carrito  está vacío, agrega productos antes de enviar.");
                              }
                            }),
                            child: Text(
                              "Someter Inventario $_cantidad_item",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
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
