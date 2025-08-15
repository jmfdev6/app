import 'package:app/app_router.dart';
import 'package:app/app_theme.dart';
import 'package:app/service/supabase_config.dart';
import 'package:app/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Carregar variáveis de ambiente
    await dotenv.load(fileName: ".env");
    
    // Inicializar Supabase com credenciais do .env
    await SupabaseConfig.initialize();
    
    // Inicializar serviço de autenticação
    await AuthService().initialize();
    
    runApp(const MyApp());
  } catch (e) {
    // Se der erro na inicialização, mostrar uma tela de erro
    runApp(ErrorApp(error: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      //darkTheme: AppTheme.darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

// Widget para mostrar erros de configuração
class ErrorApp extends StatelessWidget {
  final String error;
  
  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MooveTag - Erro de Configuração',
      home: Scaffold(
        backgroundColor: Colors.red[50],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[600],
                ),
                const SizedBox(height: 16),
                Text(
                  'Erro de Configuração',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[800],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[300]!),
                  ),
                  child: Text(
                    error,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '📋 Passos para corrigir:\n'
                  '1. Configure suas credenciais no arquivo .env\n'
                  '2. Consulte o arquivo env.example\n'
                  '3. Reinicie o aplicativo',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

