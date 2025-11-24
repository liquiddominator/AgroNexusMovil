import 'package:flutter/material.dart';

class DashboardPrincipalContent extends StatelessWidget {
  const DashboardPrincipalContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: const Color.fromARGB(255, 238, 238, 238),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenido a AgroNexus',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Aquí verás un resumen de tus lotes, clima, actividades y más.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Tarjeta 1: Resumen de lotes
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resumen de Lotes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text('• 5 lotes registrados'),
                      Text('• 2 en crecimiento'),
                      Text('• 1 listo para cosecha'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Tarjeta 2: Clima
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Clima actual',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text('• Temperatura: 27°C'),
                      Text('• Humedad: 55%'),
                      Text('• Sin alertas climáticas'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Tarjeta 3: Actividades recientes
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Actividades recientes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text('• Riego en Lote 1 (hoy, 08:30)'),
                      Text('• Fertilización en Lote 4 (ayer)'),
                      Text('• Inspección fitosanitaria (2 días atrás)'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Tarjeta 4: Ventas recientes
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ventas recientes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text('• 250 kg de maíz — Bs. 820'),
                      Text('• 80 kg de tomate — Bs. 300'),
                      Text('• 40 kg de yuca — Bs. 150'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}