import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:courier/ui/auth.dart';
import 'package:courier/data/database_helper.dart';
import 'package:courier/models/user.dart';
import 'package:courier/ui/login/login_screen_presenter.dart';
import 'package:courier/ui/home_page.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    implements LoginScreenContract, AuthStateListener {
  BuildContext _ctx;

  bool _isLoading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  String _username;
  String _password;
  LoginScreenPresenter _presenter;

  _LoginPageState() {
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _presenter.doLogin(_username, _password);
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  onAuthStateChanged(AuthState state) async {
    if (state == AuthState.LOGGED_IN) {
      var db = new DatabaseHelper();
      var user = await db.getUser();
      Navigator.push(
          _ctx,
          MaterialPageRoute( builder: (_ctx) => HomePage(  user: user, )));
    }
  }

  @override
  void onLoginError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(User user) async {
    _showSnackBar(user.toString());
    setState(() => _isLoading = false);
    var db = new DatabaseHelper();
    await db.saveUser(user);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    final heroLogo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: new Image(
          image: new AssetImage('assets/images/ChoicelogoSEO.png'),
        ),
      ),
    );

    final user = new Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          autofocus: false,
          initialValue: 'jcanedo',
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: 'Usuario',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
          validator: (val) => val.length == 0 ? 'Digíte usuario.' : null,
          onSaved: (val) => _username = val,
        ));

    final password = new Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          autofocus: false,
          initialValue: '123456',
          decoration: InputDecoration(
              hintText: 'Password',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
          validator: (val) => val.length < 6 ? 'Digíte password.' : null,
          onSaved: (val) => _password = val,
          obscureText: true,
        ));

    final loginButton = new RaisedButton(
      onPressed: _submit,
      child: new Text("Login"),
      color: Colors.blueAccent[100],
    );

    final loginForm = new Column(
      children: <Widget>[
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(4.0),
                child: heroLogo,
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: user,
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: password,
              ),
            ],
          ),
        ),
        _isLoading ? new CircularProgressIndicator() : loginButton
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    return Scaffold(
      key: scaffoldKey,
      body: new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage("assets/images/aduana.jpg",),
                fit: BoxFit.fill),
          ),
          child: new Center(
              child: new ClipRect(
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                child: loginForm,
                height: 300.0,
                width: 300.0,
                decoration: new BoxDecoration(
                  color: Colors.grey.shade200.withOpacity(0.5),
                ),
              ),
            ),
          ))),
    );
  }
}
