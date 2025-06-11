import 'package:flutter/material.dart';
import '../models/coche.dart';
import '../widgets/tarjeta_auto_completa.dart';

/// Pantalla de detalle para un coche específico.
///
/// Muestra una vista completa de la información técnica y características del vehículo
/// seleccionado desde la pantalla de inicio. Incluye un botón de retroceso en la AppBar.
///
/// Utiliza el widget `TarjetaAutoCompleta` para mostrar todos los datos del coche.
class InicioDetalleScreen extends StatelessWidget {
  final Coche coche;

  /// Constructor que recibe el coche a mostrar en detalle.
  const InicioDetalleScreen({Key? key, required this.coche}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('${coche.marca} ${coche.modelo}'),
        leading: BackButton(color: cs.onPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: TarjetaAutoCompleta(coche: coche),
      ),
    );
  }
}
