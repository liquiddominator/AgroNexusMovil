import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class EstadoLoteService {
  Future<List<dynamic>> getEstados(String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.estadoLotes));

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getEstado(int id, String token) async {
    final url = Uri.parse(
      ApiConstants.url('${ApiConstants.estadoLotes}/$id'),
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> createEstado(
      Map<String, dynamic> data, String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.estadoLotes));

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
      body: data,
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateEstado(
      int id, Map<String, dynamic> data, String token) async {
    final url = Uri.parse(
      ApiConstants.url('${ApiConstants.estadoLotes}/$id'),
    );

    final response = await http.put(
      url,
      headers: {'Authorization': 'Bearer $token'},
      body: data,
    );

    return jsonDecode(response.body);
  }

  Future<bool> deleteEstado(int id, String token) async {
    final url = Uri.parse(
      ApiConstants.url('${ApiConstants.estadoLotes}/$id'),
    );

    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200;
  }
}