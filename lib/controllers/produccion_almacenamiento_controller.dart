import '../services/produccion_almacenamiento_service.dart';
import '../models/produccion_almacenamiento.dart';

class ProduccionAlmacenamientoController {
  final ProduccionAlmacenamientoService _service =
      ProduccionAlmacenamientoService();

  bool loading = false;
  String? errorMessage;

  List<ProduccionAlmacenamiento> almacenamientos = [];
  ProduccionAlmacenamiento? almacenamiento;

  Future<bool> cargarAlmacenamientos(String token) async {
    loading = true;
    errorMessage = null;

    try {
      final data = await _service.getAlmacenamientos(token);
      almacenamientos = data
          .map<ProduccionAlmacenamiento>(
              (json) => ProduccionAlmacenamiento.fromJson(json))
          .toList();

      loading = false;
      return true;
    } catch (e) {
      errorMessage = e.toString();
      loading = false;
      return false;
    }
  }

  Future<bool> cargarAlmacenamiento(int id, String token) async {
    try {
      final data = await _service.getAlmacenamiento(id, token);
      almacenamiento = ProduccionAlmacenamiento.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> crearAlmacenamiento(
    Map<String, dynamic> body,
    String token,
  ) async {
    try {
      final data = await _service.createAlmacenamiento(body, token);
      almacenamiento = ProduccionAlmacenamiento.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> actualizarAlmacenamiento(
    int id,
    Map<String, dynamic> body,
    String token,
  ) async {
    try {
      final data = await _service.updateAlmacenamiento(id, body, token);
      almacenamiento = ProduccionAlmacenamiento.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> eliminarAlmacenamiento(int id, String token) async {
    try {
      return await _service.deleteAlmacenamiento(id, token);
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }
}