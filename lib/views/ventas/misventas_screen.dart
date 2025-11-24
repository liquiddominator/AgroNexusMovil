import 'package:flutter/material.dart';

class MisVentasContent extends StatelessWidget {
  const MisVentasContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 250, 250, 250),
      alignment: Alignment.center,
      child: Text(
        'Mis Ventas',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}