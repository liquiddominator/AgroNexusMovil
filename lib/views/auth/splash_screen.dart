import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agro_nexus_movil/controllers/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progressValue = 0.0;
  String _statusText = "Preparando interfaz...";

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  void _simulateLoading() {
    Timer.periodic(const Duration(milliseconds: 300), (timer) async {
      setState(() {
        _progressValue += 0.2;

        if (_progressValue < 0.4) {
          _statusText = "Cargando recursos...";
        } else if (_progressValue < 0.8) {
          _statusText = "Inicializando componentes...";
        } else {
          _statusText = "Preparando interfaz...";
        }
      });

      if (_progressValue >= 1.0) {
        timer.cancel();
        await _decideNextScreen();
      }
    });
  }

  Future<void> _decideNextScreen() async {
    // 🔹 Intentar restaurar sesión
    final logged = await authController.restoreSession();

    if (!mounted) return;

    if (logged) {
      // Hay token válido: ir directo al dashboard
      Navigator.pushReplacementNamed(context, '/dashboard-principal');
    } else {
      // No hay sesión o token inválido: ir al login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F8),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 160,
                height: 160,
              ),
              const SizedBox(height: 40),

              // Título principal más grande
              const Text(
                "AgroNexus",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),

              // Subtítulo más grande
              const Text(
                "Gestión Inteligente de Cultivos",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 60),

              // Indicador circular más grande
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)), // Verde
                ),
              ),
              const SizedBox(height: 30),

              // Barra de progreso más gruesa
              Container(
                width: 220,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 220 * _progressValue,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Texto dinámico más visible
              Text(
                _statusText,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 60),

              // Versión más visible
              const Text(
                "Versión 1.0.0",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}