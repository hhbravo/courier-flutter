import 'package:flutter/material.dart';
import 'package:courier/ui/orders/orders_page.dart';
import 'package:courier/models/user.dart';
import 'package:courier/data/database_helper.dart';
import 'package:courier/ui/login/login_page.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  static String tag = 'home-page';
  final User user;

  HomePage({this.user});

  final drawerItems = [
    new DrawerItem("Mis Ordenes", Icons.assignment),
    //new DrawerItem("Historial", Icons.history),
  ];

  @override
  State<StatefulWidget> createState() {
    return new _HomePageState(user: user);
  }
}

class _HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;
  final User user;
  _HomePageState({this.user});

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new OrdersPage(user: this.user);
     /* case 1:
        return new OrdersPage(user: this.user);*/
      default:
        return new Text("Error");
    }
  }

  closeSession(context) async {
    var db = new DatabaseHelper();
    await db.deleteUsers();
    Navigator.of(context).pushNamedAndRemoveUntil(LoginPage.tag, (Route<dynamic> route) => false);
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];

    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }
    final userDrawer = new UserAccountsDrawerHeader(
      accountName: new Text(this.user.nombres,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      accountEmail: new Text(this.user.apellidos,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      decoration: new BoxDecoration(
          image: new DecorationImage(
              fit: BoxFit.fill,
              image: new AssetImage("assets/images/map.png",))),
    );
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blue[700],
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            userDrawer,
            new Column(children: drawerOptions),
            new Divider(),
            new ListTile(
              title: new Text('Cerrar Sessión'),
              leading:  const Icon(Icons.power_settings_new),
              onTap: () {
                closeSession(context);
              },
            ),
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
