# Configuração do Supabase para MooveTag

## 1. Criando o Projeto no Supabase

1. Acesse [supabase.com](https://supabase.com) e faça login
2. Clique em "New Project"
3. Escolha sua organização
4. Digite o nome do projeto: "moovetag" 
5. Crie uma senha segura para o banco de dados
6. Escolha uma região próxima ao Brasil (como `us-east-1`)
7. Clique em "Create new project"

## 2. Configurando o Banco de Dados

1. Aguarde o projeto ser criado (pode levar alguns minutos)
2. Vá para a aba "SQL Editor"
3. Copie e cole todo o conteúdo do arquivo `supabase_schema.sql` 
4. Execute o script clicando em "Run"

## 3. Configurando Autenticação

1. Vá para "Authentication" > "Settings"
2. Em "Site URL", configure sua URL:
   - Para desenvolvimento local: `http://localhost:3000`  
   - Para produção: sua URL de produção
3. Em "Auth Providers":
   - **Email**: já está habilitado por padrão
   - Configure outros provedores se necessário (Google, Apple, etc.)

### Configurações de Email (opcional)

1. Vá para "Authentication" > "Email Templates"
2. Personalize os templates de:
   - Confirmação de cadastro
   - Recuperação de senha
   - Convite

## 4. Configurando o App Flutter

1. Vá para "Settings" > "API"
2. Copie as seguintes informações:
   - **Project URL**: `https://seuprojetoid.supabase.co`
   - **Anon Key**: `sua-chave-publica-anonima`

3. No arquivo `lib/service/supabase_config.dart`, substitua:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://seuprojetoid.supabase.co';
  static const String supabaseAnonKey = 'sua-chave-publica-anonima';
  
  // ... resto do código
}
```

## 5. Instalando Dependências

Execute no terminal do projeto Flutter:

```bash
flutter pub get
```

## 6. Testando a Integração

1. Execute o app: `flutter run`
2. Tente criar uma conta nova
3. Faça login
4. Teste o logout
5. Verifique se as telas protegidas redirecionam corretamente

## 7. Verificando no Painel do Supabase

### Authentication
- Vá para "Authentication" > "Users"
- Verifique se os usuários aparecem quando se cadastram

### Database
- Vá para "Table Editor"
- Verifique se as tabelas foram criadas: `groups`, `tags`, `tag_readings`
- Teste inserindo alguns dados manualmente

### Logs
- Vá para "Logs" para verificar erros de API ou autenticação

## 8. Próximos Passos

### Funcionalidades Implementadas ✅
- ✅ Autenticação (login/cadastro)
- ✅ Roteamento protegido
- ✅ Logout funcional
- ✅ Estrutura do banco de dados
- ✅ Serviços de auth e database

### Funcionalidades a Implementar 📝
- 📝 Integrar criação de grupos nas telas
- 📝 Integrar listagem de grupos
- 📝 Funcionalidade de leitura de tags NFC
- 📝 Histórico de leituras
- 📝 Dashboard com estatísticas

## 9. Estrutura dos Serviços

### AuthService
- `signInWithEmail()` - Login com email/senha
- `signUpWithEmail()` - Cadastro de usuário  
- `signOut()` - Logout
- `currentUser` - Usuário atual
- `isAuthenticated` - Status de autenticação

### DatabaseService  
- `createGroup()` - Criar grupo
- `getUserGroups()` - Listar grupos do usuário
- `updateGroup()` - Atualizar grupo
- `deleteGroup()` - Deletar grupo
- `createTag()` - Criar tag
- `getUserTags()` - Listar tags do usuário
- `recordTagReading()` - Registrar leitura de tag

## 10. Modelos de Dados

### AppUser
- `id`, `email`, `name`, `createdAt`

### TagGroup  
- `id`, `name`, `description`, `userId`, `createdAt`, `updatedAt`

### NfcTag
- `id`, `tagId`, `name`, `description`, `location`, `groupId`, `userId`
- `lastScanned`, `createdAt`, `updatedAt`

### TagReading
- `id`, `tagId`, `userId`, `location`, `metadata`, `readAt`

## 11. Troubleshooting

### Erro de Conexão
- Verifique se as credenciais estão corretas
- Confirme se a URL do projeto está certa
- Teste a conectividade com a internet

### Erro de Autenticação
- Verifique se o RLS está configurado corretamente
- Confirme se as políticas de segurança estão ativas

### Erro de Permissão
- Verifique se as políticas RLS estão permitindo as operações
- Teste com o SQL Editor se as consultas funcionam manualmente

## 12. Recursos Úteis

- [Documentação do Supabase](https://supabase.com/docs)
- [Supabase Flutter SDK](https://supabase.com/docs/reference/dart)
- [Flutter Go Router](https://pub.dev/packages/go_router)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
