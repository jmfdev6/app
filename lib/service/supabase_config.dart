import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  // Carregando credenciais do arquivo .env
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? 'https://sua-url.supabase.co';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? 'sua-chave-anonima';

  static Future<void> initialize() async {
    // Validar se as credenciais foram configuradas
    if (supabaseUrl == 'https://sua-url.supabase.co' || supabaseAnonKey == 'sua-chave-anonima') {
      throw Exception(
        'Credenciais do Supabase não configuradas!\n'
        'Configure suas credenciais no arquivo .env\n'
        'Consulte o arquivo env.example para instruções.'
      );
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
  static GoTrueClient get auth => Supabase.instance.client.auth;
}
