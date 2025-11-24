import 'package:agro_nexus_movil/models/historial_estado_lote.dart';
import 'package:agro_nexus_movil/services/historial_estadolote_service.dart';

class HistorialEstadoLoteController {
  final HistorialEstadoLoteService _service = HistorialEstadoLoteService();

  bool loading = false;
  String? errorMessage;

  List<HistorialEstadoLote> historial = [];
  HistorialEstadoLote? registro;

  Future<bool> cargarHistorial(String token) async {
    loading = true;
    errorMessage = null;

    try {
      final data = await _service.getHistorial(token);
      historial = data.map<HistorialEstadoLote>((json) => HistorialEstadoLote.fromJson(json)).toList();

      loading = false;
      return true;
    } catch (e) {
      errorMessage = e.toString();
    }

    loading = false;
    return false;
  }

  Future<bool> cargarRegistro(int id, String token) async {
    try {
      final data = await _service.getRegistro(id, token);
      registro = HistorialEstadoLote.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> crearRegistro(Map<String, dynamic> body, String token) async {
    try {
      final data = await _service.createRegistro(body, token);
      registro = HistorialEstadoLote.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> actualizarRegistro(int id, Map<String, dynamic> body, String token) async {
    try {
      final data = await _service.updateRegistro(id, body, token);
      registro = HistorialEstadoLote.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> eliminarRegistro(int id, String token) async {
    try {
      return await _service.deleteRegistro(id, token);
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }
}