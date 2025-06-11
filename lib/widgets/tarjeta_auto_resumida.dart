import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/coche.dart';
import '../providers/coche_provider.dart';
import '../utils/assets_logo.dart';

/// Widget que representa una tarjeta resumida de un coche.
///
/// Muestra brevemente la marca, el modelo, el tipo de motor y la transmisión,
/// junto con el logo de la marca y un botón para marcarlo o desmarcarlo como favorito.
///
/// Este widget es ideal para listas como la pantalla de inicio.
class TarjetaAutoResumida extends StatelessWidget {
  final Coche coche;

  /// Constructor que recibe el coche a mostrar de forma resumida.
  const TarjetaAutoResumida({Key? key, required this.coche}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<CocheProvider>(context);
    final bool esFav = prov.esFavorito(coche);

    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      color: cs.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

        /// Título: Marca y modelo, junto al logo de la marca.
        title: Row(
          children: [
            Expanded(
              child: Text(
                '${coche.marca} ${coche.modelo}',
                style: tt.titleLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Image.asset(
              logoPath(coche.marca),
              width: 30,
              height: 30,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                Icons.directions_car,
                size: 30,
                color: cs.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),

        /// Subtítulo con tipo de motor y transmisión.
        subtitle: Text(
          '${coche.tipoMotor} • ${coche.tipoTransmision}',
          style: tt.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.7)),
        ),

        /// Botón de favorito con efecto visual mediante SnackBar.
        trailing: IconButton(
          icon: Icon(
            esFav ? Icons.favorite : Icons.favorite_border,
            color: esFav ? cs.secondary : cs.onSurface.withOpacity(0.5),
            size: 26,
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
      ),
    );
  }
}
