/// Clase que representa un modelo de coche.
///
/// Incluye atributos técnicos y de equipamiento que se usan para mostrar, comparar
/// y almacenar vehículos dentro de la aplicación.
///
/// Soporta conversión bidireccional desde/hacia mapas (`Map<String, dynamic>`) y JSON.
class Coche {
  final int? id;
  final String marca;
  final String modelo;
  final int anioFabricacion;
  final String tipoMotor;
  final double cilindrada;
  final int potenciaCV;
  final String tipoTransmision;
  final double consumo;
  final List<String> listaCaracteristicas;
  final int numPuertas;
  final int numPlazas;
  final String tipoCombustible;
  final int volumenMaletero;
  final int precioBase;

  /// Constructor principal del coche.
  /// El campo `id` es opcional, ya que puede ser generado automáticamente por SQLite.
  Coche({
    this.id,
    required this.marca,
    required this.modelo,
    required this.anioFabricacion,
    required this.tipoMotor,
    required this.cilindrada,
    required this.potenciaCV,
    required this.tipoTransmision,
    required this.consumo,
    required this.listaCaracteristicas,
    required this.numPuertas,
    required this.numPlazas,
    required this.tipoCombustible,
    required this.volumenMaletero,
    required this.precioBase,
  });

  /// Convierte un objeto Coche a un mapa (`Map<String, dynamic>`) para almacenarlo en SQLite.
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'marca': marca,
      'modelo': modelo,
      'anioFabricacion': anioFabricacion,
      'tipoMotor': tipoMotor,
      'cilindrada': cilindrada,
      'potenciaCV': potenciaCV,
      'tipoTransmision': tipoTransmision,
      'consumo': consumo,
      'listaCaracteristicas': listaCaracteristicas.join(','),
      'numPuertas': numPuertas,
      'numPlazas': numPlazas,
      'tipoCombustible': tipoCombustible,
      'volumenMaletero': volumenMaletero,
      'precioBase': precioBase,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  /// Crea un objeto `Coche` a partir de un mapa obtenido desde la base de datos SQLite.
  ///
  /// Admite valores nulos y asigna valores por defecto donde sea necesario.
  factory Coche.fromMap(Map<String, dynamic> map) {
    return Coche(
      id: map['id'] != null ? map['id'] as int : null,
      marca: map['marca'] as String? ?? '',
      modelo: map['modelo'] as String? ?? '',
      anioFabricacion: map['anioFabricacion'] as int? ?? 0,
      tipoMotor: map['tipoMotor'] as String? ?? '',
      cilindrada: (map['cilindrada'] as num?)?.toDouble() ?? 0.0,
      potenciaCV: map['potenciaCV'] as int? ?? 0,
      tipoTransmision: map['tipoTransmision'] as String? ?? '',
      consumo: (map['consumo'] as num?)?.toDouble() ?? 0.0,
      listaCaracteristicas: map['listaCaracteristicas'] != null
          ? (map['listaCaracteristicas'] as String).split(',')
          : <String>[],
      numPuertas: map['numPuertas'] as int? ?? 0,
      numPlazas: map['numPlazas'] as int? ?? 0,
      tipoCombustible: map['tipoCombustible'] as String? ?? '',
      volumenMaletero: map['volumenMaletero'] as int? ?? 0,
      precioBase: map['precioBase'] as int? ?? 0,
    );
  }

  /// Convierte el objeto a formato JSON.
  ///
  /// Utilizado principalmente para exportación o almacenamiento en preferencias.
  Map<String, dynamic> toJson() {
    return {
      'marca': marca,
      'modelo': modelo,
      'anioFabricacion': anioFabricacion,
      'tipoMotor': tipoMotor,
      'cilindrada': cilindrada,
      'potenciaCV': potenciaCV,
      'tipoTransmision': tipoTransmision,
      'consumo': consumo,
      'listaCaracteristicas': listaCaracteristicas,
      'numPuertas': numPuertas,
      'numPlazas': numPlazas,
      'tipoCombustible': tipoCombustible,
      'volumenMaletero': volumenMaletero,
      'precioBase': precioBase,
    };
  }

  /// Crea un objeto `Coche` a partir de datos en formato JSON.
  ///
  /// Utilizado principalmente durante la carga inicial desde archivos de assets.
  factory Coche.fromJson(Map<String, dynamic> json) {
    return Coche(
      marca: json['marca'] as String,
      modelo: json['modelo'] as String,
      anioFabricacion: json['anioFabricacion'] as int,
      tipoMotor: json['tipoMotor'] as String,
      cilindrada: (json['cilindrada'] as num).toDouble(),
      potenciaCV: json['potenciaCV'] as int,
      tipoTransmision: json['tipoTransmision'] as String,
      consumo: (json['consumo'] as num).toDouble(),
      listaCaracteristicas:
      List<String>.from(json['listaCaracteristicas'] as List),
      numPuertas: json['numPuertas'] as int,
      numPlazas: json['numPlazas'] as int,
      tipoCombustible: json['tipoCombustible'] as String,
      volumenMaletero: json['volumenMaletero'] as int,
      precioBase: json['precioBase'] as int,
    );
  }
}
