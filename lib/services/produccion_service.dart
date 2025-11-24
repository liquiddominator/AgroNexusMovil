import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ProduccionService {
  Future<List<dynamic>> getProducciones(String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.producciones));

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getProduccion(int id, String token) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.producciones}/$id'));

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> createProduccion(
    Map<String, dynamic> data,
    String token,
  ) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.producciones));

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: data,
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateProduccion(
    int id,
    Map<String, dynamic> data,
    String token,
  ) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.producciones}/$id'));

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: data,
    );

    return jsonDecode(response.body);
  }

  Future<bool> deleteProduccion(int id, String token) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.producciones}/$id'));

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 200;
  }
}