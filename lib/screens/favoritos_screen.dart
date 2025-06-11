import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/coche_provider.dart';
import '../widgets/tarjeta_auto_completa.dart';
import '../models/coche.dart';

/// Pantalla que muestra la lista de vehículos marcados como favoritos.
///
/// Si la lista está vacía, se presenta un mensaje informativo con un ícono.
/// Si hay coches favoritos, se muestran como tarjetas completas con su información.
///
/// Utiliza `TarjetaAutoCompleta` para mostrar los detalles de cada coche.
class FavoritosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<CocheProvider>(context);
    final List<Coche> listaFav = prov.favoritos;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

     /// Muestra mensaje de estado si no hay favoritos registrados.
     if (listaFav.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sentiment_dissatisfied,
                size: 64, color: cs.secondary),
            const SizedBox(height: 16),
            Text(
              'No tienes autos en favoritos',
              style: tt.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    /// Muestra la lista de coches favoritos en forma de tarjetas.
    return Container(
      color: cs.background,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: listaFav.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final coche = listaFav[index];
          return TarjetaAutoCompleta(coche: coche);
        },
      ),
    );
  }
}
