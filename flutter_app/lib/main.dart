import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:offline_sync_pro/core/sync/sync_service.dart';
import 'package:offline_sync_pro/data/local/local_database.dart';
import 'package:offline_sync_pro/data/remote/api_client.dart';
import 'package:offline_sync_pro/domain/repositories/record_repository.dart';
import 'package:offline_sync_pro/ui/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar banco de dados
  LocalDatabase? database;
  
  try {
    database = LocalDatabase();
    // Tentar inicializar apenas se não for web
    if (!kIsWeb) {
      await LocalDatabase.instance;
    }
  } catch (e) {
    debugPrint('Erro ao inicializar banco: $e');
    // Continuar mesmo com erro (web não suporta SQLite)
  }
  
  // Inicializar serviços
  final apiClient = ApiClient();
  
  // Se database for null (web), criar uma instância mesmo assim
  // mas as operações SQLite falharão graciosamente
  final db = database ?? LocalDatabase();
  
  final syncService = SyncService(database: db, apiClient: apiClient);
  final recordRepository = RecordRepository(
    database: db,
    syncService: syncService,
  );
  
  runApp(MyApp(
    recordRepository: recordRepository,
    syncService: syncService,
    apiClient: apiClient,
    isWeb: kIsWeb,
  ));
}

class MyApp extends StatelessWidget {
  final RecordRepository recordRepository;
  final SyncService syncService;
  final ApiClient apiClient;
  final bool isWeb;

  const MyApp({
    super.key,
    required this.recordRepository,
    required this.syncService,
    required this.apiClient,
    required this.isWeb,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<RecordRepository>.value(value: recordRepository),
        Provider<SyncService>.value(value: syncService),
        Provider<ApiClient>.value(value: apiClient),
      ],
      child: MaterialApp(
        title: 'OfflineSync Pro',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: isWeb 
          ? _WebWarningScreen(child: const LoginScreen())
          : const LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class _WebWarningScreen extends StatelessWidget {
  final Widget child;

  const _WebWarningScreen({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.orange,
            child: const Text(
              '⚠️ SQLite não funciona no web. Funcionalidades offline estão limitadas.',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
