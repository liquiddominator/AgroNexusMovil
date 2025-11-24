import 'package:agro_nexus_movil/models/lote_insumo.dart';
import 'package:agro_nexus_movil/services/lote_insumo_service.dart';

class LoteInsumoController {
  final LoteInsumoService _service = LoteInsumoService();

  bool loading = false;
  String? errorMessage;

  List<LoteInsumo> items = [];
  LoteInsumo? item;

  Future<bool> cargarLoteInsumos(String token) async {
    loading = true;
    errorMessage = null;

    try {
      final data = await _service.getLoteInsumos(token);
      items = data.map<LoteInsumo>((json) => LoteInsumo.fromJson(json)).toList();

      loading = false;
      return true;
    } catch (e) {
      errorMessage = e.toString();
    }

    loading = false;
    return false;
  }

  Future<bool> cargarLoteInsumo(int id, String token) async {
    try {
      final data = await _service.getLoteInsumo(id, token);
      item = LoteInsumo.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> crearLoteInsumo(Map<String, dynamic> body, String token) async {
    try {
      final data = await _service.createLoteInsumo(body, token);
      item = LoteInsumo.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> actualizarLoteInsumo(int id, Map<String, dynamic> body, String token) async {
    try {
      final data = await _service.updateLoteInsumo(id, body, token);
      item = LoteInsumo.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> eliminarLoteInsumo(int id, String token) async {
    try {
      return await _service.deleteLoteInsumo(id, token);
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }
}