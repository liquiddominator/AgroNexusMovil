import 'package:flutter/material.dart';

class ConfiguracionScreen extends StatelessWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF1B5E20);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: primaryGreen),
        title: const Text(
          'Configuración',
          style: TextStyle(color: primaryGreen),
        ),
      ),
      body: const Center(
        child: Text(
          'Ajustes de la aplicación',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}