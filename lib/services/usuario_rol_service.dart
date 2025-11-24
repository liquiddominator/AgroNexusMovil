import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class UsuarioRolService {
  Future<List<dynamic>> getUsuarioRoles(String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.usuarioRoles));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getUsuarioRol(int id, String token) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.usuarioRoles}/$id'));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> createUsuarioRol(
      Map<String, dynamic> data, String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.usuarioRoles));
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
      body: data,
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateUsuarioRol(
      int id, Map<String, dynamic> data, String token) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.usuarioRoles}/$id'));
    final response = await http.put(
      url,
      headers: {'Authorization': 'Bearer $token'},
      body: data,
    );
    return jsonDecode(response.body);
  }

  Future<bool> deleteUsuarioRol(int id, String token) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.usuarioRoles}/$id'));
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200;
  }
}