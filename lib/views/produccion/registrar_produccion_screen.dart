import 'dart:io';

import 'package:agro_nexus_movil/controllers/auth_controller.dart';
import 'package:agro_nexus_movil/controllers/catalogos_controller.dart';
import 'package:agro_nexus_movil/controllers/lote_controller.dart';
import 'package:agro_nexus_movil/controllers/produccion_controller.dart';
import 'package:agro_nexus_movil/models/lote.dart';
import 'package:agro_nexus_movil/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistrarProduccionScreen extends StatefulWidget {
  const RegistrarProduccionScreen({super.key});

  @override
  State<RegistrarProduccionScreen> createState() =>
      _RegistrarProduccionScreenState();
}

class _RegistrarProduccionScreenState
    extends State<RegistrarProduccionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _cantidadController = TextEditingController();
  final _fechaController = TextEditingController();
  final _observacionesController = TextEditingController();

  final _loteController = LoteController();
  final _catalogosController = CatalogosController();
  final _produccionController = ProduccionController();

  final _picker = ImagePicker();

  bool _loadingData = true;
  bool _saving = false;
  bool _uploadingImage = false;
  String? _error;

  List<Lote> _lotesUsuario = [];

  int? _loteId;
  int? _destinoProduccionId;
  DateTime? _fechaCosecha;

  // Imagen
  XFile? _selectedImage;
  String? _uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final token = authController.token;
    final usuario = authController.usuario;

    if (token == null || usuario == null) {
      setState(() {
        _loadingData = false;
        _error = 'No hay sesión activa.';
      });
      return;
    }

    try {
      await Future.wait([
        _loteController.cargarLotes(token),
        _catalogosController.cargarCatalogos(token),
      ]);

      final userId = usuario.usuarioid;

      _lotesUsuario = _loteController.lotes
          .where((l) => l.usuarioid == userId)
          .toList();

      setState(() {
        _loadingData = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _loadingData = false;
        _error = 'Error al cargar datos: $e';
      });
    }
  }

  Future<void> _seleccionarFecha() async {
    final ahora = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaCosecha ?? ahora,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('es', 'BO'),
    );

    if (picked != null) {
      setState(() {
        _fechaCosecha = picked;
        _fechaController.text =
            DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final usuario = authController.usuario;
      if (usuario == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sesión no válida.')),
        );
        return;
      }

      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        imageQuality: 85,
      );

      if (picked == null) return;

      setState(() {
        _selectedImage = picked;
        _uploadingImage = true;
      });

      final client = Supabase.instance.client;

      final bytes = await picked.readAsBytes();
      final ext = picked.path.split('.').last;
      final fileName =
          'produccion_${usuario.usuarioid}_${DateTime.now().millisecondsSinceEpoch}.$ext';
      final filePath =
          '${ApiConstants.supabaseProduccionesFolder}/$fileName';

      await client.storage
          .from(ApiConstants.supabaseBucket)
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
              contentType: 'image/*',
            ),
          );

      final publicUrl = client.storage
          .from(ApiConstants.supabaseBucket)
          .getPublicUrl(filePath);

      setState(() {
        _uploadedImageUrl = publicUrl;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagen subida correctamente')),
        );
      }
    } catch (e) {
      setState(() {
        _selectedImage = null;
        _uploadedImageUrl = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir imagen: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _uploadingImage = false;
        });
      }
    }
  }

  Future<void> _guardarProduccion() async {
    if (!_formKey.currentState!.validate()) return;

    if (_loteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un lote.')),
      );
      return;
    }

    if (_destinoProduccionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona el destino de la producción.')),
      );
      return;
    }

    if (_fechaCosecha == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona la fecha de cosecha.')),
      );
      return;
    }

    if (_uploadingImage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Espera a que termine de subir la imagen.'),
        ),
      );
      return;
    }

    final cantidad = double.tryParse(_cantidadController.text.trim());
    if (cantidad == null || cantidad <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cantidad inválida.')),
      );
      return;
    }

    final token = authController.token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesión no válida.')),
      );
      return;
    }

    final body = <String, dynamic>{
      'loteid': _loteId,
      'cantidadkg': cantidad,
      'fechacosecha':
          DateFormat('yyyy-MM-dd').format(_fechaCosecha!),
      'destinoproduccionid': _destinoProduccionId,
    };

    if (_observacionesController.text.trim().isNotEmpty) {
      body['observaciones'] = _observacionesController.text.trim();
    }
    if (_uploadedImageUrl != null) {
      body['imagenurl'] = _uploadedImageUrl;
    }

    setState(() {
      _saving = true;
    });

    final ok = await _produccionController.crearProduccion(body, token);

    setState(() {
      _saving = false;
    });

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producción guardada correctamente')),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _produccionController.errorMessage ??
                'No se pudo guardar la producción',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _fechaController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  const primaryGreen = Color(0xFF1B5E20);

  return Scaffold(
    backgroundColor: const Color(0xFFEEEEEE),
    body: Column(
      children: [
        // ========= HEADER PERSONALIZADO (sin AppBar) =========
        Container(
          height: 105, // ⬅️ aquí controlas qué tan abajo llega el header
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
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 26),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Registrar Producción',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Registra los datos de tu cosecha',
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

        // ========= CONTENIDO =========
        Expanded(
          child: _loadingData
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ============================
                            // CARD DE INSTRUCCIONES
                            // ============================
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1B5E20),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.info,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      'Registra los datos de tu cosecha para llevar un control detallado de la producción de tus lotes.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        height: 1.4,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // ============================
                            // CARD CONTENEDOR DEL FORMULARIO
                            // ============================
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(
                                  16, 18, 16, 24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ================== SELECCIONAR LOTE ==================
                                  Text(
                                    'Seleccionar Lote *',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<int>(
                                    value: _loteId,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 10),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                    items: _lotesUsuario
                                        .map(
                                          (l) => DropdownMenuItem<int>(
                                            value: l.loteid,
                                            child: Text(l.nombre),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _loteId = value;
                                      });
                                    },
                                    validator: (v) {
                                      if (v == null) {
                                        return 'Selecciona un lote';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  // ================== CANTIDAD ==================
                                  Text(
                                    'Cantidad Cosechada (kg) *',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _cantidadController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration: InputDecoration(
                                      hintText: 'Ej: 580',
                                      suffixIcon: Icon(
                                        Icons.filter_frames,
                                        color: Colors.grey.shade600,
                                        size: 20,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 12),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'La cantidad es obligatoria';
                                      }
                                      final value =
                                          double.tryParse(v.trim());
                                      if (value == null || value <= 0) {
                                        return 'Ingrese una cantidad válida';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  // ================== FECHA ==================
                                  Text(
                                    'Fecha de Cosecha *',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _fechaController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      hintText: 'Selecciona la fecha',
                                      suffixIcon: Icon(
                                        Icons.calendar_today,
                                        color: Colors.grey.shade600,
                                        size: 20,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 12),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                    onTap: _seleccionarFecha,
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'La fecha es obligatoria';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  // ================== DESTINO DE PRODUCCIÓN ==================
                                  Text(
                                    'Destino de la Producción *',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Column(
                                    children: _catalogosController
                                        .destinoProducciones
                                        .map(
                                          (d) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              onTap: () {
                                                setState(() {
                                                  _destinoProduccionId =
                                                      d.destinoproduccionid;
                                                });
                                              },
                                              child: Container(
                                                height: 46,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: _destinoProduccionId ==
                                                            d.destinoproduccionid
                                                        ? const Color(
                                                            0xFF2E7D32)
                                                        : Colors
                                                            .grey.shade300,
                                                  ),
                                                  color: _destinoProduccionId ==
                                                          d.destinoproduccionid
                                                      ? const Color(
                                                          0xFFE8F5E9)
                                                      : Colors.white,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      d.nombre
                                                                  .toLowerCase() ==
                                                              'venta'
                                                          ? Icons.attach_money
                                                          : d.nombre
                                                                      .toLowerCase() ==
                                                                  'consumo'
                                                              ? Icons.restaurant
                                                              : d.nombre.toLowerCase() ==
                                                                      'almacenamiento'
                                                                  ? Icons
                                                                      .inventory_2
                                                                  : Icons
                                                                      .more_horiz,
                                                      size: 20,
                                                      color: const Color(
                                                          0xFF2E7D32),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      d.nombre,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xFF2E7D32),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),

                                  const SizedBox(height: 10),

                                  // ================== OBSERVACIONES ==================
                                  Text(
                                    'Observaciones',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _observacionesController,
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      hintText:
                                          'Agrega notas adicionales sobre la cosecha (opcional)',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 10),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // ================== FOTO ==================
                                  Text(
                                    'Foto de la Producción (Opcional)',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: _uploadingImage
                                        ? null
                                        : _pickAndUploadImage,
                                    child: Container(
                                      height: 130,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      child: Center(
                                        child: _selectedImage == null
                                            ? Column(
                                                mainAxisSize:
                                                    MainAxisSize.min,
                                                children: [
                                                  if (_uploadingImage)
                                                    const SizedBox(
                                                      width: 22,
                                                      height: 22,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                    )
                                                  else
                                                    Icon(
                                                      Icons
                                                          .camera_alt_outlined,
                                                      size: 30,
                                                      color: Colors
                                                          .grey.shade600,
                                                    ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    _uploadingImage
                                                        ? 'Subiendo imagen...'
                                                        : 'Toca para subir una foto',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors
                                                          .grey.shade600,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.file(
                                                  File(_selectedImage!.path),
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // ================== BOTONES ==================
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      onPressed: _saving
                                          ? null
                                          : () {
                                              Navigator.of(context).pop();
                                            },
                                      style: OutlinedButton.styleFrom(
                                        padding:
                                            const EdgeInsets.symmetric(
                                                vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        side: BorderSide(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      child: Text(
                                        'Cancelar',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: _saving
                                          ? null
                                          : _guardarProduccion,
                                      icon: _saving
                                          ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child:
                                                  CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Icon(Icons.check,
                                              color: Colors.white),
                                      label: Text(
                                        _saving
                                            ? 'Guardando...'
                                            : 'Guardar Producción',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF1B5E20),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 13),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        elevation: 0,
                                      ),
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
      ],
    ),
  );
}
}