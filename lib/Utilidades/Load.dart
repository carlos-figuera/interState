import 'package:flutter/material.dart';
import 'package:one_purina/Utilidades/config.dart';
import 'package:one_purina/Utilidades/widget_globales.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Loads {
  BuildContext context;
  Loads(BuildContext context) {
    this.context = context;
  }

  ProgressDialog pr;

  dialo_Carga(String Mensage) async {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
        message: Mensage,
        borderRadius: 5.0,
        backgroundColor: Colors.white,
        elevation: 10.0,
        progressWidget: widget_Cargando(),
        insetAnimCurve: Curves.elasticOut,
        progressTextStyle: TextStyle(color:primaryColor),
        progress: 100.0,
        padding: EdgeInsets.all(2),
        messageTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
          fontWeight: FontWeight.w900,
        ));
    await pr.show();
  }

  cerrar() {
    new Future.delayed(new Duration(seconds: 2), () {
      pr.hide().then((isHidden) {
        print(isHidden);
      });
    });
  }
}
