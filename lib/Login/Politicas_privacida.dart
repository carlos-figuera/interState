import 'dart:async';

import 'package:flutter/material.dart';
import 'package:one_purina/Utilidades/config.dart';
import 'package:webview_flutter/webview_flutter.dart';


class Politica_privacidad extends StatefulWidget {
  @override
  PoliticasState createState() => new PoliticasState();
}

class PoliticasState extends State<Politica_privacidad>
    with WidgetsBindingObserver {


  bool carga = true;




  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Políticas de privacidad  ", style: Titulo20),
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

      body: Container(
        alignment: Alignment.center,
        color: Colors.white10,
        child: Stack(
          children: <Widget>[
            new WebView(
       initialUrl:"https://www.interstatebatteries.com/support/privacy-policy" ,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          // TODO(iskakaushik): Remove this when collection literals makes it to stable.
          // ignore: prefer_collection_literals
          javascriptChannels: <JavascriptChannel>[
          ].toSet(),

          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
        )
          ],
        ),
      )
    );
  }
}
