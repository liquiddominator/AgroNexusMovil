import 'package:flutter/material.dart';

class MisActividadesContent extends StatelessWidget {
  const MisActividadesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 238, 238, 238),
      alignment: Alignment.center,
      child: Text(
        'Mis Actividades',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}