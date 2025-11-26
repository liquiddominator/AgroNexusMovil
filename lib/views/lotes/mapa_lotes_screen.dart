import 'package:flutter/material.dart';

class MapaLotesScreen extends StatelessWidget {
  const MapaLotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Lotes'),
      ),
      body: const Center(
        child: Text(
          'Mapa de lotes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}