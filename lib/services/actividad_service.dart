import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ActividadService {
  Future<List<dynamic>> getActividades(String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.actividades));

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getActividad(int id, String token) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.actividades}/$id'));

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> createActividad(
    Map<String, dynamic> data,
    String token,
  ) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.actividades));

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: data,
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateActividad(
    int id,
    Map<String, dynamic> data,
    String token,
  ) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.actividades}/$id'));

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: data,
    );

    return jsonDecode(response.body);
  }

  Future<bool> deleteActividad(int id, String token) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.actividades}/$id'));

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 200;
  }
}