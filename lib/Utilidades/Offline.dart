import 'dart:convert';

import 'package:one_purina/Models/M_Participant.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future guardar_contrasena(String usuario, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('lala_usernam', usuario);
  await prefs.setString('lala_passwor', password);
}

Future<List<String>> Obtener_contrasena() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> Datos = new List(2);
  Datos[0] = await prefs.getString('lala_usernam').toString();
  Datos[1] = await prefs.getString('lala_passwor').toString();
  return Datos;
}

Future guardar_data_user(String participante) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('data_user', participante);

  if (participante != null) {
    await prefs.setString('data_user', participante);
  } else {
    await prefs.setString('data_user', null);
  }
}

Future<M_Participant> Obtener_data_user() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var datos = await prefs.getString('data_user');

  M_Participant participant = new M_Participant();
try{  if (datos != null) {
  Map valueMap = json.decode(datos);
  participant = M_Participant.fromJson(valueMap);
} else {
  participant = null;
}} catch(e){
  participant = null;
}
  return participant;
}



Future<String> Obtener_data({String name}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String _datos = prefs.getString(name);
 // print(name+"  $_datos");
  try {
    if (_datos == null) {
      //  Map valueMap = json.decode(datos);
      _datos = null;
    }
  } catch (e) {

    _datos = null;
  }
  return _datos;
}

Future guardar_data({String name,String data}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    if (data != null) {
      await prefs.setString(name, data);

    } else {
      await prefs.setString(name, null);
    }
  } catch (e) {
    await prefs.setString(name, null);
  }
}

//Carrito de compras


Future guardar_data_carrito(String carrito) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('carrito', carrito);

  if (carrito != null) {
    await prefs.setString('carrito', carrito);
  } else {
    await prefs.setString('carrito', null);
  }
}

Future<Map<String, dynamic>> Obtener_data_carrito() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var datos = await prefs.getString('carrito');
  Map<String, dynamic> _carrito;

  try{  if (datos != null) {
    Map valueMap = json.decode(datos);
    _carrito=valueMap;
  } else {
    _carrito = null;
  }} catch(e){
    _carrito = null;
  }
  return _carrito;
}
