import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class LoteInsumoService {
  Future<List<dynamic>> getLoteInsumos(String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.loteInsumos));

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getLoteInsumo(int id, String token) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.loteInsumos}/$id'));

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> createLoteInsumo(
    Map<String, dynamic> data,
    String token,
  ) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.loteInsumos));

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: data,
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateLoteInsumo(
    int id,
    Map<String, dynamic> data,
    String token,
  ) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.loteInsumos}/$id'));

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: data,
    );

    return jsonDecode(response.body);
  }

  Future<bool> deleteLoteInsumo(int id, String token) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.loteInsumos}/$id'));

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 200;
  }
}