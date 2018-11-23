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
    implements OrderScreenContract {
  BuildContext _ctx;

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
  String _selectedStatus;
  String error;

  List<DropdownMenuItem<String>> listDropStatus = [];
  OrderScreenPresenter _presenter;
  _OrderDetailPageState(Order order) {
    this.order = order;
    _presenter = new OrderScreenPresenter(this);
  }

  @override
  void initState() {
    super.initState();

    initPlatformState();

    _location.onLocationChanged().listen((Map<String, double> result) {
      setState(() {
        _currentLocation = result;
      });
    });
  }

  void loadStatus() {
    listDropStatus = [];
    listDropStatus.add(
        new DropdownMenuItem<String>(child: new Text('Entregado'), value: '3'));
    listDropStatus.add(
        new DropdownMenuItem<String>(child: new Text('Rechazado'), value: '4'));
  }

  initPlatformState() async {
    Map<String, double> location;
    try {
      _permission = await _location.hasPermission();
      location = await _location.getLocation();
      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permiso denegado para usar el gps';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'Permiso denegado, por favor habilite y configure gps';
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
      _presenter.updateOrder(
          this.order.idcourier,
          _currentLocation != null
              ? _currentLocation["latitude"].toString()
              : '',
          _currentLocation != null
              ? _currentLocation["longitude"].toString()
              : '',
          _observation,
          this.order.idusuario_crea,
          _selectedStatus);
    }
  }

  @override
  void onOrderError(String errorTxt) {
    setState(() => _isLoading = true);
    _showSnackBar('Ingrese el estado');
  }

  @override
  void onOrderSuccess(String result) async {
    setState(() => _isLoading = true);
    var results = {"result": "$result"};
    Navigator.pop(_ctx, results);
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    loadStatus();
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
          decoration: InputDecoration(hintText: 'Cliente', enabled: true),
        ));

    final address = new Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          autofocus: false,
          initialValue: this.order.direccion,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(hintText: 'Dirección', enabled: true),
        ));

    final loginButton = new RaisedButton(
      child: new Text("Guardar"),
      color: Colors.blueAccent[100],
      onPressed: _submit,
    );

    final statusDrop = new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new DropdownButton(
          items: listDropStatus,
          value: _selectedStatus,
          iconSize: 40.0,
          elevation: 16,
          hint: new Text('Seleccione estado'),
          onChanged: (value) {
            setState(() {
              _selectedStatus = value;
            });
          },
        ));

    final loginForm = new Form(
      key: formKey,
      autovalidate: true,
      child: new ListView(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          children: <Widget>[
            client,
            address,
            statusDrop,
            observation,
            new Container(
              child: new Center(
                child: _isLoading ? new CircularProgressIndicator() : loginButton,
              ),
              height: 40,
            )
          ]),
    );

    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        backgroundColor: Colors.blue[700],
        title: new Text('Registro'),
      ),
      body: new SafeArea(top: false, bottom: false, child: loginForm),
    );
  }
}
