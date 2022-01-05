import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const requestUrl = "https://api.hgbrasil.com/finance";
const apiKey = "983242d0";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
    ),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(requestUrl));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dollar = 0;
  double euro = 0;

  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String text) {
    double real = double.parse(text);
    dollarController.text = (real / this.dollar).toStringAsFixed(2);
    euroController.text = (real / this.euro).toStringAsFixed(2);
  }

  void _dollarChanged(String text) {
    double dollar = double.parse(text);
    realController.text = (dollar * this.dollar).toStringAsFixed(2);
    euroController.text = (dollar * this.dollar / this.euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    euroController.text = (euro * this.euro / this.dollar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Money Conversor"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando, por favor aguarde...",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );

              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao carregar dados :(",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dollar =
                      snapshot.data!["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];

                  return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Icon(
                              Icons.monetization_on,
                              size: 150.0,
                              color: Colors.amber,
                            ),
                            buildTextField(
                                "Real", "R\$", realController, _realChanged),
                            Divider(),
                            buildTextField("Dollar", "\$", dollarController,
                                _dollarChanged),
                            Divider(),
                            buildTextField(
                                "Euro", "€", euroController, _euroChanged)
                          ]));
                }
            }
            return Center();
          }),
    );
  }
}

buildTextField(text, symbol, controller, vFunction) {
  return TextField(
    decoration: InputDecoration(
      labelText: text,
      labelStyle: TextStyle(color: Colors.amber),
      prefixText: symbol,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber),
      ),
    ),
    keyboardType: TextInputType.number,
    style: TextStyle(
      color: Colors.amber,
      fontSize: 25.0,
    ),
    controller: controller,
    onChanged: vFunction,
  );
}
