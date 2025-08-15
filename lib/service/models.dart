import 'package:supabase_flutter/supabase_flutter.dart';
import 'enums.dart';

// Modelo do perfil do usuário (tabela profiles)
class Profile {
  final String id;
  final String? fullName;
  final UserRole role;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? telefone;
  final String? adminId;
  final String? email;

  Profile({
    required this.id,
    this.fullName,
    required this.role,
    this.createdAt,
    this.updatedAt,
    this.telefone,
    this.adminId,
    this.email,
  });

  factory Profile.fromUser(User user) {
    return Profile(
      id: user.id,
      email: user.email ?? '',
      fullName: user.userMetadata?['full_name'],
      role: UserRole.operador, // Default, será atualizado via query do profile
      createdAt: user.createdAt != null ? DateTime.parse(user.createdAt!) : null,
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      fullName: json['full_name'],
      role: UserRole.fromString(json['role'] ?? 'operador'),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      telefone: json['telefone'],
      adminId: json['admin_id'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'role': role.value,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'telefone': telefone,
      'admin_id': adminId,
      'email': email,
    };
  }

  Profile copyWith({
    String? id,
    String? fullName,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? telefone,
    String? adminId,
    String? email,
  }) {
    return Profile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      telefone: telefone ?? this.telefone,
      adminId: adminId ?? this.adminId,
      email: email ?? this.email,
    );
  }

  String get displayName => fullName ?? email ?? 'Usuário';
  bool get isAdmin => role.isAdmin;
}

// Modelo do grupo (tabela grupos)
class Grupo {
  final String? id;
  final String nome;
  final double temperaturaMin;
  final double temperaturaMax;
  final int? quantidadeMinLeitura;
  final DateTime dataCriacao;
  final DateTime? dataEncerramento;
  final String userId;

  Grupo({
    this.id,
    required this.nome,
    required this.temperaturaMin,
    required this.temperaturaMax,
    this.quantidadeMinLeitura,
    required this.dataCriacao,
    this.dataEncerramento,
    required this.userId,
  });

  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      id: json['id'],
      nome: json['nome'],
      temperaturaMin: (json['temperatura_min'] as num).toDouble(),
      temperaturaMax: (json['temperatura_max'] as num).toDouble(),
      quantidadeMinLeitura: json['quantidade_min_leitura'],
      dataCriacao: DateTime.parse(json['data_criacao']),
      dataEncerramento: json['data_encerramento'] != null 
          ? DateTime.parse(json['data_encerramento']) 
          : null,
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'temperatura_min': temperaturaMin,
      'temperatura_max': temperaturaMax,
      'quantidade_min_leitura': quantidadeMinLeitura,
      'data_criacao': dataCriacao.toIso8601String(),
      'data_encerramento': dataEncerramento?.toIso8601String(),
      'user_id': userId,
    };
  }

  Grupo copyWith({
    String? id,
    String? nome,
    double? temperaturaMin,
    double? temperaturaMax,
    int? quantidadeMinLeitura,
    DateTime? dataCriacao,
    DateTime? dataEncerramento,
    String? userId,
  }) {
    return Grupo(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      temperaturaMin: temperaturaMin ?? this.temperaturaMin,
      temperaturaMax: temperaturaMax ?? this.temperaturaMax,
      quantidadeMinLeitura: quantidadeMinLeitura ?? this.quantidadeMinLeitura,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataEncerramento: dataEncerramento ?? this.dataEncerramento,
      userId: userId ?? this.userId,
    );
  }

  bool get isActive => dataEncerramento == null;
  String get temperaturaRange => '$temperaturaMin°C - $temperaturaMax°C';
  
  bool isTemperaturaOk(double temperatura) {
    return temperatura >= temperaturaMin && temperatura <= temperaturaMax;
  }
}

// Modelo da tag (tabela tags)
class Tag {
  final String? id;
  final String tagCode; // Código único da tag NFC
  final String grupoId;
  final TagStatus status;
  final DateTime dataAssociacao;
  final DateTime? dataFinalizacao;

