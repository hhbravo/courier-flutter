import 'dart:async';
import 'package:flutter/material.dart';
import 'package:courier/models/orders.dart';
import 'package:location/location.dart';

class OrderDetailPage extends StatefulWidget {
  Order order;

  OrderDetailPage({this.order});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState(this.order);
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final _formKey = GlobalKey<FormState>();
  bool _permission = false;
  String error;
  bool currentWidget = true;

  Order order;
  var location = new Location();
  Map<String, double> currentLocation = new Map();
  StreamSubscription<Map<String, double>> locationSubscription;

  _OrderDetailPageState(Order order) {
    this.order = order;
  }

  @override
  void initState() {
    super.initState();
    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;

    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: new Text('hola'));
  }

  void initPlatformState() async {
    Map<String, double> _location;
    try {
      _permission = await location.hasPermission();
      _location = await location.getLocation();
      error = '';
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      }
      location = null;
    }
    setState(() {
      currentLocation = _location;
    });
  }
}
