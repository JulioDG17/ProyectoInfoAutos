import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/coche.dart';

/// Clase encargada de gestionar la base de datos local SQLite para la entidad `Coche`.
///
/// Implementa el patrón Singleton para asegurar una única instancia activa.
/// Soporta operaciones CRUD, inicialización desde un archivo JSON,
/// y cierre seguro de la base de datos.
class CocheDatabase {
  static final CocheDatabase instance = CocheDatabase._init();
  static Database? _database;

  CocheDatabase._init();

  /// Devuelve la instancia activa de la base de datos.
  /// Si aún no está inicializada, llama a [_initDB].
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('coches.db');
    return _database!;
  }

  /// Inicializa la base de datos local usando `sqflite`.
  /// Crea la base de datos en la ruta local del dispositivo.
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Crea la estructura inicial de la tabla `coches` y carga datos desde JSON.
  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE coches (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      marca TEXT NOT NULL,
      modelo TEXT NOT NULL,
      anioFabricacion INTEGER NOT NULL,
      tipoMotor TEXT NOT NULL,
      cilindrada REAL NOT NULL,
      potenciaCV INTEGER NOT NULL,
      tipoTransmision TEXT NOT NULL,
      consumo REAL NOT NULL,
      listaCaracteristicas TEXT NOT NULL,
      numPuertas INTEGER NOT NULL,
      numPlazas INTEGER NOT NULL,
      tipoCombustible TEXT NOT NULL,
      volumenMaletero INTEGER NOT NULL,
      precioBase INTEGER NOT NULL
    )
    ''');
    await _cargarDatosIniciales(db);
  }

  /// Carga inicial de datos desde el archivo JSON localizado en assets.
  /// Este metodo se ejecuta tras crear la tabla, y utiliza los datos para poblarla.
  Future _cargarDatosIniciales(Database db) async {
    final data = await rootBundle.loadString('assets/data/coches.json');
    final List<dynamic> jsonData = json.decode(data);
    for (var cocheJson in jsonData) {
      final coche = Coche.fromJson(cocheJson as Map<String, dynamic>);
      await db.insert(
        'coches',
        {
          'marca': coche.marca,
          'modelo': coche.modelo,
          'anioFabricacion': coche.anioFabricacion,
          'tipoMotor': coche.tipoMotor,
          'cilindrada': coche.cilindrada,
          'potenciaCV': coche.potenciaCV,
          'tipoTransmision': coche.tipoTransmision,
          'consumo': coche.consumo,
          'listaCaracteristicas': coche.listaCaracteristicas.join(','),
          'numPuertas': coche.numPuertas,
          'numPlazas': coche.numPlazas,
          'tipoCombustible': coche.tipoCombustible,
          'volumenMaletero': coche.volumenMaletero,
          'precioBase': coche.precioBase
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// Inserta un nuevo coche en la tabla `coches`.
  /// Si el coche ya existe, lo reemplaza.
  Future<void> insertCoche(Coche coche) async {
    final db = await instance.database;
    await db.insert(
      'coches',
      coche.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Obtiene todos los coches almacenados en la base de datos.
  /// Devuelve una lista de objetos `Coche`.
  Future<List<Coche>> getTodosLosCoches() async {
    final db = await instance.database;
    final result = await db.query('coches');
    return result.map((map) => Coche.fromMap(map)).toList();
  }

  /// Recupera un coche específico mediante su `id`.
  /// Devuelve el objeto `Coche` si existe, o `null` si no se encuentra.
  Future<Coche?> getCochePorId(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'coches',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Coche.fromMap(maps.first);
    } else {
      return null;
    }
  }

  /// Actualiza los datos de un coche existente en la base de datos.
  /// La coincidencia se realiza por `id`.
  Future<void> updateCoche(Coche coche) async {
    final db = await instance.database;
    await db.update(
      'coches',
      coche.toMap(),
      where: 'id = ?',
      whereArgs: [coche.id],
    );
  }

  /// Elimina un coche de la base de datos usando su `id`.
  Future<void> deleteCoche(int id) async {
    final db = await instance.database;
    await db.delete(
      'coches',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Cierra la conexión con la base de datos.
  /// Recomendado para evitar fugas de memoria.
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
