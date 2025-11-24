import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class InsumoService {
  Future<List<dynamic>> getInsumos(String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.insumos));

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getInsumo(int id, String token) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.insumos}/$id'));

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> createInsumo(
    Map<String, dynamic> data,
    String token,
  ) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.insumos));

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: data,
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateInsumo(
    int id,
    Map<String, dynamic> data,
    String token,
  ) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.insumos}/$id'));

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: data,
    );

    return jsonDecode(response.body);
  }

  Future<bool> deleteInsumo(int id, String token) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.insumos}/$id'));

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 200;
  }
}