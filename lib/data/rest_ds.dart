import 'package:courier/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class RestDatasource {
  static final BASE_URL = "http://www.choice-aduanas.com.pe/control/servicio/";
  static final URL_LOGIN = BASE_URL + 'services?user={0}&password={1}';
  static final URL_ORDERS = BASE_URL + 'orden?user={0}';
  static final URL_UPDATE_ORDER = BASE_URL + 'updateOrden?idcourier={0}&user={1}&latitud={2}&longitud={3}&observacion={4}&estado={5}';

  Future<User> login(String username, String password) async {
    var url = URL_LOGIN.replaceAll("{0}", username).replaceAll("{1}", password);
    User user;
    final response = await http.post(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      if(response.body.trim().length    > 0) {
          user =  User.fromJson(json.decode(response.body));
          return user;
      } else {
        throw Exception('Usuario no registrado');
      }

    } else {
      // If that call was not successful, throw an error.
      throw Exception('Ocurrío un error');
    }
  }

  Future<String> updateOrder(String idOrder, String lat, String lon, String observation, String idUser, String status) async {
    var url = URL_UPDATE_ORDER.replaceAll("{0}", idOrder).replaceAll("{1}", idUser)
    .replaceAll("{2}", lat).replaceAll("{3}", lon).replaceAll("{4}", observation).replaceAll("{5}", status);
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
