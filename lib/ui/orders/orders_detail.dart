import 'dart:async';
import 'package:flutter/material.dart';
import 'package:courier/models/orders.dart';
import 'package:courier/ui/orders/orders_screen_presenter.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

class OrderDetailPage extends StatefulWidget {
  Order order;
  OrderDetailPage({this.order});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState(this.order);
}

class _OrderDetailPageState extends State<OrderDetailPage> 
  implements OrderScreenContract{
  Map<String, double> _startLocation;
  Map<String, double> _currentLocation;

  StreamSubscription<Map<String, double>> _locationSubscription;

  Location _location = new Location();

  bool _permission = false;
  bool _isLoading = false;
  bool currentWidget = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  Order order;

  String _observation;
  String error;
  
  OrderScreenPresenter _presenter;

  _OrderDetailPageState(Order order) {
    this.order = order;
    _presenter = new OrderScreenPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _locationSubscription =
        _location.onLocationChanged().listen((Map<String, double> result) {
      setState(() {
        _currentLocation = result;
      });
    });
  }

  initPlatformState() async {
    Map<String, double> location;
    try {
      _permission = await _location.hasPermission();
      location = await _location.getLocation();
      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      }
      location = null;
    }
    setState(() {
      _startLocation = location;
    });
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _presenter.updateOrder(this.order.idcourier, _currentLocation["latitude"].toString(), _currentLocation["longitude"].toString(), _observation);
    }
  }

  @override
  void onOrderError(String errorTxt) {
    print(errorTxt);
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onOrderSuccess(String result) async {
    _showSnackBar(result);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final observation = new Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          autofocus: false,
          initialValue: '',
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Observación',
          ),
          onSaved: (val) => _observation = val,
        ));

    final client = new Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          autofocus: false,
          initialValue: this.order.cliente,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Cliente',
          ),
        ));

    final address = new Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          autofocus: false,
          initialValue: this.order.direccion,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Dirección',
          ),
        ));

    final loginButton = new RaisedButton(
      onPressed: _submit,
      child: new Text("Guardar"),
      color: Colors.blueAccent[100],
    );

    final loginForm = new Column(
      children: <Widget>[
        new Form(
            key: formKey,
            child: new Column(children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(4.0),
                child: client,
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: address,
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: observation,
              ),
            ]
          )
        ),
        loginButton
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('Registro'),
      ),
      body: new Container(
            child: new Container(
              padding: new EdgeInsets.all(10.0),
              child: loginForm,
        ),
      ),
    );
  }
}
