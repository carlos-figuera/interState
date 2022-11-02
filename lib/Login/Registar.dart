import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_purina/Utilidades/Load.dart';
import 'package:one_purina/Utilidades/Toast_util.dart';
import 'package:one_purina/Utilidades/componentes/formularios/fomulario.dart';
import 'package:one_purina/Utilidades/config.dart';
import 'package:one_purina/provider/db_sqlite.dart';

import 'Politicas_privacida.dart';

class Registarse extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new Crear_productoState();
}

class Crear_productoState extends State<Registarse> {
  Formularios formularios;

  Loads loads;

  TextEditingController _nombreController;
  TextEditingController _apellidoController;
  TextEditingController _emailController;
  TextEditingController _celularoController;
  TextEditingController _contrasenaController;

  Db_sqlite db_sqlite = new Db_sqlite();

  int selected = 0;
  String categoria_seleccionada = "";
  bool enable_boton = true;
  bool enable_icon = false;
  String dropdownValue;

  final FocusNode _nombre = FocusNode();
  final FocusNode _apellido = FocusNode();
  final FocusNode _email = FocusNode();
  final FocusNode _celular = FocusNode();
  final FocusNode _fechaN = FocusNode();
  final FocusNode _contrasena = FocusNode();
  final FocusNode _false = FocusNode();
  int Inicio = 1;
  double scroll = 1;
  double container = 3.5;
  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void initState() {
    super.initState();
    loads = new Loads(context);
    db_sqlite.Load();
    formularios = new Formularios(context: context);
    _nombreController = new TextEditingController(text: "");
    _apellidoController = new TextEditingController(text: "");
    _emailController = new TextEditingController(text: "");
    _celularoController = new TextEditingController(text: "");
    _contrasenaController = new TextEditingController(text: "");
  }

  GuardarUsuario() async {
    loads.dialo_Carga('Registrado usuario...');
    var exiteUsuario =
        await db_sqlite.existeUsuario(email: _emailController.text);
    new Future.delayed(new Duration(seconds: 4), () {
      if (exiteUsuario.length == 0) {
        db_sqlite.insertUsuario(
            nombre: _nombreController.text,
            email: _emailController.text,
            contrasena: _contrasenaController.text,
            celular: _celularoController.text);

        db_sqlite.getListUusario();
        formularios.Limpiar_textField(
            nombreController1: _nombreController,
            nombreController5: _apellidoController,
            nombreController2: _emailController,
            nombreController3: _celularoController,
            nombreController4: _contrasenaController);
        Toat_mensaje_center(color: 2, mensaje: "Usuario registrado.");
        checkedValue = false;
        setState(() {});
      } else {
        Toat_mensaje_center(
            color: 1, mensaje: "Este correo ya esta registrado.");
      }
      loads.cerrar();
    });
  }

  bool checkedValue = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
        appBar: AppBar(
          title: Text("Registrar", style: Titulo20),
          centerTitle: true,
          backgroundColor: primaryColor,
          leading: IconButton(
            icon: Icon(Icons.keyboard_backspace),
            padding: EdgeInsets.only(bottom: 4),
            onPressed: () {
              //  Navigator.pushReplacementNamed(context, "HomePage");
              Navigator.pop(context);
            },
          ),
          /* actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {})
        ],*/
        ),
        body: SingleChildScrollView(
            child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.8,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                formularios.campo_Texto(
                    nombre: 'Nombres',
                    currentFocus: _nombre,
                    nextFocus: _apellido,
                    nombreController: _nombreController),
                formularios.campo_Texto(
                    nombre: 'Apellidos',
                    currentFocus: _apellido,
                    nextFocus: _email,
                    nombreController: _apellidoController),
                formularios.campo_Texto(
                    nombre: 'Email',
                    currentFocus: _email,
                    nextFocus: _celular,
                    nombreController: _emailController),
                formularios.campo_Texto(
                    nombre: 'Celular',
                    currentFocus: _celular,
                    nextFocus: _contrasena,
                    nombreController: _celularoController,
                    numeros: true),
                formularios.campo_Texto(
                    nombre: 'Contraseña',
                    currentFocus: _contrasena,
                    nextFocus: _false,
                    nombreController: _contrasenaController,
                    numeros: false),
               /* CheckboxListTile(
                  title: Text(
                    "Aceptar políticas de privacidad  ",
                    textDirection: TextDirection.ltr,
                  ),
                  value: checkedValue,
                  dense: true,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValue = newValue;

                      if (newValue) {

                        new Future.delayed(new Duration(seconds: 2), () {

                        });

                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),*/
                Container(
                  child: RaisedButton(
                    disabledColor: Colors.grey,
                    child: Text(
                      'Registrar',
                      style: TextStyle(fontSize: 16),
                    ),
                    color: primaryColor,
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.transparent)),
                    textColor: Colors.white,
                    onPressed: () {

                      if (_formKey.currentState.validate()) {
                        GuardarUsuario();
                      }
                    },
                  ),
                  width: screenWidth,
                )
              ],
            ),
          ),
        )));
  }
}
