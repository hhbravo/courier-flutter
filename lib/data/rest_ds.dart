import 'package:courier/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class RestDatasource {
  static final BASE_URL =
      "http://localhost:8080/control/Servicio/services?user={0}&password={1}";

  Future<User> login(String username, String password) async {
    var url = BASE_URL.replaceAll("{0}", username).replaceAll("{1}", password);
    final response = await http.post(url,
    headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return User.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
