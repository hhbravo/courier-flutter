import 'package:courier/data/rest_ds.dart';
import 'package:courier/models/user.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(User user);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();
  LoginScreenPresenter(this._view);

  doLogin(String username, String password) {
    api.login(username, password).then((User user) {
      print(user);
      _view.onLoginSuccess(user);
    }).catchError((Exception error) {
      print(error);
      _view.onLoginError(error.toString());
    });
  }
}
