import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static String tag = 'home-page';

  
  @override
  Widget build(BuildContext context) {
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
        title: new Text('Courier App'),
        backgroundColor: Colors.yellowAccent,
      ),
      drawer: new Drawer(
          child: new ListView(
        children: <Widget>[
          userDrawer,
          new ListTile(
            title: new Text('Ordenes'),
            trailing: new Icon(Icons.traffic),
            onTap: () => Navigator.of(context).pop(),
          ),
          new Divider(),
          new ListTile(
            title: new Text('Historial'),
            trailing: new Icon(Icons.history),
          )
        ],
      )),
      body: new Center(
        child: new Text('Home'),
      ),
    );
  }
}
