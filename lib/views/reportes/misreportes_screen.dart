import 'package:flutter/material.dart';

class MisReportesContent extends StatelessWidget {
  const MisReportesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 250, 250, 250),
      alignment: Alignment.center,
      child: Text(
        'Mis Reportes',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}