import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:one_purina/Models/M_carrito/M_carrito.dart';
import 'package:one_purina/Models/M_inventario/M_categorias.dart';
import 'package:one_purina/Models/M_inventario/M_inventoryDB.dart';
import 'package:one_purina/Models/M_inventario/M_productos.dart';
import 'package:one_purina/Utilidades/Load.dart';
import 'package:one_purina/Utilidades/Offline.dart';
import 'package:one_purina/Utilidades/Toast_util.dart';
import 'package:one_purina/Utilidades/componentes/formularios/fomulario.dart';
import 'package:one_purina/Utilidades/config.dart';
import 'package:one_purina/Utilidades/widget_globales.dart';
import 'package:one_purina/Views/carrito_pages.dart';
import 'package:one_purina/provider/db_sqlite.dart';
import 'package:one_purina/provider/solicitudes_http.dart';

class Inventario_especial extends StatefulWidget {
  M_Categorias m_categorias;

  Inventario_especial({this.m_categorias});

  @override
  Inventario_especialState createState() => new Inventario_especialState();
}

class Inventario_especialState extends State<Inventario_especial>
    with WidgetsBindingObserver {
  List<M_Producto> _List_products;
  List<M_Carrito> _list_carrito;
  String _cantidad_item = "";
  Formularios _formularios;
  TextEditingController _CantidadController = new TextEditingController();
  final FocusNode _cantidad = FocusNode();
  final FocusNode _fake = FocusNode();
  bool carga = true;
  Loads loads;
  Solicitud_Http _solicitud_http;
  ScrollController _controller;
  final _formKey = GlobalKey<FormState>();

  Db_sqlite db_sqlite = new Db_sqlite();

  Acualizar_cantidad_carrito({String tipo}) async {
    _list_carrito = await db_sqlite.getOrdenes(tipo: tipo);
    // _list_carrito=await db_sqlite.getList(   );
    if (_list_carrito.length > 0) {
      _cantidad_item = "(${_list_carrito.length})";
    }
    setState(() {});
  }

  getDataDealer() async {
    print(widget.m_categorias);

    var List_producto = widget.m_categorias.products as List;
    _List_products =
        List_producto.map((model) => M_Producto.fromJson(model)).toList();
    carga = false;
    setState(() {});
    // final products= new DealerDb(inventoryDB.products);
    print("lista de productos  ${_List_products.length}");
  }

  bool isStopped = false; //global
  int contador = 0;
  int total = 0;

  sec5Timer(int operacion) {
    //contador = 0;
    Timer.periodic(Duration(milliseconds: 80), (timer) {
      operacion == 1 ? contador++ : contador--;
      setState(() {});
      if (isStopped) {
        timer.cancel();
      }

      print("Dekhi $contador sec por por kisu hy ni :/");
    });
  }

  _Dialo_cantidad_producto({String name, int position}) async {
    _CantidadController.text = "";
    // db_sqlite.delete_all();
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final screenOri = MediaQuery.of(context).orientation;
    final screenPortrait = Orientation.portrait;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // Declare your variable outside the builder
        return AlertDialog(
          content: StatefulBuilder(
            // You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: screenHeight * 0.23,
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: <Widget>[
                    TitleProd(name),
                    Container(
                      //width: screenWidth * 0.5,
                      height: screenHeight * 0.09,
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
                      child: Form(
                          child: _formularios.campo_cantidad(
                              currentFocus: _cantidad,
                              nextFocus: _fake,
                              nombre: 'Cantidad',
                              fina: true,
                              numeros: true,
                              flex: 2,
                              nombreController: _CantidadController),
                          key: _formKey),
                    ),
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
                              color: primaryColor,
                              onPressed: () => setState(() {
                                if (_formKey.currentState.validate()) {
                                  Navigator.pop(context);

                                  db_sqlite.insert(
                                      id: _List_products[position].id,
                                      brand: _List_products[position].brand,
                                      description:
                                          _List_products[position].description,
                                      img: _List_products[position].brand,
                                      part_number:
                                          _List_products[position].partNumber.toString(),
                                      quantity: _CantidadController.text,
                                      tipo: "especial");
                                  Acualizar_cantidad_carrito(tipo: "especial");

                                  Toat_mensaje(
                                      color: 2,
                                      mensaje:
                                          "El producto se agregó al carrito con éxito.",
                                      graviti: 2);
                                }
                              }),
                              child: Text(
                                "Agregar",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          contentPadding: EdgeInsets.all(screenWidth * 0.03),
          shape: shape_dialog,
        );
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    db_sqlite.Load();
    _formularios = new Formularios(context: context);
    loads = new Loads(context);
    _solicitud_http = Solicitud_Http(context: context, loads: loads);
    _List_products = new List();
    _list_carrito = new List();
    getDataDealer();
    Acualizar_cantidad_carrito(tipo: "especial");
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
      body: carga == false
          ? Container(
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
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              // itemCount: _List_products == null ? 0 : _List_products.length,
                              itemCount: _List_products.length,
                              itemBuilder: (context, position) {
                                return Card(
                                  child: Padding(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: imagen_asset_plantilla(
                                              url:
                                                  "https://interstate-pr.herokuapp.com/api/images/users/" +
                                                      _List_products[position]
                                                          .partNumber.toString()),
                                          flex: 1,
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: screenHeight * 0.2,
                                            child: Column(
                                              children: <Widget>[
                                                TitleProd(
                                                    _List_products[position]
                                                        .brand),
                                                subTitleProd(

                                                    _List_products[position]
                                                        .description,
                                                    2),
                                                //subTitleProd("Parte: ",  _List_products[position].partNumber,1),
                                                Row(
                                                  children: <Widget>[
                                                    //  subTitleProd("Parte: ", _List_products[position].partNumber, 1),
                                                    RateProd(
                                                        _List_products[position]
                                                            .rated,
                                                        1),
                                                    Container(
                                                      height:
                                                          screenHeight * 0.05,
                                                      width: screenWidth * 0.25,
                                                      padding: EdgeInsets.only(
                                                          right: 2),
                                                      child: FlatButton.icon(
                                                        shape: shape_boton_p,
                                                        color: primaryColor,
                                                        onPressed: () {
                                                          _Dialo_cantidad_producto(
                                                              name: _List_products[
                                                                      position]
                                                                  .brand,
                                                              position:
                                                                  position);
                                                        },
                                                        label: Text(""),
                                                        icon: Icon(
                                                          Icons
                                                              .add_shopping_cart,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
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
                                    padding: EdgeInsets.all(1),
                                  ),
                                  elevation: 5,
                                );
                              },
                            ),
                          ),
                          Container(
                            width: screenWidth,
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05),
                            child: MaterialButton(
                              shape: shape_boton_p,
                              color: primaryColor,
                              onPressed: () => setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Carrito_page(
                                            tipo_orden: "especial")));
                              }),
                              child: Text(
                                "Revisar Inventario ${_cantidad_item}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      )

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
