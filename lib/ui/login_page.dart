import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:courier/ui/home_page.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  String _email;
  String _password;

  void _performLogin() {
    //enviar a la siguiente ruta
    final snackbar = SnackBar(
      content: Text('Usuario: $_email , Password: $_password'),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
    Navigator.of(context).pushNamed(HomePage.tag);
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      _performLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: new Image(
          image: new NetworkImage(
              'http://www.choice-aduanas.com.pe/wp-content/uploads/2018/04/ChoicelogoSEO.png'),
        ),
      ),
    );

    final user = TextFormField(
      autofocus: true,
      initialValue: '',
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: 'Usuario',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: (val) => val.length == 0 ? 'Digíte usuario.' : null,
      onSaved: (val) => _email = val,
    );

    final password = TextFormField(
      autofocus: false,
      initialValue: '',
      decoration: InputDecoration(
          hintText: 'Password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      validator: (val) => val.length < 6 ? 'Digíte password.' : null,
      onSaved: (val) => _password = val,
      obscureText: true,
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
          borderRadius: BorderRadius.circular(40.0),
          shadowColor: Colors.white,
          child: MaterialButton(
            minWidth: 200.0,
            height: 50.0,
            onPressed: _submit,
            color: Colors.blueAccent[100],
            child: Text('Login', style: TextStyle(color: Colors.white)),
          )),
    );

    return Scaffold(
      key: scaffoldKey,
      body: new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new NetworkImage(
                    'http://www.choice-aduanas.com.pe/wp-content/uploads/revslider/sliderdp/sydney-04_optimised_carosel-2.jpg'),
                fit: BoxFit.fill),
          ),
          child: new Center(
              child: new ClipRect(
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                child: Form(
                    key: formKey,
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 24.0, right: 24.0),
                      children: <Widget>[
                        logo,
                        SizedBox(height: 48.0),
                        user,
                        SizedBox(height: 8.0),
                        password,
                        SizedBox(height: 24.0),
                        loginButton
                      ],
                    )),
              ),
            ),
          ))),
    );
  }
}
