import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/coche.dart';
import '../providers/coche_provider.dart';
import '../utils/assets_logo.dart';

/// Widget que representa una tarjeta comparativa de un coche.
///
/// Muestra los datos técnicos del vehículo, su logo, y un botón para
/// marcarlo o desmarcarlo como favorito. Además, presenta una lista
/// de características del coche en forma de chips.
///
/// Está diseñado para usarse dentro de la pantalla de comparación.
class TarjetaAutoComparador extends StatelessWidget {
  final Coche coche;

  /// Constructor que recibe un objeto `Coche` a representar.
  const TarjetaAutoComparador({Key? key, required this.coche}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<CocheProvider>(context);
    final bool esFav = prov.esFavorito(coche);

    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: cs.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            /// Cabecera con marca, modelo, año y boton de favorito
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${coche.marca} ${coche.modelo} (${coche.anioFabricacion})',
                    style: tt.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    esFav ? Icons.favorite : Icons.favorite_border,
                    color: esFav ? cs.secondary : cs.onSurface.withOpacity(0.5),
                  ),
                  onPressed: () {
                    final estabaEnFav = prov.esFavorito(coche);
                    prov.alternarFavorito(coche);

                    final mensaje = estabaEnFav
                        ? '✘ Eliminado de favoritos'
                        : '🚘 Añadido a favoritos';

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(mensaje),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// Logo de la marca
            Center(
              child: Image.asset(
                logoPath(coche.marca),
                width: 80,
                height: 80,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.directions_car,
                  size: 80,
                  color: cs.onSurface.withOpacity(0.3),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// Detalles técnicos del vehículo.
            _detalle('Motor', coche.tipoMotor, tt, cs),
            _detalle('Cilindrada', '${coche.cilindrada.toStringAsFixed(1)} L', tt, cs),
            _detalle('Potencia', '${coche.potenciaCV} CV', tt, cs),
            _detalle('Transmisión', coche.tipoTransmision, tt, cs),
            _detalle('Consumo', '${coche.consumo.toStringAsFixed(1)} L/100km', tt, cs),
            _detalle('Puertas', '${coche.numPuertas}', tt, cs),
            _detalle('Plazas', '${coche.numPlazas}', tt, cs),
            _detalle('Combustible', coche.tipoCombustible, tt, cs),
            _detalle('Maletero', '${coche.volumenMaletero} L', tt, cs),
            _detalle('Precio base', '${coche.precioBase} €', tt, cs),

            const SizedBox(height: 12),

            /// Características especiales del vehículo en forma de chips.
            Text(
              'Características:',
              style: tt.titleMedium?.copyWith(color: cs.onSurface),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: -8,
              children: coche.listaCaracteristicas.map((carac) {
                return Chip(
                  label: Text(
                    carac,
                    style: tt.labelSmall?.copyWith(color: cs.onSecondary),
                  ),
                  backgroundColor: cs.secondary,
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget auxiliar para mostrar un dato técnico con su título.
  Widget _detalle(String titulo, String valor, TextTheme tt, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        '$titulo: $valor',
        style: tt.bodyMedium?.copyWith(color: cs.onSurface),
      ),
    );
  }
}