  Tag({
    this.id,
    required this.tagCode,
    required this.grupoId,
    required this.status,
    required this.dataAssociacao,
    this.dataFinalizacao,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      tagCode: json['tag_code'],
      grupoId: json['grupo_id'],
      status: TagStatus.fromString(json['status'] ?? 'ativa'),
      dataAssociacao: DateTime.parse(json['data_associacao']),
      dataFinalizacao: json['data_finalizacao'] != null 
          ? DateTime.parse(json['data_finalizacao']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tag_code': tagCode,
      'grupo_id': grupoId,
      'status': status.value,
      'data_associacao': dataAssociacao.toIso8601String(),
      'data_finalizacao': dataFinalizacao?.toIso8601String(),
    };
  }

  Tag copyWith({
    String? id,
    String? tagCode,
    String? grupoId,
    TagStatus? status,
    DateTime? dataAssociacao,
    DateTime? dataFinalizacao,
  }) {
    return Tag(
      id: id ?? this.id,
      tagCode: tagCode ?? this.tagCode,
      grupoId: grupoId ?? this.grupoId,
      status: status ?? this.status,
      dataAssociacao: dataAssociacao ?? this.dataAssociacao,
      dataFinalizacao: dataFinalizacao ?? this.dataFinalizacao,
    );
  }

  bool get isActive => status.isActive && dataFinalizacao == null;
}

// Modelo de leitura (tabela leituras)
class Leitura {
  final String? id;
  final String tagId;
  final double temperatura;
  final double? latitude;
  final double? longitude;
  final DateTime dataHora;
  final ReadingStatus status;
  final String? grupoId;

  Leitura({
    this.id,
    required this.tagId,
    required this.temperatura,
    this.latitude,
    this.longitude,
    required this.dataHora,
    required this.status,
    this.grupoId,
  });

  factory Leitura.fromJson(Map<String, dynamic> json) {
    return Leitura(
      id: json['id'],
      tagId: json['tag_id'],
      temperatura: (json['temperatura'] as num).toDouble(),
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      dataHora: DateTime.parse(json['data_hora']),
      status: ReadingStatus.fromString(json['status'] ?? 'ok'),
      grupoId: json['grupo_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tag_id': tagId,
      'temperatura': temperatura,
      'latitude': latitude,
      'longitude': longitude,
      'data_hora': dataHora.toIso8601String(),
      'status': status.value,
      'grupo_id': grupoId,
    };
  }

  Leitura copyWith({
    String? id,
    String? tagId,
    double? temperatura,
    double? latitude,
    double? longitude,
    DateTime? dataHora,
    ReadingStatus? status,
    String? grupoId,
  }) {
    return Leitura(
      id: id ?? this.id,
      tagId: tagId ?? this.tagId,
      temperatura: temperatura ?? this.temperatura,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      dataHora: dataHora ?? this.dataHora,
      status: status ?? this.status,
      grupoId: grupoId ?? this.grupoId,
    );
  }

  bool get hasLocation => latitude != null && longitude != null;
  String get temperaturaFormatted => '${temperatura.toStringAsFixed(1)}°C';
  String get locationFormatted => hasLocation ? '${latitude!.toStringAsFixed(6)}, ${longitude!.toStringAsFixed(6)}' : 'Sem localização';
}

// Modelo de alerta (tabela alertas)
class Alerta {
  final String? id;
  final String tagId;
  final String leituraId;
  final String mensagem;
  final DateTime? dataCriacao;
  final bool enviado;

  Alerta({
    this.id,
    required this.tagId,
    required this.leituraId,
    required this.mensagem,
    this.dataCriacao,
    required this.enviado,
  });

  factory Alerta.fromJson(Map<String, dynamic> json) {
    return Alerta(
      id: json['id'],
      tagId: json['tag_id'],
      leituraId: json['leitura_id'],
      mensagem: json['mensagem'],
      dataCriacao: json['data_criacao'] != null 
          ? DateTime.parse(json['data_criacao']) 
          : null,
      enviado: json['enviado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tag_id': tagId,
      'leitura_id': leituraId,
      'mensagem': mensagem,
      'data_criacao': dataCriacao?.toIso8601String(),
      'enviado': enviado,
    };
  }

  Alerta copyWith({
    String? id,
    String? tagId,
    String? leituraId,
    String? mensagem,
    DateTime? dataCriacao,
    bool? enviado,
  }) {
    return Alerta(
      id: id ?? this.id,
      tagId: tagId ?? this.tagId,
      leituraId: leituraId ?? this.leituraId,
      mensagem: mensagem ?? this.mensagem,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      enviado: enviado ?? this.enviado,
    );
  }

  String get timeAgo {
    if (dataCriacao == null) return 'Agora';
    
    final now = DateTime.now();
    final difference = now.difference(dataCriacao!);
    
    if (difference.inMinutes < 1) {
      return 'Agora';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}

// Classe para estatísticas do usuário (mantendo para compatibilidade)
class UserStats {
  final int totalGroups;
  final int totalTags;
  final int readingsLastMonth;
  final int alertsCount;

  UserStats({
    required this.totalGroups,
    required this.totalTags, 
    required this.readingsLastMonth,
    this.alertsCount = 0,
  });
}
