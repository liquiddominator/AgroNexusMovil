import 'package:flutter/material.dart';

class NotificacionesScreen extends StatelessWidget {
  const NotificacionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF1B5E20);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: primaryGreen),
        title: const Text(
          'Notificaciones',
          style: TextStyle(color: primaryGreen),
        ),
      ),
      body: const Center(
        child: Text(
          'Notificaciones del sistema',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}