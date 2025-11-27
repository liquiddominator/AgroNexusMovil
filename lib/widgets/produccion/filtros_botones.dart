
// =============== WIDGET PRIVADO PARA LOS FILTROS ===============
import 'package:flutter/material.dart';

class FiltroChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool seleccionado;
  final VoidCallback onTap;

  const FiltroChip({
    required this.icon,
    required this.label,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color verde = const Color(0xFF1B5E20);
    final Color verdeSuave = const Color(0xFFE8F5E9);

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: seleccionado ? verdeSuave : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: seleccionado ? verde : Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: seleccionado ? verde : Colors.grey.shade700,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: seleccionado ? verde : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}