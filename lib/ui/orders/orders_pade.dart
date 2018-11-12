import 'dart:async';

import 'package:flutter/material.dart';
import 'package:courier/models/orders.dart';
import 'package:courier/ui/orders/orders_screen_presenter.dart';
import 'package:courier/models/user.dart';
import 'package:courier/data/rest_ds.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class OrdersPage extends StatefulWidget {
  static String tag = 'orders-page';
  User user;
  OrdersPage({this.user});
  @override
  _OrdersPageState createState() => _OrdersPageState(this.user);
}

class _OrdersPageState extends State<OrdersPage> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  Orders orders;
  bool _isLoading = false;
  int id;
  RestDatasource rest;

  _OrdersPageState(User user) {
    rest = new RestDatasource();
    this.id = user.idusuario;
  }
  
  Future<List<Order>> _getOrders() async {
    return rest.orders(this.id);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      child: new FutureBuilder(
          future: _getOrders(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text('Cargando...'),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data[index].cliente),
                    );
                  });
            }
          }),
    );
  }
}
