import 'package:flutter/material.dart';
import 'package:agro_nexus_movil/controllers/auth_controller.dart';
import 'package:agro_nexus_movil/models/usuarios.dart';
import 'package:agro_nexus_movil/widgets/menu_navegacion/agro_menu_item.dart';

class AgroNexusDrawer extends StatelessWidget {
  final AgroMenuItem selected;
  final ValueChanged<AgroMenuItem> onItemSelected;

  const AgroNexusDrawer({
    super.key,
    required this.selected,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    const drawerBg = Color(0xFF18253A);

    final Usuario? usuario = authController.usuario;

    final String nombreCompleto = usuario != null
        ? '${usuario.nombre} ${usuario.apellido}'.trim()
        : 'Usuario invitado';

    final String rol = usuario?.informacionadicional?.isNotEmpty == true
        ? usuario!.informacionadicional!
        : 'Agricultor';

    return Drawer(
      child: Container(
        color: drawerBg,
        child: SafeArea(
          child: Column(
            children: [
              // HEADER SUPERIOR
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'AgroNexus',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Gestión de cultivos',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ITEMS DE MENÚ
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildNavItem(
                      context,
                      item: AgroMenuItem.inicio,
                      label: 'Inicio',
                      icon: Icons.home_outlined,
                    ),
                    _buildNavItem(
                      context,
                      item: AgroMenuItem.lotes,
                      label: 'Lotes',
                      icon: Icons.landscape_outlined,
                    ),
                    _buildNavItem(
                      context,
                      item: AgroMenuItem.produccion,
                      label: 'Producción',
                      icon: Icons.agriculture_outlined,
                    ),
                    _buildNavItem(
                      context,
                      item: AgroMenuItem.actividades,
                      label: 'Actividades',
                      icon: Icons.check_circle_outline,
                    ),
                    _buildNavItem(
                      context,
                      item: AgroMenuItem.inventario,
                      label: 'Inventario',
                      icon: Icons.inventory_2_outlined,
                    ),
                    _buildNavItem(
                      context,
                      item: AgroMenuItem.clima,
                      label: 'Clima',
                      icon: Icons.cloud_outlined,
                    ),
                    _buildNavItem(
                      context,
                      item: AgroMenuItem.ventas,
                      label: 'Ventas',
                      icon: Icons.attach_money,
                    ),
                    _buildNavItem(
                      context,
                      item: AgroMenuItem.reportes,
                      label: 'Reportes',
                      icon: Icons.bar_chart_outlined,
                    ),
                  ],
                ),
              ),

              // FOOTER CON IMAGEN + NOMBRE + ROL + LOGOUT
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF121D30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      offset: const Offset(0, -1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFF1B5E20),
                      backgroundImage: usuario?.imagenurl != null
                          ? NetworkImage(usuario!.imagenurl!)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nombreCompleto,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            rol,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final shouldLogout = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Cerrar sesión'),
                            content: const Text(
                                '¿Seguro que deseas cerrar sesión?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: const Text(
                                  'Cerrar sesión',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (shouldLogout != true) return;

                        await authController.logout();

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login',
                          (route) => false,
                        );
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white70,
                        size: 20,
                      ),
                      tooltip: 'Cerrar sesión',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required AgroMenuItem item,
    required String label,
    required IconData icon,
  }) {
    const selectedBg = Color(0xFF1B5E20);
    const selectedText = Colors.white;
    const defaultText = Colors.white70;

    final bool isSelected = selected == item;

    return Material(
      color: isSelected ? selectedBg : Colors.transparent,
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          color: isSelected ? selectedText : defaultText,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? selectedText : defaultText,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        onTap: () {
          onItemSelected(item);
        },
      ),
    );
  }
}