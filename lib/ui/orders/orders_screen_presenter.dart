import 'package:courier/data/rest_ds.dart';
import 'package:courier/models/orders.dart';

abstract class OrderScreenContract {
  void onOrderSuccess(String success);
  void onOrderError(String errorTxt);
}

class OrderScreenPresenter {
  OrderScreenContract _view;
  RestDatasource api = new RestDatasource();
  
  OrderScreenPresenter(this._view);

  updateOrder(String id, String lat, String lon, String observation, String idUser, String status) {
    api.updateOrder(id, lat, lon, observation, idUser, status).then((String result) {
      print(result);
      _view.onOrderSuccess(result);
    }).catchError((Exception error) {
      print(error);
      _view.onOrderError(error.toString());
    });
  } 
}