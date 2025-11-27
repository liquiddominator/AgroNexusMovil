import 'dart:io';

import 'package:agro_nexus_movil/utils/constants.dart';
import 'package:agro_nexus_movil/utils/location_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:agro_nexus_movil/controllers/auth_controller.dart';
import 'package:agro_nexus_movil/controllers/lote_controller.dart';
import 'package:agro_nexus_movil/controllers/catalogos_controller.dart';

class RegistrarLoteScreen extends StatefulWidget {
  const RegistrarLoteScreen({super.key});

  @override
  State<RegistrarLoteScreen> createState() => _RegistrarLoteScreenState();
}

class _RegistrarLoteScreenState extends State<RegistrarLoteScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _superficieController = TextEditingController();
  final _fechaSiembraController = TextEditingController();

  // ya no usaremos estos campos para escribir manualmente,
  // pero los dejamos por si quieres mostrar texto luego.
  final _latitudController = TextEditingController();
  final _longitudController = TextEditingController();

  final _loteController = LoteController();
  final _catalogosController = CatalogosController();

  final _picker = ImagePicker();

  bool _loadingCatalogos = true;
  bool _saving = false;

  // Imagen
  XFile? _selectedImage;
  String? _uploadedImageUrl;
  bool _uploadingImage = false;

  int? _cultivoId;
  int? _estadoLoteTipoId;
  DateTime? _fechaSiembra;

  // Mapa
  GoogleMapController? _mapController;
  LatLng _initialMapPos = const LatLng(-17.7833, -63.1821); // Santa Cruz
  LatLng? _selectedLatLng; // aquí se guarda la ubicación elegida

  @override
  void initState() {
    super.initState();
    _cargarCatalogos();
    _cargarUbicacionInicial();
  }

  Future<void> _cargarCatalogos() async {
    final token = authController.token;
    if (token == null) {
      setState(() {
        _loadingCatalogos = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay sesión activa.')),
        );
      }
      return;
    }

    final ok = await _catalogosController.cargarCatalogos(token);
    setState(() {
      _loadingCatalogos = false;
    });

    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _catalogosController.errorMessage ??
                'Error al cargar catálogos',
          ),
        ),
      );
    }
  }

  Future<void> _cargarUbicacionInicial() async {
    final loc = await LocationHelper.getUserLocation();
    if (!mounted || loc == null || loc.latitude == null || loc.longitude == null) {
      return;
    }

    final pos = LatLng(loc.latitude!, loc.longitude!);

    setState(() {
      _initialMapPos = pos;
      _selectedLatLng = pos;
      _latitudController.text = pos.latitude.toStringAsFixed(6);
      _longitudController.text = pos.longitude.toStringAsFixed(6);
    });

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(pos, 15),
      );
    }
  }

  Future<void> _seleccionarFechaSiembra() async {
    final ahora = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaSiembra ?? ahora,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('es', 'BO'),
    );
    if (picked != null) {
      setState(() {
        _fechaSiembra = picked;
        _fechaSiembraController.text =
            DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _usarUbicacionActual() async {
    final loc = await LocationHelper.getUserLocation();
    if (loc == null || loc.latitude == null || loc.longitude == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo obtener la ubicación.'),
        ),
      );
      return;
    }

    final pos = LatLng(loc.latitude!, loc.longitude!);

    setState(() {
      _selectedLatLng = pos;
      _latitudController.text = pos.latitude.toStringAsFixed(6);
      _longitudController.text = pos.longitude.toStringAsFixed(6);
    });

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(pos, 15),
      );
    }
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedLatLng = position;
      _latitudController.text = position.latitude.toStringAsFixed(6);
      _longitudController.text = position.longitude.toStringAsFixed(6);
    });
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
          'lote_${usuario.usuarioid}_${DateTime.now().millisecondsSinceEpoch}.$ext';
      final filePath = '${ApiConstants.supabaseLotesFolder}/$fileName';

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

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final token = authController.token;
    final usuario = authController.usuario;
    if (token == null || usuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesión no válida.')),
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

    final superficie = double.tryParse(_superficieController.text.trim());
    if (superficie == null || superficie <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Superficie inválida.')),
      );
      return;
    }

    // Latitud / longitud desde el mapa
    final lat = _selectedLatLng?.latitude;
    final lon = _selectedLatLng?.longitude;

    final body = <String, dynamic>{
      'usuarioid': usuario.usuarioid,
      'nombre': _nombreController.text.trim(),
      'superficie': superficie,
    };

    if (_ubicacionController.text.trim().isNotEmpty) {
      body['ubicacion'] = _ubicacionController.text.trim();
    }
    if (_cultivoId != null) {
      body['cultivoid'] = _cultivoId;
    }
    if (_fechaSiembra != null) {
      body['fechasiembra'] =
          DateFormat('yyyy-MM-dd').format(_fechaSiembra!);
    }
    if (_estadoLoteTipoId != null) {
      body['estadolotetipoid'] = _estadoLoteTipoId;
    }
    if (lat != null) body['latitud'] = lat;
    if (lon != null) body['longitud'] = lon;
    if (_uploadedImageUrl != null) {
      body['imagenurl'] = _uploadedImageUrl;
    }

    setState(() {
      _saving = true;
    });

    final ok = await _loteController.crearLote(body, token);

    setState(() {
      _saving = false;
    });

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lote registrado correctamente')),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _loteController.errorMessage ??
                'No se pudo registrar el lote',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _ubicacionController.dispose();
    _superficieController.dispose();
    _fechaSiembraController.dispose();
    _latitudController.dispose();
    _longitudController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Lote'),
      ),
      body: _loadingCatalogos
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nombreController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre del lote *',
                            hintText: 'Ej: Lote San Miguel',
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'El nombre es obligatorio';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _ubicacionController,
                          decoration: const InputDecoration(
                            labelText: 'Ubicación',
                            hintText: 'Ej: Sector Norte, Parcela 15',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _superficieController,
                          keyboardType:
                              const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Superficie (ha) *',
                            hintText: 'Ej: 25.5',
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'La superficie es obligatoria';
                            }
                            final value = double.tryParse(v.trim());
                            if (value == null || value <= 0) {
                              return 'Ingrese una superficie válida';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<int>(
                          value: _cultivoId,
                          decoration: const InputDecoration(
                            labelText: 'Cultivo',
                          ),
                          items: _catalogosController.cultivos
                              .map(
                                (c) => DropdownMenuItem<int>(
                                  value: c.cultivoid,
                                  child: Text(c.nombre),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _cultivoId = value;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _fechaSiembraController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Fecha de siembra',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: _seleccionarFechaSiembra,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<int>(
                          value: _estadoLoteTipoId,
                          decoration: const InputDecoration(
                            labelText: 'Estado inicial del lote',
                          ),
                          items: _catalogosController.estadoLoteTipos
                              .map(
                                (e) => DropdownMenuItem<int>(
                                  value: e.estadolotetipoid,
                                  child: Text(e.nombre),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _estadoLoteTipoId = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // ================= MAPA PARA ELEGIR LAT/LON =================
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Ubicación del lote',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 230,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: _selectedLatLng ?? _initialMapPos,
                                zoom: 14,
                              ),
                              myLocationEnabled: true,
                              myLocationButtonEnabled: false,
                              markers: _selectedLatLng == null
                                  ? {}
                                  : {
                                      Marker(
                                        markerId: const MarkerId('lote_position'),
                                        position: _selectedLatLng!,
                                      ),
                                    },
                              onMapCreated: (controller) {
                                _mapController = controller;
                              },
                              onTap: _onMapTap,

                              // 👇 Esto hace que el mapa “gane” todos los gestos
                              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                                Factory<OneSequenceGestureRecognizer>(
                                  () => EagerGestureRecognizer(),
                                ),
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _usarUbicacionActual,
                              icon: const Icon(Icons.my_location),
                              label: const Text('Usar mi ubicación'),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _selectedLatLng == null
                                    ? 'Toca el mapa para elegir la ubicación del lote.'
                                    : 'Lat: ${_latitudController.text}  ·  Lon: ${_longitudController.text}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // --------- PICKER DE IMAGEN + PREVIEW ----------
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Imagen del lote (opcional)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            if (_selectedImage != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(_selectedImage!.path),
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  color: Colors.grey.shade100,
                                ),
                                child: const Icon(Icons.image, size: 30),
                              ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: _uploadingImage
                                        ? null
                                        : _pickAndUploadImage,
                                    icon: _uploadingImage
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child:
                                                CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Icon(Icons.upload_file),
                                    label: Text(
                                      _uploadingImage
                                          ? 'Subiendo imagen...'
                                          : (_uploadedImageUrl == null
                                              ? 'Seleccionar imagen del lote'
                                              : 'Cambiar imagen'),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _uploadedImageUrl == null
                                        ? 'Puedes subir una foto de tu lote (opcional).'
                                        : 'Imagen subida correctamente.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _saving ? null : _guardar,
                            icon: _saving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.save),
                            label: Text(
                              _saving ? 'Guardando...' : 'Guardar lote',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}