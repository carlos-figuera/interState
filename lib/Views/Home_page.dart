import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:one_purina/Models/MMensages.dart';
import 'package:one_purina/Models/M_dealer/M_dealers.dart';
import 'package:one_purina/Models/M_dealer/M_dealersDB.dart';
import 'package:one_purina/Models/M_inventario/M_inventoryDB.dart';
import 'package:one_purina/Models/M_inventario/M_productos.dart';
import 'package:one_purina/Utilidades/Offline.dart';
import 'package:one_purina/Utilidades/Toast_util.dart';
import 'package:one_purina/Utilidades/config.dart';
import 'package:one_purina/Utilidades/widget_globales.dart';
import 'package:one_purina/Views/carrito_pages.dart';
import 'package:one_purina/provider/solicitudes_http.dart';
import 'Drawer_admin.dart';
import 'Inventario_especial_pages/Categorias_especiales_page.dart';
import 'Inventario_pages.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  Solicitud_Http _solicitud_http;
  String Fondo;
  ScrollController _controller;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _ver_Video = false;
  TextStyle SubTitulo = TextStyle(fontWeight: FontWeight.w600, fontSize: 14);
  List<String> _list_pictures = ["assets/logo.jpg"];
  int padding_logo = 5;
  List<M_Producto> _List_products;
  List<Color> _listColorNoti = [
    Colors.green[200],
    Colors.red[100],
    Colors.brown[100]
  ];
  List<Color> _listColorTitle = [
    Colors.green[600],
    Colors.red[600],
    Colors.brown[600]
  ];

  List<MMensages> _listMensages;

  @override
  void initState() {
    super.initState();
    _List_products = new List();
    _listMensages = new List();
    _controller = new ScrollController();
    _solicitud_http = new Solicitud_Http(context: context);
    _solicitud_http.upload_token();
    //getDataDealer();
    getDataInventary();

    getDataMessage();
  }

  Future<bool> _willPopCallback() async {
    return false; // return true if the route to be popped
  }

  @override
  void dispose() {
    super.dispose();
  }

  _Dialo_cantidad_producto({MMensages mensages}) async {
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
                height: screenHeight * 0.6,
                width: screenWidth,
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: <Widget>[
                    TitleDialodCn(name: mensages.title, colo: primaryColor),
                    Container(
                      width: screenWidth,
                      height: screenHeight * 0.4,
                      child: ListView(
                        children: <Widget>[
                          Text(mensages.message)
                        ],

                      ) ),
                    //Botones borra cerrar
                    Container(
                      width: screenWidth,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: MaterialButton(
                              padding: EdgeInsets.symmetric(horizontal:screenWidth * 0.01 ),
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
                          /*  SizedBox(
                            width: screenWidth * 0.01,
                          ),
                         Expanded(
                            child: MaterialButton(
                              shape: shape_boton_p,
                              color: primaryColor,
                              onPressed: () {
                                Navigator.pop(context);

                                new Future.delayed(new Duration(seconds:1), () {
                                  deleteDataMessage( mensages:mensages );
                                });

                              } ,
                              child: Text(
                                "Borrar",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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

  getDataDealer() async {
    String dealerId = await Obtener_data(name: "dealer");
    var resultado = await _solicitud_http.getData(
        api_name: "/dealer/", id: dealerId.toString());
    if (resultado != null) {
      if (resultado['codigo'] == "200") {
        // offLine.guardar_uid(resultado['token']);
        Map<String, dynamic> DealerData = jsonDecode(resultado["datos"]);

        final dealerDb = new M_Dealer.fromJsonBase(DealerData);
        print("id dealer    ${dealerDb.message}");
        // print("Token de usuario  ${Client.
        final userDb = new DealerDb.fromJsonBase(dealerDb.dealerDb);
        print("inventario  ${userDb.inventory}");

        guardar_data(name: "inventario", data: userDb.inventory);
        new Future.delayed(new Duration(seconds: 1), () {
          // Navigator.pushReplacementNamed(context, "HomePage");
        });
      }
    }
  }

  getDataInventary() async {
    //Loads loads = new Loads(context);
    String inventarioId = await Obtener_data(name: "inventario");
    var resultado = await _solicitud_http.getData(
        api_name: "/inventory/", id: inventarioId.toString());
    if (resultado != null) {
      if (resultado['codigo'] == "200") {
        Map<String, dynamic> InventaryData = jsonDecode(resultado["datos"]);
        final inventoryDB =
            new M_InventoryDb.fromJsonBase(InventaryData["inventoryDB"]);
        print("id dealer    ${inventoryDB.products}");

        var List_producto = inventoryDB.products as List;
        _List_products =
            List_producto.map((model) => M_Producto.fromJson(model)).toList();

        setState(() {});
        print("lista de productos  ${_List_products.length}");
      }
    }
  }

  getDataMessage() async {
    var resultado =
        await _solicitud_http.getData(api_name: "/messages", id: "");
    if (resultado != null) {
      if (resultado['codigo'] == "201") {
        Map<String, dynamic> mesagesData = jsonDecode(resultado["datos"]);
        var List_producto = mesagesData["messages"] as List;
        _listMensages =
            List_producto.map((model) => MMensages.fromJson(model)).toList();
        setState(() {});
        print("lista de mensages  ${resultado["datos"]}");
      }
    }
  }

  deleteDataMessage({MMensages mensages}) async {
    var resultado =
    await _solicitud_http.deleteData(api_name: "/message/", id: mensages.id,loa: true);
    if (resultado != null) {
      if (resultado['codigo'] == "201") {
        Map<String, dynamic> mesagesData = jsonDecode(resultado["datos"]);
        var ko = mesagesData["ok"];
        if(ko)
        {
          Toat_mensaje_center(color: 2, mensaje: "El mensaje fue borrado.");
          _listMensages.clear();
          setState(() {});
          getDataMessage();

        } else
          {
            Toat_mensaje_center(
                color: 1, mensaje: "El mensaje no fue borrado.");
          }



      }
    }
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
    final screenOri = MediaQuery.of(context).orientation;
    final screenPortrait = Orientation.portrait;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.all(10),
          child: Image.asset(
            "assets/logo.png",
            fit: BoxFit.contain,
            width: screenWidth * 0.3,
            height: screenHeight * 0.09,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () async {
                String  userDemo= await Obtener_data(name:"userDemo" );
                if(userDemo=="no")
                {

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Carrito_page(tipo_orden: "normal")));
                } else
                {
                  dialoFunsionNoDisp( );

                }

                // getDataDealer();
              })
        ],
      ),
      drawer: Drawer_admin(),
      body: Container(
        color: fondo_body,
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: SafeArea(
                  left: true,
                  top: true,
                  right: true,
                  bottom: true,
                  minimum: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
                  child: Container(
                      height: screenHeight * 0.85,
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Column(
                        children: <Widget>[
                          //  Slider principal
                          /*Container(
                            height: screenHeight * 0.3,
                            child: Swiper(
                              itemBuilder: (BuildContext context, int index) {
                                return new Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 2,
                                  ),
                                  child: _list_pictures.length > 0
                                      ? Card(
                                          child: imagen_asset_plantilla(
                                              url: _list_pictures[index],
                                              h: screenHeight,
                                              w: screenWidth),
                                          elevation: 3,
                                          margin: EdgeInsets.all(0),
                                        )
                                      : Center(
                                          child: new CircularProgressIndicator(
                                            backgroundColor: Colors.white,
                                          ),
                                        ),
                                );
                              },
                              itemCount: _list_pictures.length < 1
                                  ? 1
                                  : _list_pictures.length,
                              viewportFraction: 1,
                              scale: 0.9,
                              pagination: SwiperPagination(
                                  builder: DotSwiperPaginationBuilder(
                                      color: Colors.black)),
                              control:
                                  SwiperControl(color: Colors.black, size: 35),
                              autoplay: false,
                              onTap: (pos) {},
                            ),
                            padding: EdgeInsets.all(0),
                          ),*/

                          Padding(
                            padding: EdgeInsets.only(
                              bottom: 2,
                            ),
                            child: _list_pictures.length > 0
                                ? Card(
                              child: imagen_asset_plantilla(
                                  url: _list_pictures[0],
                                  h: screenHeight,
                                  w: screenWidth),
                              elevation: 3,
                              margin: EdgeInsets.all(0),
                            )
                                : Center(
                              child: new CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),

                          // Titulo menu principal
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Menú principal",
                              style: SubTitulo18,
                              textAlign: TextAlign.left,
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                          // Titulo menu principal
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: GestureDetector(
                                  child: card_home(
                                      assetImg: "assets/iconos/p1.png",
                                      title: "Mi Inventario"),
                                  onTap: ()  {

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Inventario()));


                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => Mis_ordenes ()));
                                  },
                                )),
                                Expanded(
                                    child: GestureDetector(
                                  child: card_home(
                                      assetImg: "assets/iconos/p2.png",
                                      title: "Ordenes Especiales"),
                                  onTap: () {

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Categoria_especial()));
                                    //Navigator.pushReplacementNamed(context, "Orden_especial_page");
                                  },
                                )),
                                Expanded(
                                    child: GestureDetector(
                                  child: card_home(
                                      assetImg: "assets/iconos/p3.png",
                                      title: "Reporte de Ordenes"),
                                  onTap: () async {


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
                                ))
                              ],
                            ),
                            flex: 4,
                          ),
                          //  caratulas  recomendados para ti
                          Container(
                              height: screenHeight * 0.285,
                              margin: EdgeInsets.zero,
                              child: Column(
                                children: <Widget>[
                                  //Titulo recomendados
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      "Notificaciones",
                                      style: SubTitulo18,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  //Fotos  recomendados
                                  Expanded(
                                    child: _listMensages.isEmpty
                                        ? widget_Cargando()
                                        : new Swiper(
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Card(
                                                child: Padding(
                                                    padding: EdgeInsets.all(3),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child:
                                                                  AutoSizeText(
                                                                _listMensages[
                                                                        index]
                                                                    .title,
                                                                minFontSize: 15,
                                                                style: TextStyle(
                                                                    color:
                                                                        _listColorTitle[
                                                                            0],
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        17),
                                                                maxLines: 1,
                                                                textAlign:
                                                                    TextAlign
                                                                        .justify,
                                                              ),
                                                            ),
                                                            Text(
                                                                "${_listMensages[index].createdDate.day}/${_listMensages[index].createdDate.month}/${_listMensages[index].createdDate.year}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black45,
                                                                    fontSize:
                                                                        15))
                                                          ],
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 2,
                                                                    bottom: 2),
                                                            child: AutoSizeText(
                                                              _listMensages[index].message.length > 145 ? _listMensages[index].message + ".Ver más." : _listMensages[index].message,
                                                              minFontSize: 15,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 15),
                                                              maxLines: 4,
                                                              // overflowReplacement: Text(_listMensages[index].message+ "Los clientes van a poder enviar la cantidad de inventario que ellos tienen en stock el día que reciban la notificación del app. Podrán hacer órdenes especiales según lo necesiten o añadir algún modelo de batería que normalmente ellos no trabajan a su próxima orden.  Los vendedores reciben la información de lo que los clientes necesitan el día antes de visitarlos, de esa manera van con el inventario que necesitan y se agiliza el proceso con los clientes.. Ver mas."),
                                                              textAlign:
                                                                  TextAlign
                                                                      .justify,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 14,
                                                        )
                                                      ],
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                    )),
                                                color: _listColorNoti[0],
                                                margin: EdgeInsets.all(5),
                                              );
                                            },
                                            itemCount: _listMensages != null
                                                ? _listMensages.length
                                                : 0,
                                            scale: 0.7,
                                            autoplay: true,
                                            pagination: SwiperPagination(
                                                builder: _listMensages.length >
                                                        14
                                                    ? FractionPaginationBuilder(
                                                        fontSize: 14,
                                                        color: Colors.blueGrey,
                                                        activeFontSize: 16,
                                                        activeColor:
                                                            Colors.black)
                                                    : DotSwiperPaginationBuilder(
                                                        color: Colors.grey,
                                                        activeColor:
                                                            Colors.black,
                                                        activeSize: 12,
                                                      ),
                                                margin:
                                                    EdgeInsets.only(bottom: 5)),
                                            onTap: (v) {
                                              _Dialo_cantidad_producto(
                                                  mensages: _listMensages[v]);
                                            },
                                          ),
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              )),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      )),
                ),
                controller: _controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
