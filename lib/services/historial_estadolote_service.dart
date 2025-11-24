import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class HistorialEstadoLoteService {
  // ==========================
  // LISTAR HISTORIAL
  // ==========================
  Future<List<dynamic>> getHistorial(String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.historialEstadosLote));

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    return jsonDecode(response.body);
  }

  // ==========================
  // OBTENER UN REGISTRO
  // ==========================
  Future<Map<String, dynamic>> getRegistro(int id, String token) async {
    final url = Uri.parse(
      ApiConstants.url('${ApiConstants.historialEstadosLote}/$id'),
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    return jsonDecode(response.body);
  }

  // ==========================
  // CREAR
  // ==========================
  Future<Map<String, dynamic>> createRegistro(
      Map<String, dynamic> data, String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.historialEstadosLote));

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
      body: data,
    );

    return jsonDecode(response.body);
  }

  // ==========================
  // ACTUALIZAR
  // ==========================
  Future<Map<String, dynamic>> updateRegistro(
      int id, Map<String, dynamic> data, String token) async {
    final url = Uri.parse(
      ApiConstants.url('${ApiConstants.historialEstadosLote}/$id'),
    );

    final response = await http.put(
      url,
      headers: {'Authorization': 'Bearer $token'},
      body: data,
    );

    return jsonDecode(response.body);
  }

  // ==========================
  // ELIMINAR
  // ==========================
  Future<bool> deleteRegistro(int id, String token) async {
    final url = Uri.parse(
      ApiConstants.url('${ApiConstants.historialEstadosLote}/$id'),
    );

    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }
}