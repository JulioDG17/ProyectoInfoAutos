import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/coche.dart';
import '../providers/coche_provider.dart';
import '../utils/assets_logo.dart';

/// Widget que representa una tarjeta informativa completa de un coche.
///
/// Muestra los datos técnicos del vehículo, el logo de la marca,
/// características en forma de chips y permite marcar o desmarcar como favorito.
///
/// Es utilizado en múltiples contextos: pantalla de inicio, favoritos y comparador.
class TarjetaAutoCompleta extends StatelessWidget {
  final Coche coche;

  /// Constructor que recibe el coche a representar.
  const TarjetaAutoCompleta({Key? key, required this.coche}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<CocheProvider>(context);
    final bool esFav = prov.esFavorito(coche);

    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 4,
      color: cs.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            /// Cabecera con marca, modelo, año de fabricación y botón favorito.
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
                    color: esFav
                        ? cs.secondary
                        : cs.onSurface.withOpacity(0.5),
                    size: 28,
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

            const SizedBox(height: 12),

            /// Cuerpo con detalles tecnicos del coche y logo de la marca
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Detalles técnicos en columna
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Logo de la marca
                Image.asset(
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
              ],
            ),

            const SizedBox(height: 16),

            /// Caracteristicas en formato Chip.
            Text(
              'Características:',
              style: tt.titleMedium?.copyWith(color: cs.onSurface),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: -8,
              children: coche.listaCaracteristicas.map(
                    (carac) => Chip(
                  label: Text(
                    carac,
                    style: tt.labelSmall?.copyWith(color: cs.onSecondary),
                  ),
                  backgroundColor: cs.secondary,
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget auxiliar para mostrar un campo técnico con su valor.
  ///
  /// @param titulo Texto que representa el nombre del campo.
  /// @param valor Valor del dato correspondiente.
  /// @param tt Tema de texto.
  /// @param cs Esquema de color actual.
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
