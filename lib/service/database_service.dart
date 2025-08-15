import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';
import 'models.dart';
import 'auth_service.dart';
import 'enums.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  final SupabaseClient _client = SupabaseConfig.client;
  final AuthService _authService = AuthService();

  // ========== PROFILES ==========

  // Obter perfil do usuário atual
  Future<DatabaseResult<Profile>> getCurrentProfile() async {
    try {
      if (!_authService.isAuthenticated) {
        return DatabaseResult.error('Usuário não autenticado');
      }

      final response = await _client
          .from('profiles')
          .select()
          .eq('id', _authService.currentUser!.id)
          .single();

      final profile = Profile.fromJson(response);
      return DatabaseResult.success(profile);
    } catch (e) {
      return DatabaseResult.error('Erro ao carregar perfil: $e');
    }
  }

  // Atualizar perfil do usuário
  Future<DatabaseResult<Profile>> updateProfile(Profile profile) async {
    try {
      if (!_authService.isAuthenticated) {
        return DatabaseResult.error('Usuário não autenticado');
      }

      final response = await _client
          .from('profiles')
          .update(profile.toJson())
          .eq('id', profile.id)
          .select()
          .single();

      final updatedProfile = Profile.fromJson(response);
      return DatabaseResult.success(updatedProfile);
    } catch (e) {
      return DatabaseResult.error('Erro ao atualizar perfil: $e');
    }
  }

  // ========== GRUPOS ==========

  // Criar novo grupo
  Future<DatabaseResult<Grupo>> createGrupo(Grupo grupo) async {
    try {
      if (!_authService.isAuthenticated) {
        return DatabaseResult.error('Usuário não autenticado');
      }

      final grupoData = grupo.copyWith(
        userId: _authService.currentUser!.id,
        dataCriacao: DateTime.now(),
      );

      final response = await _client
          .from('grupos')
          .insert(grupoData.toJson())
          .select()
          .single();

      final createdGrupo = Grupo.fromJson(response);
      return DatabaseResult.success(createdGrupo);
    } catch (e) {
      return DatabaseResult.error('Erro ao criar grupo: $e');
    }
  }

  // Listar grupos do usuário
  Future<DatabaseResult<List<Grupo>>> getUserGrupos() async {
    try {
      if (!_authService.isAuthenticated) {
        return DatabaseResult.error('Usuário não autenticado');
      }

      final response = await _client
          .from('grupos')
          .select()
          .eq('user_id', _authService.currentUser!.id)
          .order('data_criacao', ascending: false);

      final grupos = (response as List)
          .map((data) => Grupo.fromJson(data))
          .toList();

      return DatabaseResult.success(grupos);
    } catch (e) {
      return DatabaseResult.error('Erro ao carregar grupos: $e');
    }
  }

  // Obter grupo por ID
  Future<DatabaseResult<Grupo>> getGrupo(String grupoId) async {
    try {
      if (!_authService.isAuthenticated) {
        return DatabaseResult.error('Usuário não autenticado');
      }

      final response = await _client
          .from('grupos')
          .select()
          .eq('id', grupoId)
          .single();

      final grupo = Grupo.fromJson(response);
      return DatabaseResult.success(grupo);
    } catch (e) {
      return DatabaseResult.error('Erro ao carregar grupo: $e');
    }
  }

  // Atualizar grupo
  Future<DatabaseResult<Grupo>> updateGrupo(Grupo grupo) async {
    try {
      if (!_authService.isAuthenticated) {
        return DatabaseResult.error('Usuário não autenticado');
      }

      final response = await _client
          .from('grupos')
          .update(grupo.toJson())
          .eq('id', grupo.id!)
          .select()
          .single();

      final result = Grupo.fromJson(response);
      return DatabaseResult.success(result);
    } catch (e) {
      return DatabaseResult.error('Erro ao atualizar grupo: $e');
    }
  }

  // Encerrar grupo
  Future<DatabaseResult<void>> encerrarGrupo(String grupoId) async {
    try {
      if (!_authService.isAuthenticated) {
        return DatabaseResult.error('Usuário não autenticado');
      }

      await _client
          .from('grupos')
          .update({'data_encerramento': DateTime.now().toIso8601String()})
          .eq('id', grupoId);

      return DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.error('Erro ao encerrar grupo: $e');
    }
  }

  // ========== TAGS ==========

  // Criar nova tag
  Future<DatabaseResult<Tag>> createTag(Tag tag) async {
    try {
      if (!_authService.isAuthenticated) {
        return DatabaseResult.error('Usuário não autenticado');
      }

      // Verificar se tag_code já existe
      final existingTag = await _client
          .from('tags')
          .select('id')
          .eq('tag_code', tag.tagCode);

      if (existingTag.isNotEmpty) {
        return DatabaseResult.error('Esta tag já está cadastrada');
      }

      final tagData = tag.copyWith(
        dataAssociacao: DateTime.now(),
      );

      final response = await _client
          .from('tags')
          .insert(tagData.toJson())
          .select()
          .single();

      final createdTag = Tag.fromJson(response);
      return DatabaseResult.success(createdTag);
    } catch (e) {
      return DatabaseResult.error('Erro ao criar tag: $e');
    }
  }

  // Listar tags de um grupo
  Future<DatabaseResult<List<Tag>>> getTagsByGrupo(String grupoId) async {
    try {
      final response = await _client
          .from('tags')
          .select()
          .eq('grupo_id', grupoId)
          .order('data_associacao', ascending: false);

      final tags = (response as List)
          .map((data) => Tag.fromJson(data))
          .toList();

      return DatabaseResult.success(tags);
    } catch (e) {
      return DatabaseResult.error('Erro ao carregar tags: $e');
    }
  }

  // Obter tag por código
  Future<DatabaseResult<Tag>> getTagByCode(String tagCode) async {
    try {
      final response = await _client
          .from('tags')
          .select()
          .eq('tag_code', tagCode)
          .single();

      final tag = Tag.fromJson(response);
      return DatabaseResult.success(tag);
    } catch (e) {
      return DatabaseResult.error('Tag não encontrada');
    }
  }

  // Atualizar status da tag
  Future<DatabaseResult<Tag>> updateTagStatus(String tagId, TagStatus status) async {
    try {
      final response = await _client
          .from('tags')
          .update({'status': status.value})
          .eq('id', tagId)
          .select()
          .single();

      final tag = Tag.fromJson(response);
      return DatabaseResult.success(tag);
    } catch (e) {
      return DatabaseResult.error('Erro ao atualizar status da tag: $e');
    }
  }

  // ========== LEITURAS ==========

  // Registrar nova leitura
  Future<DatabaseResult<Leitura>> createLeitura(Leitura leitura) async {
    try {
      final response = await _client
          .from('leituras')
          .insert(leitura.toJson())
          .select()
          .single();

      final createdLeitura = Leitura.fromJson(response);
      return DatabaseResult.success(createdLeitura);
    } catch (e) {
      return DatabaseResult.error('Erro ao registrar leitura: $e');
    }
  }

  // Obter leituras de uma tag
  Future<DatabaseResult<List<Leitura>>> getLeiturasByTag(String tagId, {int? limit}) async {
    try {
      var query = _client
          .from('leituras')
          .select()
          .eq('tag_id', tagId)
          .order('data_hora', ascending: false);

      if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;

      final leituras = (response as List)
          .map((data) => Leitura.fromJson(data))
          .toList();

      return DatabaseResult.success(leituras);
    } catch (e) {
      return DatabaseResult.error('Erro ao carregar leituras: $e');
    }
  }

  // Obter leituras de um grupo
  Future<DatabaseResult<List<Leitura>>> getLeiturasByGrupo(String grupoId, {int? limit}) async {
    try {
      var query = _client
          .from('leituras')
          .select()
          .eq('grupo_id', grupoId)
          .order('data_hora', ascending: false);

      if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;

      final leituras = (response as List)
          .map((data) => Leitura.fromJson(data))
          .toList();

      return DatabaseResult.success(leituras);
    } catch (e) {
      return DatabaseResult.error('Erro ao carregar leituras do grupo: $e');
    }
  }

  // ========== ALERTAS ==========

  // Obter alertas não enviados
  Future<DatabaseResult<List<Alerta>>> getAlertasNaoEnviados() async {
    try {
      if (!_authService.isAuthenticated) {
        return DatabaseResult.error('Usuário não autenticado');
      }

      final response = await _client
          .from('alertas')
          .select()
          .eq('enviado', false)
          .order('data_criacao', ascending: false);

      final alertas = (response as List)
          .map((data) => Alerta.fromJson(data))
          .toList();

      return DatabaseResult.success(alertas);
    } catch (e) {
      return DatabaseResult.error('Erro ao carregar alertas: $e');
    }
  }

  // Marcar alerta como enviado
  Future<DatabaseResult<void>> marcarAlertaEnviado(String alertaId) async {
    try {
      await _client
          .from('alertas')
          .update({'enviado': true})
          .eq('id', alertaId);

      return DatabaseResult.success(null);
    } catch (e) {
      return DatabaseResult.error('Erro ao marcar alerta como enviado: $e');
    }
  }

  // ========== ESTATÍSTICAS ==========

  // Obter estatísticas do usuário
  Future<DatabaseResult<UserStats>> getUserStats() async {
    try {
      if (!_authService.isAuthenticated) {
        return DatabaseResult.error('Usuário não autenticado');
      }

      final userId = _authService.currentUser!.id;

      // Contar grupos
      final gruposCount = await _client
          .from('grupos')
          .select('id')
          .eq('user_id', userId)
          .count();

      // Contar tags ativas dos grupos do usuário
      final tagsCount = await _client
          .from('tags')
          .select('id')
          .inFilter('grupo_id', 
            await _client
                .from('grupos')
                .select('id')
                .eq('user_id', userId)
                .then((data) => (data as List).map((g) => g['id']).toList()))
          .eq('status', 'ativa')
          .count();

      // Contar leituras do último mês
      final lastMonth = DateTime.now().subtract(Duration(days: 30));
      final leiturasCount = await _client
          .from('leituras')
          .select('id')
          .gte('data_hora', lastMonth.toIso8601String())
          .count();

      // Contar alertas não enviados
      final alertasCount = await _client
          .from('alertas')
          .select('id')
          .eq('enviado', false)
          .count();

      final stats = UserStats(
        totalGroups: gruposCount.count,
        totalTags: tagsCount.count,
        readingsLastMonth: leiturasCount.count,
        alertsCount: alertasCount.count,
      );

      return DatabaseResult.success(stats);
    } catch (e) {
      return DatabaseResult.error('Erro ao carregar estatísticas: $e');
    }
  }
}

// Classe para resultado de operações de banco de dados
class DatabaseResult<T> {
  final bool success;
  final T? data;
  final String? error;

  DatabaseResult._({
    required this.success,
    this.data,
    this.error,
  });

  factory DatabaseResult.success(T? data) {
    return DatabaseResult._(
      success: true,
      data: data,
    );
  }

  factory DatabaseResult.error(String error) {
    return DatabaseResult._(
      success: false,
      error: error,
    );
  }
}
