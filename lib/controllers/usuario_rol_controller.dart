import 'package:agro_nexus_movil/models/usuario_rol.dart';
import 'package:agro_nexus_movil/services/usuario_rol_service.dart';

class UsuarioRolController {
  final UsuarioRolService _service = UsuarioRolService();

  bool loading = false;
  String? errorMessage;

  List<UsuarioRol> registros = [];
  UsuarioRol? registro;

  Future<bool> cargarRegistros(String token) async {
    loading = true;
    errorMessage = null;

    try {
      final data = await _service.getUsuarioRoles(token);
      registros = data.map<UsuarioRol>((json) => UsuarioRol.fromJson(json)).toList();

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
      final data = await _service.getUsuarioRol(id, token);
      registro = UsuarioRol.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> crearRegistro(Map<String, dynamic> body, String token) async {
    try {
      final data = await _service.createUsuarioRol(body, token);
      registro = UsuarioRol.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> actualizarRegistro(int id, Map<String, dynamic> body, String token) async {
    try {
      final data = await _service.updateUsuarioRol(id, body, token);
      registro = UsuarioRol.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> eliminarRegistro(int id, String token) async {
    try {
      return await _service.deleteUsuarioRol(id, token);
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }
}