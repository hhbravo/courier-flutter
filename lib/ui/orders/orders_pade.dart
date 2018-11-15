import 'dart:async';

import 'package:flutter/material.dart';
import 'package:courier/models/orders.dart';
import 'package:courier/models/user.dart';
import 'package:courier/data/rest_ds.dart';
import 'package:courier/ui/orders/orders_detail.dart';

class OrdersPage extends StatefulWidget {
  static String tag = 'orders-page';
  User user;
  OrdersPage({this.user});
  @override
  _OrdersPageState createState() => _OrdersPageState(this.user);
}

class _OrdersPageState extends State<OrdersPage> {
  BuildContext _ctx;
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
    _ctx = context;
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
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
                      title: Text(title(snapshot.data[index])),
                      subtitle: Text(subtitle(snapshot.data[index])),
                       onTap: () => _onTapItem(context, snapshot.data[index]),
                    );
                  },
                  
              );
            }
          }),
    );
  }

  void _onTapItem(BuildContext context, Order order) {
      Navigator.push(
        _ctx,
        new MaterialPageRoute(
            builder: (BuildContext _ctx) => 
            new OrderDetailPage(order: order)));  
  }

  String title(Order order) {
    return 'Cliente: ' + order.cliente + ' | ' + 'Prioridad :' + order.prioridad;
  }

  String subtitle(Order order) {
    return 'Dirección: ' + order.direccion + ' | ' + 'Estado :' + order.name_estado;
  }

  
}
