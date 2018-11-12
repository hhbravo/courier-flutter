import 'package:courier/data/rest_ds.dart';
import 'package:courier/models/orders.dart';

abstract class OrderScreenContract {
  void onOrderSuccess(Orders orders);
  void onLoginError(String errorTxt);
}

class OrderScreenPresenter {
  OrderScreenContract _view;
  RestDatasource api = new RestDatasource();
  OrderScreenPresenter(this._view);

  orders(int id) {
    api.orders(id).then((Orders orders) {
      print(orders);
      _view.onOrderSuccess(orders);
    }).catchError((Exception error) {
      print(error);
      _view.onLoginError(error.toString());
    });
  }
}