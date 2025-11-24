import '../services/actividad_service.dart';
import '../models/actividad.dart';

class ActividadController {
  final ActividadService _service = ActividadService();

  bool loading = false;
  String? errorMessage;

  List<Actividad> actividades = [];
  Actividad? actividad;

  Future<bool> cargarActividades(String token) async {
    loading = true;
    errorMessage = null;

    try {
      final data = await _service.getActividades(token);
      actividades = data.map<Actividad>((json) => Actividad.fromJson(json)).toList();
      loading = false;
      return true;
    } catch (e) {
      errorMessage = e.toString();
    }

    loading = false;
    return false;
  }

  Future<bool> cargarActividad(int id, String token) async {
    try {
      final data = await _service.getActividad(id, token);
      actividad = Actividad.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> crearActividad(Map<String, dynamic> body, String token) async {
    try {
      final data = await _service.createActividad(body, token);
      actividad = Actividad.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> actualizarActividad(int id, Map<String, dynamic> body, String token) async {
    try {
      final data = await _service.updateActividad(id, body, token);
      actividad = Actividad.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> eliminarActividad(int id, String token) async {
    try {
      return await _service.deleteActividad(id, token);
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }
}