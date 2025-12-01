import 'package:agro_nexus_movil/views/actividades/calendario_actividades_screen.dart';
import 'package:agro_nexus_movil/views/actividades/misactividades_screen.dart';
import 'package:agro_nexus_movil/views/clima/dashboard_climatico_screen.dart';
import 'package:agro_nexus_movil/views/inicio/dashboard_principal_screen.dart';
import 'package:agro_nexus_movil/views/inventario/misinsumos_screen.dart';
import 'package:agro_nexus_movil/views/lotes/lista_mislotes_screen.dart';
import 'package:agro_nexus_movil/views/produccion/historial_miproduccion_screen.dart';
import 'package:agro_nexus_movil/views/reportes/misreportes_screen.dart';
import 'package:agro_nexus_movil/views/ventas/misventas_screen.dart';
import 'package:flutter/material.dart';
import 'package:agro_nexus_movil/widgets/menu_navegacion/agronexus_drawer.dart';
import 'package:agro_nexus_movil/widgets/menu_navegacion/agro_menu_item.dart';

class AgroNexusHomeShell extends StatefulWidget {
  const AgroNexusHomeShell({super.key});

  @override
  State<AgroNexusHomeShell> createState() => _AgroNexusHomeShellState();
}

class _AgroNexusHomeShellState extends State<AgroNexusHomeShell> {
  AgroMenuItem _selected = AgroMenuItem.inicio;

  Widget _buildBody() {
    switch (_selected) {
      case AgroMenuItem.inicio:
        return DashboardPrincipalContent(
          onQuickNav: (item) {
            setState(() => _selected = item);
          },
        );
      case AgroMenuItem.lotes:
        return const MiListaLotesContent();
      case AgroMenuItem.produccion:
        return const MiHistorialProduccionContent();
      case AgroMenuItem.actividades:
        return const MisActividadesContent();
      case AgroMenuItem.inventario:
        return const MisInsumosContent();
      case AgroMenuItem.clima:
        return const DashboardClimaticoContent();
      case AgroMenuItem.ventas:
        return const MisVentasContent();
      case AgroMenuItem.reportes:
        return const MisReportesContent();
    }
  }

  String _titleFor(AgroMenuItem item) {
    switch (item) {
      case AgroMenuItem.inicio:
        return 'Inicio';
      case AgroMenuItem.lotes:
        return 'Lotes';
      case AgroMenuItem.produccion:
        return 'Producción';
      case AgroMenuItem.actividades:
        return 'Actividades';
      case AgroMenuItem.inventario:
        return 'Inventario';
      case AgroMenuItem.clima:
        return 'Clima';
      case AgroMenuItem.ventas:
        return 'Ventas';
      case AgroMenuItem.reportes:
        return 'Reportes';
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF1B5E20);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90), // ⬆️ MÁS ALTO
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), // ⬆️ padding vertical
              child: Row(
                children: [
                  // Botón del menú
                  Builder(
                    builder: (ctx) => IconButton(
                      icon: const Icon(Icons.menu, color: primaryGreen),
                      onPressed: () => Scaffold.of(ctx).openDrawer(),
                    ),
                  ),

                  // Título
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        _titleFor(_selected),
                        style: const TextStyle(
                          color: primaryGreen,
                          fontSize: 22,        // ⬆️ subtile aumento en tamaño
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  // Botón de calendario (solo en Actividades)
                  if (_selected == AgroMenuItem.actividades)
                    IconButton(
                      icon: const Icon(
                        Icons.calendar_month,
                        color: primaryGreen,
                        size: 26,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CalendarioActividadesScreen(),
                          ),
                        );
                      },
                    ),
                  // Botón de configuración
                  IconButton(
                    icon: const Icon(Icons.settings, color: primaryGreen, size: 26),
                    onPressed: () {
                      Navigator.pushNamed(context, '/configuracion');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      drawer: AgroNexusDrawer(
        selected: _selected,
        onItemSelected: (item) {
          setState(() => _selected = item);
          Navigator.of(context).pop(); // solo cerrar el drawer
        },
      ),
      backgroundColor: const Color(0xFFF7F8F8),
      body: _buildBody(),
    );
  }
}