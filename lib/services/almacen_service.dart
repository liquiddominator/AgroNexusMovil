import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class AlmacenService {
  Future<List<dynamic>> getAlmacenes(String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.almacenes));

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getAlmacen(int id, String token) async {
    final url = Uri.parse(ApiConstants.url('${ApiConstants.almacenes}/$id'));

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> createAlmacen(
    Map<String, dynamic> data,
    String token,
  ) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.almacenes));

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

  Future<Map<String, dynamic>> updateAlmacen(
    int id,
    Map<String, dynamic> data,
    String token,
  ) async {
    final url = Uri.parse(ApiConstants.url('${ApiConstants.almacenes}/$id'));

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

  Future<bool> deleteAlmacen(int id, String token) async {
    final url = Uri.parse(ApiConstants.url('${ApiConstants.almacenes}/$id'));

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