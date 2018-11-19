import 'package:courier/data/rest_ds.dart';
import 'package:courier/models/orders.dart';

abstract class OrderPresenterAbstract {
  void onOrderSuccessList(Orders orders);
  void onOrderError(String errorTxt);
}

class OrderPresenter {
  OrderPresenterAbstract _view;
  RestDatasource api = new RestDatasource();
  
  OrderPresenter(this._view);

}