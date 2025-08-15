import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'supabase_config.dart';
import 'models.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final SupabaseClient _client = SupabaseConfig.client;
  Profile? _currentUser;

  // Getters
  Profile? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  User? get supabaseUser => _client.auth.currentUser;

  // Stream para mudanças no estado de autenticação
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Inicializar o serviço - verificar se há sessão ativa
  Future<void> initialize() async {
    final user = _client.auth.currentUser;
    if (user != null) {
      _currentUser = Profile.fromUser(user);
      // Carregar perfil completo do banco
      await _loadFullProfile();
    }
  }

  // Carregar perfil completo do banco de dados
  Future<void> _loadFullProfile() async {
    try {
      if (_currentUser == null) return;
      
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', _currentUser!.id)
          .single();

      _currentUser = Profile.fromJson(response);
    } catch (e) {
      // Se não encontrar o perfil, manter o básico do auth
      print('Profile not found in database: $e');
    }
  }

  // Fazer login com email e senha
  Future<AuthResult> signInWithEmail(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _currentUser = Profile.fromUser(response.user!);
        await _loadFullProfile(); // Carregar perfil completo
        await _saveUserData();
        return AuthResult.success(_currentUser!);
      } else {
        return AuthResult.error('Erro ao fazer login');
      }
    } on AuthException catch (e) {
      return AuthResult.error(_getErrorMessage(e));
    } catch (e) {
      return AuthResult.error('Erro inesperado: $e');
    }
  }

  // Registrar novo usuário
  Future<AuthResult> signUpWithEmail(String email, String password, {String? name}) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: name != null ? {'name': name} : null,
      );

      if (response.user != null) {
        _currentUser = Profile.fromUser(response.user!);
        await _loadFullProfile(); // Carregar perfil completo
        await _saveUserData();
        return AuthResult.success(_currentUser!);
      } else {
        return AuthResult.error('Erro ao criar conta. Verifique seu email para confirmar a conta.');
      }
    } on AuthException catch (e) {
      return AuthResult.error(_getErrorMessage(e));
    } catch (e) {
      return AuthResult.error('Erro inesperado: $e');
    }
  }

  // Fazer logout
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      _currentUser = null;
      await _clearUserData();
    } catch (e) {
      // Mesmo com erro, limpar dados locais
      _currentUser = null;
      await _clearUserData();
    }
  }

  // Recuperar senha
  Future<AuthResult> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return AuthResult.success(null, message: 'Email de recuperação enviado!');
    } on AuthException catch (e) {
      return AuthResult.error(_getErrorMessage(e));
    } catch (e) {
      return AuthResult.error('Erro inesperado: $e');
    }
  }

  // Atualizar perfil do usuário
  Future<AuthResult> updateProfile({String? name, String? email}) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;

      UserResponse? response;
      if (email != null) {
        response = await _client.auth.updateUser(
          UserAttributes(
            email: email,
            data: updates.isNotEmpty ? updates : null,
          ),
        );
      } else if (updates.isNotEmpty) {
        response = await _client.auth.updateUser(
          UserAttributes(data: updates),
        );
      }

      if (response?.user != null) {
        _currentUser = Profile.fromUser(response!.user!);
        await _loadFullProfile(); // Carregar perfil completo
        await _saveUserData();
        return AuthResult.success(_currentUser!);
      }

      return AuthResult.error('Nenhuma alteração foi feita');
    } on AuthException catch (e) {
      return AuthResult.error(_getErrorMessage(e));
    } catch (e) {
      return AuthResult.error('Erro inesperado: $e');
    }
  }

  // Salvar dados do usuário localmente
  Future<void> _saveUserData() async {
    if (_currentUser == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', _currentUser!.id);
    if (_currentUser!.email != null) {
      await prefs.setString('user_email', _currentUser!.email!);
    }
    if (_currentUser!.fullName != null) {
      await prefs.setString('user_name', _currentUser!.fullName!);
    }
  }

  // Limpar dados do usuário localmente
  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_email');
    await prefs.remove('user_name');
  }

  // Traduzir mensagens de erro
  String _getErrorMessage(AuthException error) {
    switch (error.message.toLowerCase()) {
      case 'invalid login credentials':
        return 'Credenciais inválidas. Verifique email e senha.';
      case 'user not found':
        return 'Usuário não encontrado.';
      case 'invalid email':
        return 'Email inválido.';
      case 'weak password':
        return 'Senha muito fraca. Use pelo menos 6 caracteres.';
      case 'email already exists':
        return 'Este email já está em uso.';
      case 'email not confirmed':
        return 'Email não confirmado. Verifique sua caixa de entrada.';
      case 'too many requests':
        return 'Muitas tentativas. Tente novamente em alguns minutos.';
      default:
        return error.message.isNotEmpty ? error.message : 'Erro de autenticação';
    }
  }
}

// Classe para resultado de autenticação
class AuthResult {
  final bool success;
  final Profile? user;
  final String? error;
  final String? message;

  AuthResult._({
    required this.success,
    this.user,
    this.error,
    this.message,
  });

  factory AuthResult.success(Profile? user, {String? message}) {
    return AuthResult._(
      success: true,
      user: user,
      message: message,
    );
  }

  factory AuthResult.error(String error) {
    return AuthResult._(
      success: false,
      error: error,
    );
  }
}
