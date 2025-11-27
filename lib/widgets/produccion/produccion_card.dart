// =============== CARD DE PRODUCCIÓN ===============
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProduccionCard extends StatelessWidget {
  final String loteNombre;
  final String fechaCosecha;
  final String destino;
  final double cantidadKg;

  const ProduccionCard({
    required this.loteNombre,
    required this.fechaCosecha,
    required this.destino,
    required this.cantidadKg,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormatter = NumberFormat.decimalPattern('es_BO');

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // fila superior: nombre lote + cantidad
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  loteNombre,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    numberFormatter.format(cantidadKg),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'kg',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),

          // fecha
          Row(
            children: [
              const Icon(
                Icons.event,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                fechaCosecha,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // destino
          const Text(
            'DESTINO',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 0.3,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.attach_money,
                  size: 14,
                  color: Color(0xFF2E7D32),
                ),
                const SizedBox(width: 4),
                Text(
                  destino,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}