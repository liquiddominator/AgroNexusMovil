import 'package:flutter/material.dart';

class MiHistorialProduccionContent extends StatelessWidget {
  const MiHistorialProduccionContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 250, 250, 250),
      alignment: Alignment.center,
      child: Text(
        'Historial de produccion',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}