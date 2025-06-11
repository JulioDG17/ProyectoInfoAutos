import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/coche_provider.dart';
import '../widgets/tarjeta_auto_resumida.dart';
import '../models/coche.dart';
import '../screens/detalle_inicio_screen.dart';

/// Pantalla principal que muestra la lista de todos los vehículos disponibles.
///
/// Cada coche se presenta mediante una tarjeta resumida (`TarjetaAutoResumida`).
/// Al pulsar sobre una tarjeta, se navega a la pantalla de detalles (`InicioDetalleScreen`).
class InicioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<CocheProvider>(context);
    final List<Coche> listaCoches = prov.todos;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: listaCoches.length,
      itemBuilder: (context, index) {
        final coche = listaCoches[index];

        /// Al tocar una tarjeta, se navega a una vista detallada del coche.
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => InicioDetalleScreen(coche: coche),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: TarjetaAutoResumida(coche: coche),
          ),
        );
      },
    );
  }
}
