import 'package:courier/models/orders.dart';
import 'package:courier/models/user.dart';
import 'package:courier/data/rest_ds.dart';
import 'package:courier/ui/orders/orders_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:core';

class OrdersPage extends StatefulWidget {
  static String tag = 'orders-page';
  User user;
  OrdersPage({this.user});
  @override
  _OrdersPageState createState() => _OrdersPageState(this.user);
}

class _OrdersPageState extends State<OrdersPage> {
  int id;
  RestDatasource rest;
  List<Order> orders;
  var URL_ORDERS = "http://www.choice-aduanas.com.pe/control/servicio/orden?user={0}";
  var url;
  int count = 1;

  _OrdersPageState(User user) {
    rest = new RestDatasource();
    id = user.idusuario;
  }


  Future<List<Order>> fetchData() async {
    var url =
        "http://www.choice-aduanas.com.pe/control/servicio/orden?user={0}";

    await new Future.delayed(new Duration(seconds: 5));
    orders = [];
    final response = await http.get(
      url.replaceAll('{0}', id.toString()));

    if (response.statusCode == 200) {
      orders = Orders.createRepositoryList(json.decode(response.body));
    }
    return orders;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: fetchData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int i) {
                      return  Column(children: <Widget>[
                        ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          title: Text(title(snapshot.data[i])),
                          subtitle: Text(subtitle(snapshot.data[i])),
                          onTap: () => _onTapItem(context, snapshot.data[i]),
                        ),
                        Divider(height: 2.0, color: Colors.blueAccent[700],)
                      ]);
                      
                    }),
                );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));
    setState(() {});
    return null;
  }

  void _onTapItem(BuildContext context, Order order) async {
    order.idusuario_crea = this.id.toString();
    Map results = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) =>
                new OrderDetailPage(order: order)));
    if (results != null) {
      _showSnackBar('Se realizó el registro exitosamente');
    }    
  }

  void _showSnackBar(String text) {
    final snackBar = SnackBar(content: Text(text));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  String title(Order order) {
    return 'Cliente: ' +
        order.cliente +
        ' | ' +
        'Prioridad: ' +
        order.prioridad;
  }

  String subtitle(Order order) {
    return 'Dirección: ' +
        order.direccion +
        ' | ' +
        'Estado: ' +
        Order.status(order.estado);
  }
}
