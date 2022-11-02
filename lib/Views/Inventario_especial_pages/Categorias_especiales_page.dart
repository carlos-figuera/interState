import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:one_purina/Models/M_carrito/M_carrito.dart';
import 'package:one_purina/Models/M_inventario/M_categorias.dart';
import 'package:one_purina/Models/M_inventario/M_inventoryDB.dart';
import 'package:one_purina/Models/M_inventario/M_productos.dart';
import 'package:one_purina/Models/M_producto.dart';
import 'package:one_purina/Utilidades/Load.dart';
import 'package:one_purina/Utilidades/Offline.dart';
import 'package:one_purina/Utilidades/Toast_util.dart';
import 'package:one_purina/Utilidades/componentes/formularios/fomulario.dart';
import 'package:one_purina/Utilidades/config.dart';
import 'package:one_purina/Utilidades/widget_globales.dart';
import 'package:one_purina/Views/carrito_pages.dart';
import 'package:one_purina/provider/db_sqlite.dart';
import 'package:one_purina/provider/solicitudes_http.dart';

import 'Inventario_especial_page.dart';

class Categoria_especial extends StatefulWidget {
  @override
  Categoria_especialState createState() => new Categoria_especialState();
}

class Categoria_especialState extends State<Categoria_especial>
    with WidgetsBindingObserver {
  List<M_Categorias> _List_categoria;
  bool carga = true;
  Loads loads;
  TextStyle SubTitulo = TextStyle(fontWeight: FontWeight.w600, fontSize: 16);
  TextStyle Titulo = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
  Solicitud_Http _solicitud_http;

  String _cantidad_item = "";
  Formularios _formularios;
  TextEditingController _CantidadController = new TextEditingController();
  final FocusNode _cantidad = FocusNode();
  final FocusNode _fake = FocusNode();

  Db_sqlite db_sqlite = new Db_sqlite();
  bool isStopped = false; //global
  int contador = 0;
  String nombre_catgoria = "Todos los productos";
  int total = 0;
  List<M_Producto> _List_products;
  List<M_Carrito> _list_carrito;
  final _formKey = GlobalKey<FormState>();
  String id_select="";

  Acualizar_cantidad_carrito({String tipo}) async {
    _list_carrito = await db_sqlite.getOrdenes(tipo: tipo);
    // _list_carrito=await db_sqlite.getList(   );
    if (_list_carrito.length > 0) {
      _cantidad_item = "(${_list_carrito.length})";
    }
    setState(() {});
  }

  getCategoriaProductos(M_Categorias m_categorias) async {
    var List_producto = m_categorias.products as List;
    _List_products =
        List_producto.map((model) => M_Producto.fromJson(model)).toList();
    carga = false;
    setState(() {});
    // final products= new DealerDb(inventoryDB.products);
    print("lista de productos  ${_List_products.length}");
  }

  getAllProductos(List<M_Categorias> _listcategori) async {
    List<M_Producto> _List_produt_Temp = new List();
    _listcategori.forEach((snapshot) {
      print(snapshot.name);
      var List_producto = snapshot.products as List;
      _List_produt_Temp =
          List_producto.map((model) => M_Producto.fromJson(model)).toList();
      _List_products.addAll(_List_produt_Temp);
    });

    print("lista de productos  ${_List_products.length}");
  }

  _Dialo_cantidad_producto({M_Producto m_producto }) async {
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
                height: screenHeight * 0.26,
                width: screenWidth,
                padding: EdgeInsets.symmetric(horizontal:0),
                child: Column(
                  children: <Widget>[
                    TitleDialodCn(name: m_producto.partNumber,colo: primaryColor),

                    Container(
                      //width: screenWidth * 0.5,
                      height: screenHeight * 0.09,
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
                      child: Form(
                          child: _formularios.campo_cantidad(
                              currentFocus: _cantidad,
                              nextFocus: _fake,
                              nombre: 'Cantidad',
                              fina: true,
                              numeros: true,
                              flex: 2,
                              nombreController: _CantidadController),key:_formKey ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
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
                                if(_formKey.currentState.validate())
                                {
                                  Navigator.pop(context);

                                  db_sqlite.insert(
                                      id: m_producto .id,
                                      brand: m_producto.brand,
                                      description:
                                      m_producto.description,
                                      img:img_defaul,
                                      part_number:
                                      m_producto.partNumber.toString(),
                                      quantity: _CantidadController.text,
                                      tipo: "especial",
                                      group:  m_producto.group.toString(),
                                      rated: m_producto.rated.toString(),cca: m_producto.cca
                                  );
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
  dialoDetallepProducto({M_Producto m_producto }) async {
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
                height: screenHeight * 0.6,
                width: screenWidth,
                padding: EdgeInsets.symmetric(horizontal:5),
                child: Column(
                  children: <Widget>[
                    new Container(
                      padding:EdgeInsets.all(screenHeight * 0.01) ,
                      height: screenHeight * 0.25,
                      width: screenWidth,
                      child: Image.asset( 'assets/iconbateria.jpg' ,
                        fit: BoxFit.cover,
                      ),),
                    SizedBox(height: screenHeight * 0.01),


                    TitleDialodCn(name: m_producto.partNumber,colo: primaryColor  ),
                    subTitleProd("Descripción:"+ m_producto.description,2),
                    //subTitleProdsNoE( data:"Description :  dos lineas" + _List_products[position].description,direc: 1,color: Colors.black54),
                    subTitleProdsNoE( data:"Grupo:"+m_producto.group,direc: 1,color: Colors.black54),
                    //subTitleProdsNoE( data:"Numero de Parte: "+_List_products[position].partNumber,direc: 1,color: Colors.black54),
                    subTitleProdsNoE( data:"CCA:"+m_producto.cca.toString(),direc: 1,color: Colors.black54),
                    subTitleProdsNoE( data:"CA:"+m_producto.ca.toString(),direc: 1,color: Colors.black54),
                    RateProd(m_producto.rated, 1),
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
                              Navigator.pop(context);
                              _Dialo_cantidad_producto(m_producto: m_producto);
                            },
                            child: Text(
                              "Añadir cantidad",style: TextStyle(color: Colors.white),),
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

  getDataDealer() async {
    //Loads loads = new Loads(context);
    String inventarioId = await Obtener_data(name: "inventario");
    var resultado = await _solicitud_http.getData(
        api_name: "/inventory/", id: inventarioId.toString());
    if (resultado != null) {
      if (resultado['codigo'] == "200") {
        // offLine.guardar_uid(resultado['token']);
        Map<String, dynamic> InventaryData = jsonDecode(resultado["datos"]);
        final inventoryDB =
            new M_InventoryDb.fromJsonBase(InventaryData["inventoryDB"]);
        var dealerDB = inventoryDB.dealer["categories"] as List;
        _List_categoria =
            dealerDB.map((model) => M_Categorias.fromJson(model)).toList();
        getCategoriaProductos(_List_categoria[0]);
        getAllProductos(_List_categoria);
        carga = false;

        setState(() {});

        // final products= new DealerDb(inventoryDB.products);
        print("  _List_categoria  ${_List_categoria.length}");
      }else{
        carga = false;
        setState(() {});
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
                              guardar_data(name:"userDemo", data: "no");
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
  ScrollController _controller;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    loads = new Loads(context);
    _solicitud_http = Solicitud_Http(context: context, loads: loads);
    _List_categoria = new List();
    getDataDealer();
    db_sqlite.Load();
    _formularios = new Formularios(context: context);
    _List_products = new List();
    _list_carrito = new List();

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
      appBar: AppBar(
        title:TitleappBar( TITLE:"Ordenes Especiales")  ,
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace),
          padding: EdgeInsets.only(bottom: 4),
          onPressed: () {
            //Navigator.pushReplacementNamed(context, "HomePage");
            Navigator.pop(context);
          },
        ),
      ),
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
                      color: fondo_body,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          TitleSec(name: "Categorías"),
                          Container(
                            height: screenHeight * 0.1,
                            //color: Colors.red,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              // itemCount: _List_products == null ? 0 : _List_products.length,
                              itemCount: _List_categoria.length,
                              itemBuilder: (context, position) {
                                String img = _List_categoria[position].img !=
                                        null
                                    ? "https://interstate-pr.herokuapp.com/api/images/users/" +
                                        _List_categoria[position].img
                                    : "https://rpautopartes.com/wp-content/uploads/2020/09/bateria-interstate-300x300.jpg";
                                return Container(
                                  child: ListTile(
                                    //Categorias
                                    title: Card(
                                      child: Column(
                                        children: <Widget>[

                                          TitleCategoria(
                                              data: _List_categoria[position]
                                                  .name,
                                              color: primaryColor,
                                              fle: 1)
                                        ],
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                      ),
                                      elevation: 5,
                                      margin: EdgeInsets.symmetric( horizontal: 2,vertical: 3),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          side: BorderSide(color:_List_categoria[position].id==id_select? primaryColor:Colors.transparent, width: 2)) ,
                                    ),
                                    onTap: () {
                                      id_select=_List_categoria[position].id;
                                      nombre_catgoria = _List_categoria[position].name;
                                      getCategoriaProductos(_List_categoria[position]);
                                      print(_List_categoria[position].name);
                                      setState(() {});
                                    },
                                    contentPadding: EdgeInsets.all(0),


                                  ),

                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => Inventario_especial(m_categorias:_List_categoria[position])));
                                  // elevation: 5,
                                  width: screenWidth * 0.4,
                                  padding: EdgeInsets.only(bottom: 5),
                                );
                              },
                            ),
                          ),

                          //Todos  los productos
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          TitleSec(name: nombre_catgoria),
                          //lista de productos

                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              // itemCount: _List_products == null ? 0 : _List_products.length,
                              itemCount: _List_products.length,
                              itemBuilder: (context, position) {
                                return Card(
                                  child: GestureDetector(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: imagen_asset_plantilla(url:"assets/iconbateria.jpg"),
                                          flex: 2,
                                        ),

                                        Expanded(
                                          child: Container(
                                            height: screenHeight * 0.25,
                                            child: Column(
                                              children: <Widget>[
                                                TitleProd(_List_products[position].partNumber),
                                                subTitleProd( _List_products[position].description,2),
                                                //subTitleProdsNoE( data:"Description :  dos lineas" + _List_products[position].description,direc: 1,color: Colors.black54),
                                                subTitleProdsNoE( data:"Grupo: "+_List_products[position].group,direc: 1,color: Colors.black54),
                                                //subTitleProdsNoE( data:"Numero de Parte: "+_List_products[position].partNumber,direc: 1,color: Colors.black54),
                                                subTitleProdsNoE( data:"CCA: "+_List_products[position].cca.toString(),direc: 1,color: Colors.black54),
                                                subTitleProdsNoE( data:"CA: "+_List_products[position].ca.toString(),direc: 1,color: Colors.black54),
                                                Row(
                                                  children: <Widget>[
                                                    Expanded(child: Text( "")),
                                                    Expanded(
                                                      child: FlatButton(
                                                        shape: shape_boton_p,
                                                        color: primaryColor,
                                                        padding: EdgeInsets.all(0),
                                                        onPressed: () async {

                                                          String  userDemo= await Obtener_data(name:"userDemo" );
                                                          if(userDemo=="no")
                                                          {

                                                            _Dialo_cantidad_producto(m_producto: _List_products[position] );


                                                          } else
                                                          {
                                                            dialoFunsionNoDisp( );

                                                          }


                                                        },
                                                        child: Text(
                                                          "Añadir cantidad",style: TextStyle(color: Colors.white),),
                                                        /*icon: Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                        ),*/
                                                      ),flex: 3,)


                                                  ],
                                                )
                                              ],
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                            ),
                                          ),
                                          flex: 5,
                                        )
                                      ],
                                    ),
                                    onTap: (){
                                      dialoDetallepProducto( m_producto:_List_products[position]  ) ;
                                    },
                                  ),
                                  elevation: 5,
                                );
                              },
                            ),
                          ),

                          // Boton para ir al carrito
                          Container(
                            width: screenWidth,
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05),
                            child: MaterialButton(
                              shape: shape_boton_p,
                              color: primaryColor,
                              onPressed: () => setState(() async {

                                String  userDemo= await Obtener_data(name:"userDemo" );
                                if(userDemo=="no")
                                {


                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Carrito_page(
                                              tipo_orden: "especial")));


                                } else
                                {
                                  dialoFunsionNoDisp( );

                                }

                              }),
                              child: Text(
                                "Revisar Inventario ${_cantidad_item}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
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
