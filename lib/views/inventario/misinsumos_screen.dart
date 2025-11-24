import 'package:flutter/material.dart';

class MisInsumosContent extends StatelessWidget {
  const MisInsumosContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 250, 250, 250),
      alignment: Alignment.center,
      child: Text(
        'Mi Inventario de Insumos',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}