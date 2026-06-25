import 'package:http/http.dart' as http;
import '../services/api_service.dart';

class ApiService {
  static Map<String, String> headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  static Future<http.Response> get(Uri url) {
    return ApiService.get(url, headers: headers);
  }

  static Future<http.Response> post(Uri url, {Object? body}) {
    return ApiService.post(url, headers: headers, body: body);
  }
}