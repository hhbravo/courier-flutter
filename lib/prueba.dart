import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State < MyApp >  {
  Map < String, double > _startLocation; 
  Map < String, double > _currentLocation; 

  Location _location = new Location(); 
  bool _permission = false; 
  String error; 

  bool currentWidget = true; 

  Image image1; 

  @override
  void initState() {
    super.initState(); 

    initPlatformState(); 
    
    _location.onLocationChanged().listen((Map < String, double > result) {
      setState(() {
        _currentLocation = result; 
      }); 
    }); 
  }

  initPlatformState()async {
    Map < String, double > location; 
    try {
      _permission = await _location.hasPermission(); 
      location = await _location.getLocation();
      error = null;
    }on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      }else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 
            'Permission denied - please ask the user to enable it from the app settings';
      }
      location = null;
    }
    setState(() {
      _startLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    List < Widget > widgets;

    if (_currentLocation == null) {
      widgets = new List();
    }else {
      widgets = [
        new Image.network(
            "https://maps.googleapis.com/maps/api/staticmap?center=${_currentLocation["latitude"]},${_currentLocation["longitude"]}&zoom=18&size=640x400&key=YOUR_API_KEY")
      ];
    }

    widgets.add(new Center(
        child:new Text(_startLocation != null?'Start location: $_startLocation\n':'Error: $error\n')));

    widgets.add(new Center(
        child:new Text(_currentLocation != null?'Continuous location: $_currentLocation\n':'Error: $error\n')));

    widgets.add(new Center(
        child:new Text(
            _permission?'Has permission : Yes':"Has permission : No")));

    return new MaterialApp(
        home:new Scaffold(
            appBar:new AppBar(
              title:new Text('Location plugin example app'), ), 
            body:new Column(
              crossAxisAlignment:CrossAxisAlignment.start, 
              mainAxisSize:MainAxisSize.min, 
              children:widgets, )));
  }
}
