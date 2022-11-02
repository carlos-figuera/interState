import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_purina/Models/M_carrito/M_carrito.dart';
import 'package:one_purina/Models/M_dealer/M_dealers.dart';
import 'package:one_purina/Models/M_dealer/M_dealersDB.dart';
import 'package:one_purina/Models/M_inventario/M_productos.dart';
import 'package:one_purina/Models/M_ordenes/M_ordenes.dart';
import 'package:one_purina/Utilidades/Load.dart';
import 'package:one_purina/Utilidades/Offline.dart';
import 'package:one_purina/Utilidades/config.dart';
import 'package:one_purina/Utilidades/widget_globales.dart';
import 'package:one_purina/Views/Ordenes_pages/Detalle_Reporte_Ordenes_page.dart';
import 'package:one_purina/provider/db_sqlite.dart';
import 'package:one_purina/provider/solicitudes_http.dart';

class Mis_ordenes extends StatefulWidget {
  @override
  Mis_ordenesState createState() => new Mis_ordenesState();
}

class Mis_ordenesState extends State<Mis_ordenes> with WidgetsBindingObserver {
  List<M_orden> _List_ordenes;
  List<M_orden> _List_ordenes_todos;
  List<M_Carrito> _list_carrito;
  List<M_Producto> List_products;
  String _cantidad_item = "";
  bool carga = true;
  Loads loads;
  TextStyle SubTitulo = TextStyle(fontWeight: FontWeight.w600, fontSize: 16);
  TextStyle Titulo = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  Solicitud_Http _solicitud_http;

  final _formKey = GlobalKey<FormState>();
  Db_sqlite db_sqlite = new Db_sqlite();
  String tipo_orden;

  getDataDealer() async {
    Loads loads = new Loads(context);
    String dealerId = await Obtener_data(name: "dealer");
    var resultado = await _solicitud_http.getData(
        api_name: "/dealer/", id: dealerId.toString());
    if (resultado != null) {
      if (resultado['codigo'] == "200") {
        // offLine.guardar_uid(resultado['token']);
        Map<String, dynamic> DealerData = jsonDecode(resultado["datos"]);

        final dealerDb = new M_Dealer.fromJsonBase(DealerData);
        print("id dealer    ${dealerDb.message}");

        final userDb = new DealerDb.fromJsonBase(dealerDb.dealerDb);
        print("ordenes  ${userDb.orders}");
        var List_poden = userDb.orders as List;
        _List_ordenes_todos =
            List_poden.map((model) => M_orden.fromJson(model)).toList();
        filtrar_orden();
        carga = false;
        setState(() {});
      }else{
        carga = false;
        setState(() {});
      }
    }
  }

  filtrar_orden() async {
    _List_ordenes.clear();
    _List_ordenes_todos.forEach((snapshot) {
      if (snapshot.type == tipo_orden) {
        _List_ordenes.add(snapshot);
      }
    });
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    _list_carrito = new List();
    List_products = new List();
    loads = new Loads(context);
    _solicitud_http = Solicitud_Http(context: context, loads: loads);
    _List_ordenes = new List();
    _List_ordenes_todos = new List();
    getDataDealer();
    db_sqlite.Load();
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
    String Tipo_Ord = ModalRoute.of(context).settings.arguments;
    if (tipo_orden == null) {
      tipo_orden = Tipo_Ord;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:TitleappBar( TITLE:"Reporte de Ordenes")  ,
        centerTitle: true,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace),
          padding: EdgeInsets.only(bottom: 4),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "HomePage");
          },
        ),
      ),
      body: carga == false
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
                                  filtrar_orden();
                                  setState(() {});
                                },
                                child: Text(
                                  "Reporte de Inventario",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
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
                                  filtrar_orden();
                                  setState(() {});
                                },
                                child: Text(
                                  "Reporte Especial",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                              SizedBox(
                                width: screenWidth * 0.01,
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              // itemCount: _List_products == null ? 0 : _List_products.length,
                              itemCount: _List_ordenes.length,
                              //reverse: true,
                              itemBuilder: (context, position) {
                                DateTime now = DateTime.now();
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd – kk:mm').format(
                                        _List_ordenes[position].createdDate);

                                return Card(
                                  child: Padding(
                                    child: ListTile(
                                        title: Row(
                                          children: <Widget>[
                                            TitleProd(
                                                "# ${_List_ordenes[position].n_order.toString()}"),
                                            subTitleProdsNoE(
                                                data: formattedDate,
                                                color: Colors.grey,
                                                direc: 2)
                                          ],
                                        ),
                                        subtitle: Row(
                                          children: <Widget>[
                                            subTitleProdsNoE(
                                                data: _List_ordenes[position]
                                                    .type,
                                                color: Colors.grey,
                                                direc: 1),
                                            ExcludeSemantics(
                                              child: Container(
                                                width: screenWidth * 0.23,
                                                height: screenHeight * 0.06,
                                                child: MaterialButton(
                                                  shape: shape_boton_p,
                                                  color:
                                                      tipo_orden == "especial"
                                                          ? textColor1
                                                          : primaryColor,
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Detalle_page(
                                                                    m_orden:
                                                                        _List_ordenes[
                                                                            position])));
                                                  },
                                                  child: Text(
                                                    "Ver",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    padding: EdgeInsets.all(2),
                                  ),
                                  elevation: 5,
                                );
                              },
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
