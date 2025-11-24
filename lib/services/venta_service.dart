import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class VentaService {
  Future<List<dynamic>> getVentas(String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.ventas));

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getVenta(int id, String token) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.ventas}/$id'));

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> createVenta(
    Map<String, dynamic> data,
    String token,
  ) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.ventas));

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: data,
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateVenta(
    int id,
    Map<String, dynamic> data,
    String token,
  ) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.ventas}/$id'));

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: data,
    );

    return jsonDecode(response.body);
  }

  Future<bool> deleteVenta(int id, String token) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.ventas}/$id'));

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 200;
  }
}