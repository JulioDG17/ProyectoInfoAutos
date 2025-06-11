import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/coche_provider.dart';
import '../widgets/search_auto_delegate.dart';
import '../widgets/tarjeta_auto_comparador.dart';
import '../models/coche.dart';

/// Pantalla que permite al usuario comparar dos coches.
/// Incluye buscadores individuales para cada coche, visualización en tarjetas
/// y botones para eliminar individualmente cada vehículo seleccionado.
class ComparadorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<CocheProvider>(context);
    final Coche? c1 = prov.comparado1;
    final Coche? c2 = prov.comparado2;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          /// Botones para seleccionar los coches a comparar.
          /// Se utiliza un buscador personalizado mediante [SearchAutoDelegate].
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final Coche? resultado = await showSearch<Coche?>(
                      context: context,
                      delegate: SearchAutoDelegate(prov.todos),
                    );
                    if (resultado != null) prov.asignarComparado(1, resultado);
                  },
                  child: Text(
                    c1 == null
                        ? 'Seleccionar auto 1'
                        : '${c1.marca} ${c1.modelo}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final Coche? resultado = await showSearch<Coche?>(
                      context: context,
                      delegate: SearchAutoDelegate(prov.todos),
                    );
                    if (resultado != null) prov.asignarComparado(2, resultado);
                  },
                  child: Text(
                    c2 == null
                        ? 'Seleccionar auto 2'
                        : '${c2.marca} ${c2.modelo}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// Tarjetas comparativas lado a lado.
          /// Si no hay coche seleccionado, se muestra un mensaje de marcador de posición.
          /// Debajo de cada tarjeta aparece un botón de "Quitar" centrado, con fondo rojo.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    c1 == null
                        ? _placeholderTexto('Ningún auto 1 seleccionado', cs, tt)
                        : TarjetaAutoComparador(coche: c1),
                    const SizedBox(height: 6),
                    if (c1 != null)
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => prov.asignarComparado(1, null),
                          icon: const Icon(Icons.delete, size: 18, color: Colors.black54),
                          label: const Text('Quitar', style: TextStyle(color: Colors.black54)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cs.error,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    c2 == null
                        ? _placeholderTexto('Ningún auto 2 seleccionado', cs, tt)
                        : TarjetaAutoComparador(coche: c2),
                    const SizedBox(height: 6),
                    if (c2 != null)
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => prov.asignarComparado(2, null),
                          icon: const Icon(Icons.delete, size: 18, color: Colors.black54),
                          label: const Text('Quitar', style: TextStyle(color: Colors.black54)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cs.error,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Devuelve un contenedor con texto para mostrar cuando no hay coche seleccionado.
  ///
  /// [texto] define el contenido del mensaje.
  /// [cs] es el esquema de color para aplicar opacidad.
  /// [tt] es el tema de texto para aplicar estilo tipográfico.
  Widget _placeholderTexto(String texto, ColorScheme cs, TextTheme tt) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: Text(
        texto,
        style: tt.bodyMedium?.copyWith(
          color: cs.onSurface.withOpacity(0.7),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
