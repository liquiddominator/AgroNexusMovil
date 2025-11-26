import 'package:agro_nexus_movil/views/lotes/registrar_lote_screen.dart';
import 'package:agro_nexus_movil/widgets/menu_navegacion/agro_menu_item.dart';
import 'package:flutter/material.dart';

class WrapQuickActions extends StatelessWidget {
  final void Function(AgroMenuItem item)? onQuickNav;

  const WrapQuickActions({this.onQuickNav});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _QuickActionButton(
          icon: Icons.add,
          color: Colors.green.shade700,
          label: "Nuevo Lote",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegistrarLoteScreen()),
            );
          },
        ),
        _QuickActionButton(
          icon: Icons.edit_calendar,
          color: Colors.green,
          label: "Actividad",
          onTap: () {
            onQuickNav?.call(AgroMenuItem.actividades);
          },
        ),
        _QuickActionButton(
          icon: Icons.inventory,
          color: Colors.teal,
          label: "Inventario",
          onTap: () {
            onQuickNav?.call(AgroMenuItem.inventario);
          },
        ),
        _QuickActionButton(
          icon: Icons.bar_chart,
          color: Colors.amber.shade700,
          label: "Reportes",
          onTap: () {
            onQuickNav?.call(AgroMenuItem.reportes);
          },
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (MediaQuery.of(context).size.width - 64) / 2, // 2 columnas
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            )
          ],
        ),
      ),
    );
  }
}