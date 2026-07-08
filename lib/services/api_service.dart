import 'package:http/http.dart' as http;

class ApiService {
  static Map<String, String> headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'ngrok-skip-browser-warning': 'true',
  };

  static Future<http.Response> get(Uri url) {
    return http.get(url, headers: headers);
  }

  static Future<http.Response> post(Uri url, {Object? body}) {
    return http.post(url, headers: headers, body: body);
  }
}
