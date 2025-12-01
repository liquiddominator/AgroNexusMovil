import 'package:agro_nexus_movil/models/lote.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoteCard extends StatelessWidget {
  final Lote lote;
  final double produccionTotalKg;
  final String Function(String?) formateaFecha;
  final String Function(int?) nombreCultivo;
  final (String, Color, Color) estadoBadge;
  final VoidCallback? onTap;

  const LoteCard({
    required this.lote,
    required this.produccionTotalKg,
    required this.formateaFecha,
    required this.estadoBadge,
    required this.nombreCultivo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormatter = NumberFormat.decimalPattern('es_BO');
    final (label, bgColor, textColor) = estadoBadge;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ───────────────────────────────────────────────
              // Fila superior: Nombre + Imagen
              // ───────────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre del lote
                        Text(
                          lote.nombre,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Cultivo
                        Text(
                          'Cultivo: ${nombreCultivo(lote.cultivoid)}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Imagen pequeña
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 110,
                      height: 70,
                      color: Colors.grey.shade200,
                      child: lote.imagenurl != null &&
                              lote.imagenurl!.isNotEmpty
                          ? Image.network(
                              lote.imagenurl!,
                              fit: BoxFit.cover,
                            )
                          : _placeholderImage(),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 12),

              // ───────────────────────────────────────────────
              // Superficie + Producción
              // ───────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      title: "Superficie",
                      value: "${numberFormatter.format(lote.superficie)} ha",
                    ),
                  ),
                  Expanded(
                    child: _StatItem(
                      title: "Producción",
                      value:
                          "${numberFormatter.format(produccionTotalKg)} kg",
                      alignEnd: true,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ───────────────────────────────────────────────
              // Siembra
              // ───────────────────────────────────────────────
              Text(
                "Siembra",
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

              // ───────────────────────────────────────────────
              // Ubicación + Estado (misma fila)
              // ───────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Ubicación
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            lote.ubicacion ?? "Ubicación no especificada",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Estado
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return const Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 40,
        color: Colors.grey,
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
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
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