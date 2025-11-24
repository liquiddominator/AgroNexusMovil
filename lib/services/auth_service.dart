import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.authLogin));

    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
      },
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.authRegister));

    final response = await http.post(url, body: data);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> me(String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.authMe));

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    return jsonDecode(response.body);
  }

  Future<void> logout(String token) async {
    final url = Uri.parse(ApiConstants.url(ApiConstants.authLogout));

    await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}