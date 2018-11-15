import 'package:courier/models/user.dart';
import 'package:courier/models/orders.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class RestDatasource {
  static final BASE_URL = "http://www.choice-aduanas.com.pe/control/servicio/";
  static final URL_LOGIN = BASE_URL + 'services?user={0}&password={1}';
  static final URL_ORDERS = BASE_URL + 'orden?user={0}';
  static final URL_UPDATE_ORDER = BASE_URL + 'updateOrden?latitud={0}&longitud={1}&observacion={2}&id={3}';

  Future<User> login(String username, String password) async {
    var url = URL_LOGIN.replaceAll("{0}", username).replaceAll("{1}", password);
    
    final response = await http.post(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return User.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }


  Future<List<Order>> orders(int id) async {
    var url = URL_ORDERS.replaceAll("{0}", id.toString());
    
    final response = await http.post(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      List<Order> orders = [];
      var jsonData = json.decode(response.body);

      for (var u in jsonData) {
          Order order = Order.fromJson(u);
          orders.add(order);
        }
      // If the call to the server was successful, parse the JSON
      return orders;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<String> updateOrder(String id, String lat, String lon, String observation) async {
    var url = URL_UPDATE_ORDER.replaceAll("{0}", lat).replaceAll("{1}", lon).replaceAll("{2}", observation).replaceAll("{3}", id);
    final response = await http.post(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return json.decode(response.body);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }  
}
