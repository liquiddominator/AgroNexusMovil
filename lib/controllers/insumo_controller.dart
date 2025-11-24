import '../services/insumo_service.dart';
import '../models/insumo.dart';

class InsumoController {
  final InsumoService _service = InsumoService();

  bool loading = false;
  String? errorMessage;

  List<Insumo> insumos = [];
  Insumo? insumo;

  Future<bool> cargarInsumos(String token) async {
    loading = true;
    errorMessage = null;

    try {
      final data = await _service.getInsumos(token);
      insumos = data.map<Insumo>((json) => Insumo.fromJson(json)).toList();

      loading = false;
      return true;
    } catch (e) {
      errorMessage = e.toString();
    }

    loading = false;
    return false;
  }

  Future<bool> cargarInsumo(int id, String token) async {
    try {
      final data = await _service.getInsumo(id, token);
      insumo = Insumo.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> crearInsumo(Map<String, dynamic> body, String token) async {
    try {
      final data = await _service.createInsumo(body, token);
      insumo = Insumo.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> actualizarInsumo(int id, Map<String, dynamic> body, String token) async {
    try {
      final data = await _service.updateInsumo(id, body, token);
      insumo = Insumo.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> eliminarInsumo(int id, String token) async {
    try {
      return await _service.deleteInsumo(id, token);
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }
}