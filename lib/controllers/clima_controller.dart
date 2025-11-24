import '../services/clima_service.dart';
import '../models/clima.dart';

class ClimaController {
  final ClimaService _service = ClimaService();

  bool loading = false;
  String? errorMessage;

  List<Clima> climas = [];
  Clima? clima;

  Future<bool> cargarClimas(String token) async {
    loading = true;
    errorMessage = null;

    try {
      final data = await _service.getClimas(token);
      climas = data.map<Clima>((json) => Clima.fromJson(json)).toList();
      loading = false;
      return true;
    } catch (e) {
      errorMessage = e.toString();
    }

    loading = false;
    return false;
  }

  Future<bool> cargarClima(int id, String token) async {
    try {
      final data = await _service.getClima(id, token);
      clima = Clima.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> crearClima(Map<String, dynamic> body, String token) async {
    try {
      final data = await _service.createClima(body, token);
      clima = Clima.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> actualizarClima(int id, Map<String, dynamic> body, String token) async {
    try {
      final data = await _service.updateClima(id, body, token);
      clima = Clima.fromJson(data);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> eliminarClima(int id, String token) async {
    try {
      return await _service.deleteClima(id, token);
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }
}