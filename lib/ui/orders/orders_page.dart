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
  BuildContext _ctx;
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  Orders orders;
  bool _isLoading = false;
  int id;
  RestDatasource rest;
  List<Order> _listContent;
  var URL_ORDERS =
      "http://www.choice-aduanas.com.pe/control/servicio/orden?user={0}";
  var url;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  _OrdersPageState(User user) {
    rest = new RestDatasource();
    id = user.idusuario;
  }

  Future<List<Order>> fetchData() async {
    url = URL_ORDERS.replaceAll("{0}", id.toString());
    await new Future.delayed(new Duration(seconds: 5));

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Orders.createRepositoryList(json.decode(response.body));
    } else {
      throw Exception('Failed to load repository, Try again in 1000 years');
    }
  }

  Future<Null> _handleRefresh() async {
    _refreshIndicatorKey.currentState?.show(atTop: false);
    Completer<Null> completer = new Completer<Null>();
      Timer timer = new Timer(new Duration(seconds: 3), () {
      fetchData();
      completer.complete();
    });
    return completer.future;

  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    var futureBuilder = new FutureBuilder(
      future: fetchData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Container(child: Center(child: new Text('cargando...')));
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else
                return new Column(
                  children: <Widget>[
                    Expanded(
                      child: new RefreshIndicator(
                          child: createListView(context, snapshot),
                          onRefresh: _handleRefresh,
                          ),

                    )
                  ],
                );
          }
        } else if (snapshot.hasError) {
          return Center(
              child: Text(
            "No tiene ordenes asignados",
          ));
        }
        return Center(child: CircularProgressIndicator());
      },
    );

    return Scaffold(body: futureBuilder);
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Order> values = snapshot.data;
    return new ListView.builder(
      itemCount: values.length,
      itemBuilder: (BuildContext context, int i) {
        return new Column(
          children: <Widget>[
            ListTile(
                title: Text(title(values[i])),
                subtitle: Text(subtitle(values[i])),
                onTap: () => _onTapItem(context, values[i])),
            Divider(
              height: 2.0,
            )
          ],
        );
      },
    );
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
    fetchData();
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
