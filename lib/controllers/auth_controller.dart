import 'package:agro_nexus_movil/models/usuarios.dart';
import 'package:agro_nexus_movil/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final AuthService _authService = AuthService();

  bool loading = false;
  String? errorMessage;
  String? token;
  Usuario? usuario;

  static const _tokenKey = 'auth_token';

  Future<bool> login(String email, String password) async {
    loading = true;
    errorMessage = null;

    try {
      final data = await _authService.login(email, password);

      if (data.containsKey('token')) {
        token = data['token'];
        usuario = Usuario.fromJson(data['user']);

        // 🔹 Guardar token en almacenamiento local
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token!);

        loading = false;
        return true;
      } else {
        errorMessage = data['message'] ?? 'Error desconocido';
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    loading = false;
    return false;
  }

  Future<bool> register(Map<String, dynamic> data) async {
    loading = true;
    errorMessage = null;

    try {
      final res = await _authService.register(data);

      if (res.containsKey('token')) {
        token = res['token'];
        usuario = Usuario.fromJson(res['user']);

        // 🔹 Guardar token en almacenamiento local
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token!);

        loading = false;
        return true;
      } else {
        errorMessage = res['message'] ?? 'No se pudo crear la cuenta.';
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    loading = false;
    return false;
  }

  Future<void> logout() async {
    if (token != null) {
      await _authService.logout(token!);
    }
    token = null;
    usuario = null;

    // 🔹 Borrar token guardado
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // CARGAR USUARIO SI YA HAY TOKEN EN MEMORIA
  Future<bool> cargarUsuario() async {
    if (token == null) return false;

    try {
      final data = await _authService.me(token!);
      usuario = Usuario.fromJson(data);
      return true;
    } catch (_) {
      return false;
    }
  }

  // 🔹 RESTAURAR SESIÓN DESDE EL ALMACENAMIENTO LOCAL AL INICIAR LA APP
  Future<bool> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString(_tokenKey);

    if (storedToken == null) {
      return false;
    }

    token = storedToken;

    try {
      final data = await _authService.me(token!);
      usuario = Usuario.fromJson(data);
      return true;
    } catch (_) {
      // Si el token ya no es válido, lo limpio
      token = null;
      usuario = null;
      await prefs.remove(_tokenKey);
      return false;
    }
  }
}

// Instancia global
final AuthController authController = AuthController();