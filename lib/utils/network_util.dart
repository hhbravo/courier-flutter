import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url) {
    return http.get(url).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error al obtener información");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) async {
    try {
      final response = await http.post(url,
          body: body, headers: headers, encoding: encoding);
      if (response.statusCode == 200) {
        return _decoder.convert(response.body);
      } else {
        throw new Exception("Error al obtener información");
      }
    } catch (exception) {
      print(exception);
      throw new Exception("Error al obtener información");
    }
  }
}
