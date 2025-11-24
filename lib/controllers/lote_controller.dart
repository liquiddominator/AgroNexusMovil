import '../services/lote_service.dart';
import '../models/lote.dart';

class LoteController {
  final LoteService _service = LoteService();

  bool loading = false;
  String? errorMessage;

  List<Lote> lotes = [];
  Lote? lote;

  Future<bool> cargarLotes(String token) async {
    loading = true;
    errorMessage = null;

    try {
      final data = await _service.getLotes(token);
      lotes = data.map<Lote>((json) => Lote.fromJson(json)).toList();
      loading = false;
      return true;
    } catch (e) {
      errorMessage = e.toString();
    }

    loading = false;
    return false;
  }

  Future<bool> cargarLote(int id, String token) async {
    try {
      final data = await _service.getLote(id, token);
      lote = Lote.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> crearLote(Map<String, dynamic> body, String token) async {
    try {
      final data = await _service.createLote(body, token);
      lote = Lote.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> actualizarLote(int id, Map<String, dynamic> body, String token) async {
    try {
      final data = await _service.updateLote(id, body, token);
      lote = Lote.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> eliminarLote(int id, String token) async {
    try {
      return await _service.deleteLote(id, token);
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }
}