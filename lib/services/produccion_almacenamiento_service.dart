import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ProduccionAlmacenamientoService {
  Future<List<dynamic>> getAlmacenamientos(String token) async {
    final url =
        Uri.parse(ApiConstants.url(ApiConstants.produccionesAlmacenamiento));

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getAlmacenamiento(
    int id,
    String token,
  ) async {
    final url = Uri.parse(
      ApiConstants.url('${ApiConstants.produccionesAlmacenamiento}/$id'),
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> createAlmacenamiento(
    Map<String, dynamic> data,
    String token,
  ) async {
    final url =
        Uri.parse(ApiConstants.url(ApiConstants.produccionesAlmacenamiento));

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateAlmacenamiento(
    int id,
    Map<String, dynamic> data,
    String token,
  ) async {
    final url = Uri.parse(
      ApiConstants.url('${ApiConstants.produccionesAlmacenamiento}/$id'),
    );

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    return jsonDecode(response.body);
  }

  Future<bool> deleteAlmacenamiento(int id, String token) async {
    final url = Uri.parse(
      ApiConstants.url('${ApiConstants.produccionesAlmacenamiento}/$id'),
    );

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    return response.statusCode == 200;
  }
}