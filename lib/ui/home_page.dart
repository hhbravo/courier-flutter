import 'package:flutter/material.dart';
import 'package:courier/ui/orders_page.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  static String tag = 'home-page';
  final drawerItems = [
    new DrawerItem("Fragment 1", Icons.rss_feed),
    new DrawerItem("Fragment 2", Icons.local_pizza),
    new DrawerItem("Fragment 3", Icons.info)
  ];

  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new Orders();
      case 1:
        return new Orders();
      case 2:
        return new Orders();

      default:
        return new Text("Error");
    }
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
      accountName: new Text('Hans Code',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      accountEmail: new Text('hans.herrerab@gmail.com',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      currentAccountPicture: new GestureDetector(
        child: new CircleAvatar(
          backgroundImage: new NetworkImage(
              'https://media.licdn.com/dms/image/C4E03AQG03m8cmOmULw/profile-displayphoto-shrink_200_200/0?e=1547078400&v=beta&t=Z8L1ucwfX_5mjqMtiwCqHVcbcLAD-H1FXCAbDR67r6M'),
        ),
      ),
      decoration: new BoxDecoration(
          image: new DecorationImage(
              fit: BoxFit.fill,
              image: new NetworkImage(
                  'https://media.licdn.com/dms/image/C4E16AQGNw5mXr6qkXA/profile-displaybackgroundimage-shrink_350_1400/0?e=1547078400&v=beta&t=FsEZD5U_PCXwqQWykT50yPW2xGik_fh3dGb0UPXEUq4'))),
    );

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.yellow[600],
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[userDrawer, new Column(children: drawerOptions)],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
