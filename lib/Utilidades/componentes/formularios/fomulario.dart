import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_purina/Utilidades/config.dart';

class Formularios {
  BuildContext context;

  Formularios({this.context});
//Mantener la pantalla solo en vertical

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (value.isEmpty)
      return "Requerido*";
    else if (!regex.hasMatch(value))
      return "Ingresa un correo valido.";
    else
      return null;
  }

  fieldFocusChange(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget campo_Texto(
      {FocusNode currentFocus,
      FocusNode nextFocus,
      String nombre,
      TextEditingController nombreController,
      bool fina,
      bool numeros,
      bool enable,
      int limit,
      int flex}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: TextFormField(
          focusNode: currentFocus,
          onFieldSubmitted: (term) {
            fieldFocusChange(currentFocus, nextFocus);
          },
          onChanged: (dato) {},
          decoration: InputDecoration(
              labelText: nombre,
              errorStyle: TextStyle(fontSize: 12),
            border: shape_boton_p),
          validator: (value) {
            if (value.isEmpty) {
              return 'Requerido*';
            }
            return null;
          },
          textInputAction:
              fina == true ? TextInputAction.done : TextInputAction.next,
          controller: nombreController,
          keyboardType:
              numeros == true ? TextInputType.number : TextInputType.text,
          enabled: enable != null ? enable : true,
          maxLength: limit != null ? 10 : null,
        ),
      ),
      flex: flex != null ? flex : 1,
    );
  }

  Widget campo_phone(
      {FocusNode currentFocus,
        FocusNode nextFocus,
        String nombre,
        TextEditingController nombreController,
        bool fina,
        bool numeros,
        bool enable,
        int limit,
        int flex}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 0),
        child: TextFormField(
          focusNode: currentFocus,
          onFieldSubmitted: (term) {
            fieldFocusChange(currentFocus, nextFocus);
          },
          onChanged: (dato) {},
          decoration: InputDecoration(
              labelText: nombre,
              errorStyle: TextStyle(fontSize: 12),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          validator: (value) {
            if (value.isEmpty) {
              return 'Requerido*';
            } else if (value.length != 10) {
              return 'El teléfono debe tener 10 dígitos.';
            }

            return null;
          },
          textInputAction:
          fina == true ? TextInputAction.done : TextInputAction.next,
          controller: nombreController,
          keyboardType:
          numeros == true ? TextInputType.number : TextInputType.text,
          enabled: enable != null ? enable : true,
          maxLength: limit != null ? 10 : null,
        ),
      ),
      flex: flex != null ? flex : 1,
    );
  }


  Widget campo_cantidad(
      {FocusNode currentFocus,
        FocusNode nextFocus,
        String nombre,
        TextEditingController nombreController,
        bool fina,
        bool numeros,
        bool enable,
        int limit,
        int flex}) {
    return ExcludeSemantics(
      child: Padding(
        padding: EdgeInsets.only(top: 0),
        child: TextFormField(
          focusNode: currentFocus,
          onFieldSubmitted: (term) {
            fieldFocusChange(currentFocus, nextFocus);
          },
          onChanged: (dato) {

          },
          decoration: InputDecoration(
              labelText: nombre,
              errorStyle: TextStyle(fontSize: 11,),
              contentPadding: EdgeInsets.symmetric( horizontal: 15),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
          validator: (value) {
            if (value.isEmpty) {
              return 'Requerido*';
            } 

            return null;
          },
          textInputAction:
          fina == true ? TextInputAction.done : TextInputAction.next,
          controller: nombreController,
          keyboardType:
          numeros == true ? TextInputType.number : TextInputType.text,
          enabled: enable != null ? enable : true,
          maxLength: limit != null ? 10 : null,
          inputFormatters:numeros == true ? [WhitelistingTextInputFormatter.digitsOnly]:null
        ),
      ),

    );
  }

  Widget campo_correo(
      {FocusNode currentFocus,
      FocusNode nextFocus,
      String nombre,
      TextEditingController nombreController,
      bool enable,
      int flex}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: TextFormField(
          focusNode: currentFocus,
          onFieldSubmitted: (term) {
            fieldFocusChange(currentFocus, nextFocus);
          },
          onChanged: (dato) {},
          decoration: InputDecoration(
              labelText: nombre,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          validator: (String value) {
            Pattern pattern =
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp regex = new RegExp(pattern);

            if (value.isEmpty)
              return "Requerido*";
            else if (!regex.hasMatch(value))
              return "Ingresa un correo valido.";
            else
              return null;
          },
          textInputAction: TextInputAction.next,
          controller: nombreController,
          keyboardType: TextInputType.emailAddress,
          enabled: enable != null ? enable : true,
        ),
      ),
      flex: flex,
    );
  }

  Limpiar_textField(
      {TextEditingController nombreController1,
      TextEditingController nombreController2,
      TextEditingController nombreController3,
      TextEditingController nombreController4,
      TextEditingController nombreController5,
      TextEditingController nombreController6,
      TextEditingController nombreController7}) {
    nombreController1 != null ? nombreController1.clear() : null;
    nombreController2 != null ? nombreController2.clear() : null;
    nombreController3 != null ? nombreController3.clear() : null;
    nombreController4 != null ? nombreController4.clear() : null;
    nombreController5 != null ? nombreController5.clear() : null;
    nombreController6 != null ? nombreController6.clear() : null;
    nombreController7 != null ? nombreController7.clear() : null;
  }
}
