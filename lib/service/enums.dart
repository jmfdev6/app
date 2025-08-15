// Enums para o sistema MooveTag baseado no schema do Supabase

// Enum para roles de usuário
enum UserRole {
  operador('operador'),
  admin('admin');

  const UserRole(this.value);
  final String value;

  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'operador':
      default:
        return UserRole.operador;
    }
  }

  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Administrador';
      case UserRole.operador:
        return 'Operador';
    }
  }

  bool get isAdmin => this == UserRole.admin;
}

// Enum para status das tags
enum TagStatus {
  ativa('ativa'),
  inativa('inativa'),
  manutencao('manutencao');

  const TagStatus(this.value);
  final String value;

  static TagStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'ativa':
        return TagStatus.ativa;
      case 'inativa':
        return TagStatus.inativa;
      case 'manutencao':
        return TagStatus.manutencao;
      default:
        return TagStatus.ativa;
    }
  }

  String get displayName {
    switch (this) {
      case TagStatus.ativa:
        return 'Ativa';
      case TagStatus.inativa:
        return 'Inativa';
      case TagStatus.manutencao:
        return 'Manutenção';
    }
  }

  bool get isActive => this == TagStatus.ativa;
}

// Enum para status das leituras
enum ReadingStatus {
  ok('ok'),
  alerta('alerta'),
  critico('critico'),
  erro('erro');

  const ReadingStatus(this.value);
  final String value;

  static ReadingStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'ok':
        return ReadingStatus.ok;
      case 'alerta':
        return ReadingStatus.alerta;
      case 'critico':
        return ReadingStatus.critico;
      case 'erro':
        return ReadingStatus.erro;
      default:
        return ReadingStatus.ok;
    }
  }

  String get displayName {
    switch (this) {
      case ReadingStatus.ok:
        return 'Normal';
      case ReadingStatus.alerta:
        return 'Alerta';
      case ReadingStatus.critico:
        return 'Crítico';
      case ReadingStatus.erro:
        return 'Erro';
    }
  }

  bool get isNormal => this == ReadingStatus.ok;
  bool get needsAttention => this == ReadingStatus.alerta || this == ReadingStatus.critico;
  bool get isCritical => this == ReadingStatus.critico;
}
