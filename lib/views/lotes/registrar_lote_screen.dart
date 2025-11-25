import 'package:flutter/material.dart';

class RegistrarLoteScreen extends StatelessWidget {
  const RegistrarLoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Registrar Lote',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}