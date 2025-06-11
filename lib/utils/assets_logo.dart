/// Dada una marca (por ejemplo "Mercedes-Benz"), devuelve la ruta
/// al PNG dentro de assets/logos.
String logoPath(String marca) {
  final normalized = marca
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]'), '_');
  return 'assets/logos/$normalized.png';
}
