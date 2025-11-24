import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class UsuarioService {
  Future<List<dynamic>> getUsuarios({String? token}) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.usuarios));

    final response = await http.get(
      url,
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getUsuario(int id, {String? token}) async {
    final url = Uri.parse(ApiConstants.url('${ApiConstants.usuarios}/$id'));

    final response = await http.get(
      url,
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> createUsuario(
      Map<String, dynamic> data, String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.usuarios));

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
      body: data,
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> updateUsuario(
      int id, Map<String, dynamic> data, String token) async {
    final url = Uri.parse(ApiConstants.url('${ApiConstants.usuarios}/$id'));

    final response = await http.put(
      url,
      headers: {'Authorization': 'Bearer $token'},
      body: data,
    );

    return jsonDecode(response.body);
  }

  Future<bool> deleteUsuario(int id, String token) async {
    final url = Uri.parse(ApiConstants.url('${ApiConstants.usuarios}/$id'));

    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200;
  }
}