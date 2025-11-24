import 'package:flutter/material.dart';

class MiListaLotesContent extends StatelessWidget {
  const MiListaLotesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 250, 250, 250),
      alignment: Alignment.center,
      child: Text(
        'Lista de mis lotes',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}