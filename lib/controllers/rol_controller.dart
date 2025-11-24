import '../services/rol_service.dart';
import '../models/rol.dart';

class RolController {
  final RolService _service = RolService();

  bool loading = false;
  String? errorMessage;

  List<Rol> roles = [];
  Rol? rol;

  Future<bool> cargarRoles(String token) async {
    loading = true;
    errorMessage = null;

    try {
      final data = await _service.getRoles(token);
      roles = data.map<Rol>((json) => Rol.fromJson(json)).toList();

      loading = false;
      return true;
    } catch (e) {
      errorMessage = e.toString();
    }

    loading = false;
    return false;
  }

  Future<bool> cargarRol(int id, String token) async {
    try {
      final data = await _service.getRol(id, token);
      rol = Rol.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> crearRol(Map<String, dynamic> body, String token) async {
    try {
      final data = await _service.createRol(body, token);
      rol = Rol.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> actualizarRol(int id, Map<String, dynamic> body, String token) async {
    try {
      final data = await _service.updateRol(id, body, token);
      rol = Rol.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> eliminarRol(int id, String token) async {
    try {
      return await _service.deleteRol(id, token);
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }
}