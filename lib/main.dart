import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/coche.dart';
import 'data/coche_database.dart';
import 'providers/coche_provider.dart';
import 'screens/inicio_screen.dart';
import 'screens/comparador_screen.dart';
import 'screens/favoritos_screen.dart';
import 'styles/theme.dart';

/// Punto de entrada principal de la aplicación InfoAutos.
///
/// Inicializa la base de datos local de coches y carga todos los registros al iniciar.
/// Utiliza un ChangeNotifierProvider para inyectar el estado global de la aplicación a través de CocheProvider.
///
/// El widget principal MyApp construye la aplicación con un MaterialApp, usando el tema personalizado
/// y cargando HomeScreen como pantalla inicial.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = CocheDatabase.instance;
  await db.database;

  // Obtener todos los coches de SQLite
  final List<Coche> listaCoches = (await db.getTodosLosCoches()).cast<Coche>();

  runApp(
    MyApp(listaCoches: listaCoches),
  );
}

/// Widget raíz de la aplicación.
///
/// Recibe la lista de coches obtenida de SQLite y la asigna al provider global.
/// Inicializa también los favoritos desde SharedPreferences.
///
/// Utiliza un MaterialApp con el tema personalizado `appTheme`.
class MyApp extends StatelessWidget {
  final List<Coche> listaCoches;

  const MyApp({super.key, required this.listaCoches});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CocheProvider>(
      create: (_) => CocheProvider(),
      child: Builder(
        builder: (context) {
          final provider = Provider.of<CocheProvider>(context, listen: false);
          provider.cargarCoches(listaCoches);
          provider.cargarFavoritosDesdePreferencias(); // ✅ carga favoritos

          return MaterialApp(
            title: 'InfoAutos',
            theme: appTheme,
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}

/// Pantalla principal que contiene la navegación entre secciones.
///
/// Muestra un AppBar dinámico y una BottomNavigationBar que permite alternar entre:
/// - Inicio: Lista general de vehículos
/// - Comparador: Comparación entre dos vehículos
/// - Favoritos: Vehículos marcados por el usuario
///
/// Cada cambio de índice actualiza el cuerpo de la pantalla con el widget correspondiente.
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/// Estado asociado a HomeScreen.
///
/// Gestiona la navegación por pestañas e identifica la pantalla activa mediante `_selectedIndex`.
/// Cada índice está vinculado a un título, un icono y una pantalla concreta.
class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Pantallas hijas
  static final List<Widget> _widgetOptions = <Widget>[
    InicioScreen(),
    ComparadorScreen(),
    FavoritosScreen(),
  ];

  // Títulos para el AppBar
  static const List<String> _titles = <String>[
    'Inicio',
    'Comparador',
    'Favoritos',
  ];

  // Iconos para el AppBar
  static const List<IconData> _icons = <IconData>[
    Icons.home,
    Icons.compare_arrows,
    Icons.favorite,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final title = _titles[_selectedIndex];
    final icon = _icons[_selectedIndex];

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        backgroundColor: cs.primary,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: cs.onPrimary),
            const SizedBox(width: 8),
            Text(title, style: Theme.of(context).appBarTheme.titleTextStyle),
          ],
        ),
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: cs.surface,
        selectedItemColor: cs.secondary,
        unselectedItemColor: cs.onSurface.withOpacity(0.6),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.car_crash_outlined), label: 'InfoAutos'),
          BottomNavigationBarItem(icon: Icon(Icons.compare), label: 'Comparar'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
        ],
      ),
    );
  }
}
