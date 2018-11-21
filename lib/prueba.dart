import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:courier/models/orders.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _count = 0;
  List<Order> orders;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home Page"),
      ),
      body: Container(
        child: FutureBuilder(
          future: fetchData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(snapshot.data[index].idcourier),
                      );
                    }),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

    Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 3));
    setState(() {
    });
    return null;
  }

  Future<List<Order>> fetchData() async {
    var URL_ORDERS =
        "http://www.choice-aduanas.com.pe/control/servicio/orden?user=39";

    await new Future.delayed(new Duration(seconds: 5));
    orders = [];
    final response = await http.get(
      URL_ORDERS
    );
    if (response.statusCode == 200) {
      orders = Orders.createRepositoryList(json.decode(response.body));
    }
    print(orders.length);
    return orders;
  }
}
