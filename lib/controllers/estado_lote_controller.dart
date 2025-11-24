import 'package:agro_nexus_movil/models/estado_lote.dart';
import 'package:agro_nexus_movil/services/estadolote_service.dart';

class EstadoLoteController {
  final EstadoLoteService _service = EstadoLoteService();

  bool loading = false;
  String? errorMessage;

  List<EstadoLote> estados = [];
  EstadoLote? estado;

  Future<bool> cargarEstados(String token) async {
    loading = true;
    errorMessage = null;

    try {
      final data = await _service.getEstados(token);
      estados = data.map<EstadoLote>((json) => EstadoLote.fromJson(json)).toList();

      loading = false;
      return true;
    } catch (e) {
      errorMessage = e.toString();
    }

    loading = false;
    return false;
  }

  Future<bool> cargarEstado(int id, String token) async {
    try {
      final data = await _service.getEstado(id, token);
      estado = EstadoLote.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> crearEstado(Map<String, dynamic> body, String token) async {
    try {
      final data = await _service.createEstado(body, token);
      estado = EstadoLote.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> actualizarEstado(int id, Map<String, dynamic> body, String token) async {
    try {
      final data = await _service.updateEstado(id, body, token);
      estado = EstadoLote.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> eliminarEstado(int id, String token) async {
    try {
      return await _service.deleteEstado(id, token);
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }
}