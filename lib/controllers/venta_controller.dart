import '../services/venta_service.dart';
import '../models/venta.dart';

class VentaController {
  final VentaService _service = VentaService();

  bool loading = false;
  String? errorMessage;

  List<Venta> ventas = [];
  Venta? venta;

  Future<bool> cargarVentas(String token) async {
    loading = true;
    errorMessage = null;

    try {
      final data = await _service.getVentas(token);
      ventas = data.map<Venta>((json) => Venta.fromJson(json)).toList();

      loading = false;
      return true;
    } catch (e) {
      errorMessage = e.toString();
    }

    loading = false;
    return false;
  }

  Future<bool> cargarVenta(int id, String token) async {
    try {
      final data = await _service.getVenta(id, token);
      venta = Venta.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> crearVenta(Map<String, dynamic> body, String token) async {
    try {
      final data = await _service.createVenta(body, token);
      venta = Venta.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> actualizarVenta(int id, Map<String, dynamic> body, String token) async {
    try {
      final data = await _service.updateVenta(id, body, token);
      venta = Venta.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> eliminarVenta(int id, String token) async {
    try {
      return await _service.deleteVenta(id, token);
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }
}