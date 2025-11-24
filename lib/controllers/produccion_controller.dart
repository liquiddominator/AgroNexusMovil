import '../services/produccion_service.dart';
import '../models/produccion.dart';

class ProduccionController {
  final ProduccionService _service = ProduccionService();

  bool loading = false;
  String? errorMessage;

  List<Produccion> producciones = [];
  Produccion? produccion;

  Future<bool> cargarProducciones(String token) async {
    loading = true;
    errorMessage = null;

    try {
      final data = await _service.getProducciones(token);
      producciones =
          data.map<Produccion>((json) => Produccion.fromJson(json)).toList();

      loading = false;
      return true;
    } catch (e) {
      errorMessage = e.toString();
    }

    loading = false;
    return false;
  }

  Future<bool> cargarProduccion(int id, String token) async {
    try {
      final data = await _service.getProduccion(id, token);
      produccion = Produccion.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> crearProduccion(Map<String, dynamic> body, String token) async {
    try {
      final data = await _service.createProduccion(body, token);
      produccion = Produccion.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> actualizarProduccion(int id, Map<String, dynamic> body, String token) async {
    try {
      final data = await _service.updateProduccion(id, body, token);
      produccion = Produccion.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> eliminarProduccion(int id, String token) async {
    try {
      return await _service.deleteProduccion(id, token);
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }
}