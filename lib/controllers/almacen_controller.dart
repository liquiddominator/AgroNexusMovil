import '../services/almacen_service.dart';
import '../models/almacen.dart';

class AlmacenController {
  final AlmacenService _service = AlmacenService();

  bool loading = false;
  String? errorMessage;

  List<Almacen> almacenes = [];
  Almacen? almacen;

  Future<bool> cargarAlmacenes(String token) async {
    loading = true;
    errorMessage = null;

    try {
      final data = await _service.getAlmacenes(token);
      almacenes =
          data.map<Almacen>((json) => Almacen.fromJson(json)).toList();

      loading = false;
      return true;
    } catch (e) {
      errorMessage = e.toString();
      loading = false;
      return false;
    }
  }

  Future<bool> cargarAlmacen(int id, String token) async {
    try {
      final data = await _service.getAlmacen(id, token);
      almacen = Almacen.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> crearAlmacen(
    Map<String, dynamic> body,
    String token,
  ) async {
    try {
      final data = await _service.createAlmacen(body, token);
      almacen = Almacen.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> actualizarAlmacen(
    int id,
    Map<String, dynamic> body,
    String token,
  ) async {
    try {
      final data = await _service.updateAlmacen(id, body, token);
      almacen = Almacen.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> eliminarAlmacen(int id, String token) async {
    try {
      return await _service.deleteAlmacen(id, token);
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }
}