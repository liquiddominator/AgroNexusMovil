import 'package:flutter/material.dart';

class DashboardClimaticoContent extends StatelessWidget {
  const DashboardClimaticoContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 250, 250, 250),
      alignment: Alignment.center,
      child: Text(
        'Dashboard Climatico',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}