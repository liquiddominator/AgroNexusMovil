import 'package:agro_nexus_movil/models/usuarios.dart';
import '../services/usuario_service.dart';

class UsuarioController {
  final UsuarioService _service = UsuarioService();

  bool loading = false;
  String? errorMessage;

  List<Usuario> usuarios = [];
  Usuario? usuario;

  Future<bool> cargarUsuarios(String token) async {
    loading = true;
    errorMessage = null;

    try {
      final data = await _service.getUsuarios(token: token);
      usuarios = data.map<Usuario>((json) => Usuario.fromJson(json)).toList();

      loading = false;
      return true;
    } catch (e) {
      errorMessage = e.toString();
    }

    loading = false;
    return false;
  }

  Future<bool> cargarUsuario(int id, String token) async {
    try {
      final data = await _service.getUsuario(id, token: token);
      usuario = Usuario.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> crearUsuario(Map<String, dynamic> data, String token) async {
    try {
      final res = await _service.createUsuario(data, token);
      usuario = Usuario.fromJson(res);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> actualizarUsuario(int id, Map<String, dynamic> data, String token) async {
    try {
      final res = await _service.updateUsuario(id, data, token);
      usuario = Usuario.fromJson(res);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> eliminarUsuario(int id, String token) async {
    try {
      return await _service.deleteUsuario(id, token);
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }
}