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
    _selectedStatus = order.estado;
  }

  void loadStatus() {
    listDropStatus = [];
    List<String> drop = [
      'Pendiente',
      'Asignado',
      'Entregado',
      'Rechazado',
      'Cerrado'
    ];
    int index = 1;
    listDropStatus = drop
        .map((val) => new DropdownMenuItem<String>(
            child: new Text(val), value: (index++).toString()))
        .toList();
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
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      _presenter.updateOrder(
          this.order.idcourier,
          _currentLocation["latitude"].toString(),
          _currentLocation["longitude"].toString(),
          _observation,
          this.order.idusuario_crea,
          _selectedStatus);
    }
  }

  @override
  void onOrderError(String errorTxt) {
    _showSnackBar(errorTxt);
  }

  @override
  void onOrderSuccess(String result) async {
    _showSnackBar('Se realizo el registro de manera exitosa');
    Navigator.pop(_ctx);
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
          hint: new Text('Estado'),
          onChanged: (value) {
            _selectedStatus = value;
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
            loginButton,
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
