import 'dart:async';

import 'package:flutter/material.dart';
import 'package:courier/models/orders.dart';
import 'package:courier/ui/orders/orders_screen_presenter.dart';
import 'package:courier/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class OrdersPage extends StatefulWidget {
  static String tag = 'orders-page';
  User user;
  OrdersPage({this.user});
  @override
  _OrdersPageState createState() => _OrdersPageState(this.user);
}

class _OrdersPageState extends State<OrdersPage>
    implements OrderScreenContract {
  Future<List<Order>> _getOrders() async {
    var data = await http
        .get('http://www.choice-aduanas.com.pe/control/servicio/orden?user=1');

    var jsonData = json.decode(data.body);

    List<Order> orders = [];

    for (var u in jsonData) {
      Order order = Order.fromJson(u);
      orders.add(order);
    }
    print(orders.length);
    return orders;
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  OrderScreenPresenter _presenter;
  Orders orders;
  bool _isLoading = false;

  _OrdersPageState(User user) {
    _presenter = new OrderScreenPresenter(this);
    _presenter.orders(user.idusuario);
  }

  Widget bodyData(AsyncSnapshot snapshot) {
    _presenter = new OrderScreenPresenter(this);
    _presenter.orders(1);

    DataTable(
        columns: <DataColumn>[
          DataColumn(
              label: Text("N° Orden"), numeric: false, onSort: (i, b) {}),
          DataColumn(
              label: Text("Prioridad"), numeric: false, onSort: (i, b) {}),
          DataColumn(label: Text("Cliente"), numeric: false, onSort: (i, b) {}),
          DataColumn(
              label: Text("Dirección"), numeric: false, onSort: (i, b) {})
        ],
        rows: orders == null
            ? null
            : orders.orders
                .map((o) => DataRow(cells: [
                      DataCell(Text(o.nro_orden)),
                      DataCell(Text(o.prioridad)),
                      DataCell(Text(o.cliente)),
                      DataCell(Text(o.direccion))
                    ]))
                .toList());
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

  @override
  void onOrderSuccess(Orders orders) async {
    this.orders = orders;
    setState(() => _isLoading = false);
  }

  @override
  void onLoginError(String errorTxt) async {
    print(errorTxt);
    setState(() => _isLoading = false);
  }
}
