import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class LoteService {
  Future<List<dynamic>> getLotes(String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.lotes));

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getLote(int id, String token) async {
    final url = Uri.parse(ApiConstants.url('${ApiConstants.lotes}/$id'));

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> createLote(
      Map<String, dynamic> data, String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.lotes));

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(data), // ahora sí soporta int/double
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateLote(
      int id, Map<String, dynamic> data, String token) async {
    final url = Uri.parse(ApiConstants.url('${ApiConstants.lotes}/$id'));

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(data),
    );

    return jsonDecode(response.body);
  }

  Future<bool> deleteLote(int id, String token) async {
    final url = Uri.parse(ApiConstants.url('${ApiConstants.lotes}/$id'));

    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200;
  }
}