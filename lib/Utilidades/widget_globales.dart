import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:one_purina/Models/M_inventario/M_productos.dart';
import 'config.dart';

String url_foto_defaul =
    "https://firebasestorage.googleapis.com/v0/b/candy-disco.appspot.com/o/recursos%2Ffondo_t_sin_imagen.jpeg?alt=media&token=ddf6c410-b4c8-451e-bbfd-dbd15b4b70ac";

Widget widget_Cargando() {
  return Center(
    child: new CircularProgressIndicator(
      backgroundColor: primaryColor,
      valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
    ),
  );
}



Widget imagen_asset_plantilla({String url, double h, double w}) {
  return Image.asset(
    url,
    fit: BoxFit.contain,
  );
}

Widget card_home({String assetImg, String title}) {
  return Card(
    elevation: 1,
   // color: primaryColor,
    child: Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(2),
            child: Image.asset(
              assetImg,
              fit: BoxFit.contain,
            ),
          ),
          flex: 5,
        ),
        SizedBox(height: 2),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
                fontSize: 14, color: primaryColor, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          flex: 3,
        )
      ],
    ),
  );
}
Widget card_recomendado({M_Producto m_producto}) {
  return Card(
    elevation: 1,
    color: Colors.white,
    child: Column(
      children: <Widget>[
        TitleRecomendado(m_producto.brand),
        SizedBox(height: 5),
        RateProd(m_producto.rated,1 )
      ],
      //crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    ),
  );
}
Widget icon_buton(int tipo) {
  return Icon(
    tipo == 1 ? Icons.camera : Icons.add_a_photo,
    color: primaryColor,
    size: 20.0,
  );
}

Widget label_buton(int tipo) {
  String nombre = tipo == 1 ? "Tomar foto  " : "Abrir galería";
  return Text(nombre);
}

Widget title_dialog() {
  return Text(
    'Seleciona un medio ',
    textAlign: TextAlign.center,
  );
}



final String assetName = 'assets/logo.svg';



Widget subTitleProd( String data, int fle) {
  // "assets/icon_svgs/cartelera.svg",
  return Expanded(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      child:  AutoSizeText(
        data,
        minFontSize: 13,
        style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize:data.length>30? 14:16,
            color: Colors.black54),
        maxLines: 2,
        textAlign: TextAlign.left,
      ),
    ),
    flex:data.length>30?fle: 1,
  );
}

Widget TitleCategoria({ String data, int fle, Color color}) {
  return ExcludeSemantics(
    child: Padding(
      padding: EdgeInsets.symmetric(  horizontal: 2,vertical: 2),
      child:  AutoSizeText(
        data.toUpperCase() ,
        minFontSize: 13,
        style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: color),
        maxLines: 2,
        textAlign: TextAlign.center,

      ),
    ),
  //  flex: fle,
  );
}
Widget subTitleProdsNoE({ String data,Color color,int direc}) {
  return Expanded(
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 4,vertical: 2
      ),
      child:  AutoSizeText(
        data,
        minFontSize: 12,
        style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: color),
        maxLines: 1,
        textAlign:direc==1?TextAlign.left: TextAlign.right,
      ),
    ),

  );
}
Widget RateProd(String data, int fle) {
  // "assets/icon_svgs/cartelera.svg",
  return Expanded(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
      child: Row(
        children: <Widget>[
          ExcludeSemantics(
            child: Icon(
              Icons.star,
              color: Colors.yellowAccent,size: 20,
            ),
          ),
          SizedBox(width: 3,),
          ExcludeSemantics(
              child: AutoSizeText(
            data,
            minFontSize: 9,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black54),
            maxLines: 1,

            textAlign: TextAlign.left,
          ))
        ],
      ),
    ),
    flex: fle,
  );
}

Widget TitleProd(String name) {
  // "assets/icon_svgs/cartelera.svg",
  return ExcludeSemantics(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: AutoSizeText(
        name,
        minFontSize: 15,
        style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 17,

            color: primaryColor),
        maxLines: 1,

        textAlign: TextAlign.left,
      ),
    ),
    //flex: 2,
  );
}
Widget TitleRecomendado(String name) {
  // "assets/icon_svgs/cartelera.svg",
  return Expanded(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: AutoSizeText(
        name,
        minFontSize: 12,
        style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 14,
            color: primaryColor),
        maxLines: 2,
     softWrap:true ,
        textAlign: TextAlign.center,
      ),
    ),
    //flex: 2,
  );
}
Widget TitleDialodCn({String name,Color colo }) {
  return Expanded(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      child: AutoSizeText(
        name,
        minFontSize: 17,
        style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: colo),
        maxLines:1,
        textAlign: TextAlign.justify,
      ),
    ),
     flex: 1,
  );
}
Widget TitleDialodResul({String name,Color colo }) {
  return Expanded(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      child: AutoSizeText(
        name,
        minFontSize: 15,
        style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            height: 1.1,
            color: colo),
        maxLines:6,
        textAlign: TextAlign.justify,
      ),
    ),
    flex: 1,
  );
}
Widget TitleSec({String name}) {
  // "assets/icon_svgs/cartelera.svg",
  return ExcludeSemantics(
    child: Padding(
      padding: EdgeInsets.all(5),
      child: AutoSizeText(
        name.toUpperCase(),
        minFontSize: 16,
        style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 17,
            color: primaryColor),
        maxLines: 2,
        textAlign: TextAlign.left,
      ),
    ),
  );
}

Widget TitleappBar({String TITLE}) {
  // "assets/icon_svgs/cartelera.svg",
  return AutoSizeText(
    TITLE,
    minFontSize: 13,
    style:   Titulo20,
    maxLines: 2,
    textAlign: TextAlign.center,
  );
}

Widget TitleDialog(String name) {
  // "assets/icon_svgs/cartelera.svg",
  return AutoSizeText(
    name,
    minFontSize: 13,
    style: TextStyle(
        fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
    maxLines: 2,
    textAlign: TextAlign.center,
  );
}
