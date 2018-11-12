import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {

  var cards = new Card(
    child: new Column(
      children: <Widget>[
        new ListTile(
          leading: new Icon(Icons.playlist_add),
          title: new Text('Prueba title', 
          style: new TextStyle(fontWeight: FontWeight.w400),),
          subtitle: new Text('Prueba sub title'),
        ),
        new Divider(color: Colors.blue,indent: 16.0,)
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cards, 
    );
  }
}