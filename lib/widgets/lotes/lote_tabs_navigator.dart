import 'package:agro_nexus_movil/widgets/lotes/actividades_mock.dart';
import 'package:agro_nexus_movil/widgets/lotes/insumos_mock.dart';
import 'package:agro_nexus_movil/widgets/lotes/produccion_mock.dart';
import 'package:flutter/material.dart';
import 'package:agro_nexus_movil/models/lote.dart';
import 'package:agro_nexus_movil/widgets/lotes/lote_detalles_mock.dart';

class LoteTabsNavigator extends StatefulWidget {
  final Lote lote;
  final String cultivoNombre;
  final String estadoNombre;
  final double produccionTotalKg;

  const LoteTabsNavigator({
    super.key,
    required this.lote,
    required this.cultivoNombre,
    required this.estadoNombre,
    required this.produccionTotalKg,
  });

  @override
  State<LoteTabsNavigator> createState() => _LoteTabsNavigatorState();
}

class _LoteTabsNavigatorState extends State<LoteTabsNavigator> {
  int _tabIndex = 0;

  Widget _buildTab(String text, int index, IconData icon) {
    final bool selected = _tabIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? const Color(0xFF1B5E20) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? const Color(0xFF1B5E20) : Colors.grey,
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? const Color(0xFF1B5E20) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content() {
    switch (_tabIndex) {
      case 0:
        return LoteDetallesGenerales(
          lote: widget.lote,
          cultivoNombre: widget.cultivoNombre,
          estadoNombre: widget.estadoNombre,
        );

      case 1:
        return ActividadesMock(lote: widget.lote);

      case 2:
        return const ProduccionMock();

      case 3:
        return const InsumosMock();

      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                blurRadius: 6,
                offset: Offset(0, 2),
                color: Color(0x14000000),
              ),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                const SizedBox(width: 6),
                _buildTab("Información", 0, Icons.info_outline),
                _buildTab("Actividades", 1, Icons.list_alt_outlined),
                _buildTab("Producción", 2, Icons.agriculture_outlined),
                _buildTab("Insumos", 3, Icons.inventory_2_outlined),
                const SizedBox(width: 6),
              ],
            ),
          ),
        ),

        const SizedBox(height: 18),

        _content(),
      ],
    );
  }
}

// Reutilizar contenedor
Widget mockContainer(String text) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          blurRadius: 6,
          offset: Offset(0, 2),
          color: Color(0x14000000),
        ),
      ],
    ),
    child: Text(
      text,
      style: const TextStyle(fontSize: 14),
    ),
  );
}