import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Pantalla_util {
//Mantener la pantalla solo en vertical
  portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  //Habilita el giro de pamptalla
  enableRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Size Alto_appBar_por(double alto, double ancho) {
    Size sise;

    if (Platform.isAndroid) {
      sise = new Size(alto * 0, ancho);
    } else if (Platform.isIOS) {
      sise = new Size(alto * 0.06, ancho);
    }
    return sise;
  }

  Size Alto_appBar_lan(double alto, double ancho) {
    Size sise;

    if (Platform.isAndroid) {
      sise = new Size(alto * 0.14, ancho);
    } else if (Platform.isIOS) {
      sise = new Size(alto * 0.1, ancho);
    }
    return sise;
  }

  Size Size_appBar(BuildContext context) {
    final screenOri = MediaQuery.of(context).orientation;
    final screenPortrait = Orientation.portrait;
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    Size sise;

    if (screenOri == screenPortrait) {
      sise = Alto_appBar_por(screenHeight, screenWidth);
    } else {
      sise = Alto_appBar_lan(screenHeight, screenWidth);
    }
    return sise;
  }

  int padding_Logo(double alto) {
    int cant = 0;
    if (Platform.isAndroid) {
      cant = 5;
    } else if (Platform.isIOS) {
      cant = 5;
    }
    return cant;
  }
}
