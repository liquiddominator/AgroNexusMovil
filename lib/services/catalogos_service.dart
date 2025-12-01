import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class CatalogosService {
  // ==========================
  // TIPO ACTIVIDAD
  // ==========================

  Future<List<dynamic>> getTipoActividades(String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.tipoActividades));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getTipoActividad(int id, String token) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.tipoActividades}/$id'));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  // ==========================
  // TIPO ALMACÉN
  // ==========================

  Future<List<dynamic>> getTipoAlmacenes(String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.tipoAlmacenes));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getTipoAlmacen(int id, String token) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.tipoAlmacenes}/$id'));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  // ==========================
  // PRIORIDAD
  // ==========================

  Future<List<dynamic>> getPrioridades(String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.prioridades));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getPrioridad(int id, String token) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.prioridades}/$id'));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  // ==========================
  // TIPO INSUMO
  // ==========================

  Future<List<dynamic>> getTipoInsumos(String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.tipoInsumos));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getTipoInsumo(int id, String token) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.tipoInsumos}/$id'));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  // ==========================
  // UNIDAD MEDIDA
  // ==========================

  Future<List<dynamic>> getUnidadesMedida(String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.unidadesMedida));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getUnidadMedida(int id, String token) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.unidadesMedida}/$id'));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  // ==========================
  // CULTIVO
  // ==========================

  Future<List<dynamic>> getCultivos(String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.cultivos));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getCultivo(int id, String token) async {
    final url = Uri.parse(ApiConstants.url('${ApiConstants.cultivos}/$id'));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  // ==========================
  // ESTADO LOTE TIPO
  // ==========================

  Future<List<dynamic>> getEstadoLoteTipos(String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.estadoLoteTipos));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getEstadoLoteTipo(int id, String token) async {
    final url =
        Uri.parse(ApiConstants.url('${ApiConstants.estadoLoteTipos}/$id'));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  // ==========================
  // DESTINO PRODUCCION
  // ==========================

  Future<List<dynamic>> getDestinoProducciones(String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.destinoProducciones));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getDestinoProduccion(
      int id, String token) async {
    final url = Uri.parse(
        ApiConstants.url('${ApiConstants.destinoProducciones}/$id'));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  // ==========================
  // ESTADO LOTE INSUMO
  // ==========================

  Future<List<dynamic>> getEstadoLoteInsumos(String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.estadoLoteInsumos));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getEstadoLoteInsumo(
      int id, String token) async {
    final url = Uri.parse(
        ApiConstants.url('${ApiConstants.estadoLoteInsumos}/$id'));
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }
}