import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/coche.dart';

/// Clase que gestiona el estado global de la aplicación para los objetos `Coche`.
///
/// Proporciona funcionalidades como:
/// - Almacenamiento y recuperación de la lista de coches
/// - Gestión de favoritos persistentes mediante SharedPreferences
/// - Comparación entre dos vehículos
///
/// Utiliza `ChangeNotifier` para notificar a los widgets que dependen del estado.
class CocheProvider with ChangeNotifier {
  final List<Coche> _todos = [];
  final List<Coche> _favoritos = [];
  Coche? _comparado1;
  Coche? _comparado2;

  // Devuelve la lista de Coches cargados
  List<Coche> get todos => List.unmodifiable(_todos);
  // Devuelve la lista actual de coches marcados como favoritos.
  List<Coche> get favoritos => List.unmodifiable(_favoritos);
  // Devuelve el coche asignado al primer campo de comparación.
  Coche? get comparado1 => _comparado1;
  // Devuelve el coche asignado al segundo campo de comparación.
  Coche? get comparado2 => _comparado2;

  /// Carga una lista de coches en el proveedor.
  /// Reemplaza completamente la lista anterior.
  void cargarCoches(List<Coche> coches) {
    _todos.clear();
    _todos.addAll(coches);
    notifyListeners();
  }

  /// Añade o elimina un coche de la lista de favoritos.
  ///
  /// Si ya es favorito, lo elimina; si no lo es, lo añade.
  /// Guarda automáticamente los cambios en SharedPreferences.
  void alternarFavorito(Coche coche) async {
    if (_favoritos.contains(coche)) {
      _favoritos.remove(coche);
    } else {
      _favoritos.add(coche);
    }
    await guardarFavoritos();
    notifyListeners();
  }

  /// Verifica si un coche está marcado como favorito.
  bool esFavorito(Coche coche) => _favoritos.contains(coche);

  /// Asigna un coche al comparador.
  /// El parámetro `lado` define si se asigna al primer o segundo campo.
  /// También se permite `null` para limpiar la selección.
  void asignarComparado(int lado, Coche? coche) {
    if (lado == 1) {
      _comparado1 = coche;
    } else {
      _comparado2 = coche;
    }
    notifyListeners();
  }

  /// Elimina los coches asignados en el comparador.
  void limpiarComparador() {
    _comparado1 = null;
    _comparado2 = null;
    notifyListeners();
  }

  /// Guarda la lista actual de coches favoritos en SharedPreferences.
  ///
  /// Solo se guardan los IDs de los coches.
  Future<void> guardarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = _favoritos.map((c) => c.id.toString()).toList();
    await prefs.setStringList('favoritos', ids);
  }

  /// Carga los favoritos guardados previamente desde SharedPreferences.
  ///
  /// Busca coincidencias por `id` entre los coches cargados en `_todos`.
  Future<void> cargarFavoritosDesdePreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('favoritos') ?? [];

    _favoritos.clear();
    _favoritos.addAll(
      _todos.where((c) => ids.contains(c.id.toString())),
    );

    notifyListeners();
  }
}
