import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class RolService {
  Future<List<dynamic>> getRoles(String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.roles));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getRol(int id, String token) async {
    final url = Uri.parse(ApiConstants.url('${ApiConstants.roles}/$id'));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> createRol(
      Map<String, dynamic> data, String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.roles));
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
      body: data,
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateRol(
      int id, Map<String, dynamic> data, String token) async {
    final url = Uri.parse(ApiConstants.url('${ApiConstants.roles}/$id'));
    final response = await http.put(
      url,
      headers: {'Authorization': 'Bearer $token'},
      body: data,
    );
    return jsonDecode(response.body);
  }

  Future<bool> deleteRol(int id, String token) async {
    final url = Uri.parse(ApiConstants.url('${ApiConstants.roles}/$id'));
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200;
  }
}