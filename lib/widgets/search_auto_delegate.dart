import 'package:flutter/material.dart';
import '../models/coche.dart';
import '../utils/assets_logo.dart';

/// Delegate personalizado para realizar búsquedas de coches por marca o modelo.
///
/// Utiliza la clase `SearchDelegate` de Flutter para crear una interfaz
/// de búsqueda que filtra dinámicamente los resultados y permite seleccionar
/// un coche desde cualquier parte de la app.
class SearchAutoDelegate extends SearchDelegate<Coche?> {
  final List<Coche> listaCoches;

  /// Constructor que recibe la lista de coches disponibles para buscar.
  SearchAutoDelegate(this.listaCoches);

  @override
  String? get searchFieldLabel => 'Buscar marca o modelo';

  /// Personaliza el tema de la barra de búsqueda, incluyendo colores y tipografía.
  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return theme.copyWith(
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        backgroundColor: cs.primary,
        iconTheme: IconThemeData(color: cs.onPrimary),
        titleTextStyle: TextStyle(
          color: cs.onPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: cs.onPrimary.withOpacity(0.7)),
        border: InputBorder.none,
      ),
      textTheme: theme.textTheme.copyWith(
        titleMedium: TextStyle(color: cs.onBackground),
      ),
    );
  }

  /// Muestra el botón de limpiar búsqueda si el campo `query` no está vacío.
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          color: Theme.of(context).colorScheme.onPrimary,
          onPressed: () => query = '',
        ),
    ];
  }

  /// Botón de regreso (flecha hacia atrás) para cerrar el buscador.
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      color: Theme.of(context).colorScheme.onPrimary,
      onPressed: () => close(context, null),
    );
  }

  /// Muestra los resultados de búsqueda que coinciden con la consulta.
  ///
  /// Los resultados se muestran con el logo de la marca, datos básicos del coche
  /// y un botón para seleccionarlo.
  @override
  Widget buildResults(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final resultados = listaCoches.where((coche) {
      final texto = '${coche.marca} ${coche.modelo}'.toLowerCase();
      return texto.contains(query.toLowerCase());
    }).toList();

    if (resultados.isEmpty) {
      return Center(
        child: Text(
          'No se encontraron resultados',
          style: tt.bodyMedium?.copyWith(
            color: cs.onSurface.withOpacity(0.6),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: resultados.length,
      itemBuilder: (_, i) {
        final coche = resultados[i];
        return ListTile(
          tileColor: cs.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

          // Logo de la marca
          leading: Image.asset(
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

          title: Text(
            '${coche.marca} ${coche.modelo}',
            style: tt.titleLarge?.copyWith(color: cs.secondary),
          ),
          subtitle: Text(
            '${coche.tipoMotor} • ${coche.tipoTransmision}',
            style: tt.bodyMedium?.copyWith(color: cs.onSurface.withOpacity(0.7)),
          ),
          trailing: Icon(Icons.directions_car, color: cs.secondary),
          onTap: () => close(context, coche),
        );
      },
    );
  }

  /// Muestra sugerencias dinámicas conforme se escribe en el campo de búsqueda.
  ///
  /// Se listan aquellos coches que coincidan parcial o totalmente con el texto ingresado.
  @override
  Widget buildSuggestions(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final sugerencias = listaCoches.where((coche) {
      final texto = '${coche.marca} ${coche.modelo}'.toLowerCase();
      return texto.contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: sugerencias.length,
      itemBuilder: (_, i) {
        final coche = sugerencias[i];
        return ListTile(
          tileColor: cs.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),

          leading: Image.asset(
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

          title: Text(
            '${coche.marca} ${coche.modelo}',
            style: tt.titleLarge?.copyWith(color: cs.secondary),
          ),
          onTap: () {
            query = '${coche.marca} ${coche.modelo}';
            showResults(context);
          },
        );
      },
    );
  }
}
