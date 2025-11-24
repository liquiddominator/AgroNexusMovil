import 'package:agro_nexus_movil/models/destino_produccion.dart';
import 'package:agro_nexus_movil/models/estado_lote_insumo.dart';
import 'package:agro_nexus_movil/models/estado_lote_tipo.dart';
import 'package:agro_nexus_movil/models/tipo_actividad.dart';
import 'package:agro_nexus_movil/models/tipo_insumo.dart';
import 'package:agro_nexus_movil/models/unidad_medida.dart';
import '../services/catalogos_service.dart';
import '../models/prioridad.dart';
import '../models/cultivo.dart';

class CatalogosController {
  final CatalogosService _service = CatalogosService();

  bool loading = false;
  String? errorMessage;

  List<TipoActividad> tipoActividades = [];
  List<Prioridad> prioridades = [];
  List<TipoInsumo> tipoInsumos = [];
  List<UnidadMedida> unidadesMedida = [];
  List<Cultivo> cultivos = [];
  List<EstadoLoteTipo> estadoLoteTipos = [];
  List<DestinoProduccion> destinoProducciones = [];
  List<EstadoLoteInsumo> estadoLoteInsumos = [];

  Future<bool> cargarCatalogos(String token) async {
    loading = true;
    errorMessage = null;

    try {
      tipoActividades = (await _service.getTipoActividades(token))
          .map<TipoActividad>((json) => TipoActividad.fromJson(json))
          .toList();

      prioridades = (await _service.getPrioridades(token))
          .map<Prioridad>((json) => Prioridad.fromJson(json))
          .toList();

      tipoInsumos = (await _service.getTipoInsumos(token))
          .map<TipoInsumo>((json) => TipoInsumo.fromJson(json))
          .toList();

      unidadesMedida = (await _service.getUnidadesMedida(token))
          .map<UnidadMedida>((json) => UnidadMedida.fromJson(json))
          .toList();

      cultivos = (await _service.getCultivos(token))
          .map<Cultivo>((json) => Cultivo.fromJson(json))
          .toList();

      estadoLoteTipos = (await _service.getEstadoLoteTipos(token))
          .map<EstadoLoteTipo>((json) => EstadoLoteTipo.fromJson(json))
          .toList();

      destinoProducciones = (await _service.getDestinoProducciones(token))
          .map<DestinoProduccion>((json) => DestinoProduccion.fromJson(json))
          .toList();

      estadoLoteInsumos = (await _service.getEstadoLoteInsumos(token))
          .map<EstadoLoteInsumo>((json) => EstadoLoteInsumo.fromJson(json))
          .toList();

      loading = false;
      return true;
    } catch (e) {
      errorMessage = e.toString();
      loading = false;
      return false;
    }
  }
}