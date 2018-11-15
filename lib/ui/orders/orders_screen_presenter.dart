import 'package:courier/data/rest_ds.dart';

abstract class OrderScreenContract {
  void onOrderSuccess(String result);
  void onOrderError(String errorTxt);
}

class OrderScreenPresenter {
  OrderScreenContract _view;
  RestDatasource api = new RestDatasource();
  
  OrderScreenPresenter(this._view);

  updateOrder(String id, String lat, String lon, String observation) {
    api.updateOrder(id, lat, lon, observation).then((String result) {
      print(result);
      _view.onOrderSuccess(result);
    }).catchError((Exception error) {
      print(error);
      _view.onOrderError(error.toString());
    });
  }
 /* orders(int id) {
    api.orders(id).then((Orders orders) {
      print(orders);
      _view.onOrderSuccess(orders);
    }).catchError((Exception error) {
      print(error);
      _view.onLoginError(error.toString());
    });
  }*/
}