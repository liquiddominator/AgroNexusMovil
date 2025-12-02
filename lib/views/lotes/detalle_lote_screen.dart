import 'package:agro_nexus_movil/controllers/catalogos_controller.dart';
import 'package:agro_nexus_movil/models/cultivo.dart';
import 'package:agro_nexus_movil/models/estado_lote_tipo.dart';
import 'package:agro_nexus_movil/models/lote.dart';
import 'package:agro_nexus_movil/widgets/lotes/lote_detalles_mock.dart';
import 'package:agro_nexus_movil/widgets/lotes/lote_tabs_navigator.dart';
import 'package:flutter/material.dart';

class DetalleLoteScreen extends StatelessWidget {
  final Lote lote;
  final double produccionTotalKg;

  const DetalleLoteScreen({
    super.key,
    required this.lote,
    required this.produccionTotalKg,
  });

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF1B5E20);

    String cultivoNombre = "Sin definir";
    if (lote.cultivoid != null) {
      final cultivo = catalogosController.cultivos.firstWhere(
        (c) => c.cultivoid == lote.cultivoid,
        orElse: () => Cultivo(
          cultivoid: 0,
          nombre: "Desconocido",
        ),
      );

      cultivoNombre = cultivo.nombre;
    }

    String estadoNombre = "Sin estado";
    if (lote.estadolotetipoid != null) {
      final estado = catalogosController.estadoLoteTipos.firstWhere(
        (e) => e.estadolotetipoid == lote.estadolotetipoid,
        orElse: () => EstadoLoteTipo(
          estadolotetipoid: 0,
          nombre: "Desconocido",
        ),
      );

      estadoNombre = estado.nombre;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: Column(
        children: [
          Container(
            height: 105,
            decoration: BoxDecoration(
              color: primaryGreen,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 26),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            lote.nombre,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Detalle del lote',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: primaryGreen, // COLOR ÚNICO
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ───────────────────────────────────────────────
                        // TÍTULO + ESTADO
                        // ───────────────────────────────────────────────
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                lote.nombre,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                estadoNombre,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        // UBICACIÓN
                        Text(
                          lote.ubicacion ?? "Ubicación no especificada",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 12),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.white.withOpacity(0.25),
                        ),
                        const SizedBox(height: 14),

                        // ───────────────────────────────────────────────
                        // FILA: IZQUIERDA (Datos) + DERECHA (Imagen)
                        // ───────────────────────────────────────────────
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // IZQUIERDA → Superficie, Cultivo, Producción
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Superficie",
                                    style: TextStyle(color: Colors.white70, fontSize: 13),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${lote.superficie} ha",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  const Text(
                                    "Cultivo",
                                    style: TextStyle(color: Colors.white70, fontSize: 13),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    cultivoNombre,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  const Text(
                                    "Producción",
                                    style: TextStyle(color: Colors.white70, fontSize: 13),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${produccionTotalKg.toStringAsFixed(0)} kg",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            // DERECHA → Imagen
                            Expanded(
                              flex: 12,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: 180,
                                  color: Colors.white.withOpacity(0.15),
                                  child: (lote.imagenurl != null && lote.imagenurl!.isNotEmpty)
                                      ? Image.network(
                                          lote.imagenurl!,
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(
                                          Icons.image_not_supported_outlined,
                                          size: 60,
                                          color: Colors.white54,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ),
                  const SizedBox(height: 20),
                  LoteTabsNavigator(
                    lote: lote,
                    cultivoNombre: cultivoNombre,
                    estadoNombre: estadoNombre,
                    produccionTotalKg: produccionTotalKg,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}