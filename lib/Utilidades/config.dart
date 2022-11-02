import 'package:flutter/material.dart';

const String img_defaul="https://rpautopartes.com/wp-content/uploads/2020/09/bateria-interstate-300x300.jpg";
const Color primaryColor = Color(0xFF62BB46);
const Color primaryColor1 = Color(0xFF008833);
const Color primaryColor2 = Color(0xFF117737);
const Color secondaryColor = Color(0xFFED1C29);
const Color accentColor = Color(0xFF0D366C);
Color bodyColor = Color(0xff393939);
const Color ratingColor = Colors.teal;
//Color text_Color =Color(0xff008833) ;


//PRINT BRAND COLORS




Color textColor1 =Colors.black87 ;
Color textColor2 =Color.fromRGBO(104, 104, 102, 10) ;
Color textColor3 =Color.fromRGBO(172, 156, 99, 10) ;
Color textColor4 =Color.fromRGBO(172, 175, 176, 10);

const double font_titulo = 18;
const double font_subtitulo = 16;
const double font_nombre = 14;
const double font_texto = 12;

Color text_Color_SubTitle =Colors.black54 ;
const Color fondo_body = Color.fromARGB(240, 240, 240, 240);

String ulr_base = "https://interstate-pr.herokuapp.com/api";
 TextStyle SubTitulo14 = TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textColor1);
 TextStyle SubTitulo16 = TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: textColor1);
TextStyle SubTitulo18 = TextStyle(fontWeight: FontWeight.w600, fontSize: 18 ,color: textColor1);
TextStyle Titulo20 = TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white);
ShapeBorder shape_boton_p = OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15),), borderSide: BorderSide(color: Colors.transparent));
ShapeBorder shape_dialog = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    side: BorderSide(color: Colors.transparent, width: 2));


ShapeBorder shape_incrment_button_left = OutlineInputBorder(
    borderRadius: BorderRadius.only(
     topLeft: Radius.circular(5),bottomLeft:Radius.circular(5)
    ),
    borderSide: BorderSide(color: Colors.transparent));


