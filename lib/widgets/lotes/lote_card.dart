import 'package:agro_nexus_movil/models/lote.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoteCard extends StatelessWidget {
  final Lote lote;
  final double produccionTotalKg;
  final String Function(String?) formateaFecha;
  final (String, Color, Color) estadoBadge;
  final VoidCallback? onTap; // <-- nuevo

  const LoteCard({
    required this.lote,
    required this.produccionTotalKg,
    required this.formateaFecha,
    required this.estadoBadge,
    this.onTap, // <-- nuevo
  });

  @override
  Widget build(BuildContext context) {
    final numberFormatter = NumberFormat.decimalPattern('es_BO');
    final (label, bgColor, textColor) = estadoBadge;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap, // <-- tap en toda la card (menos en los IconButton)
        child: Container(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título + badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        lote.nombre,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Cultivo: ${lote.cultivoid != null ? 'ID ${lote.cultivoid}' : 'Sin definir'}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 16),

                // Superficie / Producción
                Row(
                  children: [
                    Expanded(
                      child: _StatItem(
                        title: 'Superficie',
                        value:
                            '${numberFormatter.format(lote.superficie)} ha',
                      ),
                    ),
                    Expanded(
                      child: _StatItem(
                        title: 'Producción',
                        value:
                            '${numberFormatter.format(produccionTotalKg)} kg',
                        alignEnd: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Fecha siembra
                Text(
                  'Siembra',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formateaFecha(lote.fechasiembra),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                // Ubicación
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        lote.ubicacion ?? 'Ubicación no especificada',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      tooltip: 'Editar lote',
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () {
                        // navegar a edición
                      },
                    ),
                    IconButton(
                      tooltip: 'Más opciones',
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        // mostrar menú contextual
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final bool alignEnd;

  const _StatItem({
    required this.title,
    required this.value,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    final align = alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}