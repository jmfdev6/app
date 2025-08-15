# 🔐 Configuração de Variáveis de Ambiente - MooveTag

## 📋 O que são Variáveis de Ambiente?

As variáveis de ambiente são usadas para armazenar **informações sensíveis** (como chaves de API) fora do código-fonte, mantendo sua segurança e permitindo diferentes configurações para desenvolvimento e produção.

## 🚀 Configuração Rápida

### 1. Crie o arquivo `.env`

```bash
cp env.example .env
```

Ou crie manualmente um arquivo chamado `.env` na raiz do projeto.

### 2. Preencha suas credenciais

Edite o arquivo `.env` com suas credenciais do Supabase:

```env
# Configurações do Supabase - MooveTag
SUPABASE_URL=https://seuprojetoid.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 3. Obtenha suas credenciais do Supabase

1. **Acesse** [supabase.com](https://supabase.com)
2. **Entre** no seu projeto
3. **Navegue** para `Settings` > `API`
4. **Copie**:
   - **Project URL** → `SUPABASE_URL`
   - **anon/public key** → `SUPABASE_ANON_KEY`

## 📁 Estrutura de Arquivos

```
/home/jose-mario/Documentos/app/
├── .env                 # ❌ NUNCA commite (suas credenciais)
├── env.example         # ✅ Template (pode commitar)
├── .gitignore          # ✅ Protege o .env
└── lib/
    └── service/
        └── supabase_config.dart  # 🔧 Usa as variáveis
```

## 🔒 Segurança

### ✅ **FAÇA:**
- ✅ Mantenha o `.env` no `.gitignore`
- ✅ Use diferentes `.env` para desenvolvimento/produção
- ✅ Compartilhe apenas o `env.example`
- ✅ Regenere chaves se elas vazarem

### ❌ **NÃO FAÇA:**
- ❌ **NUNCA** commite o arquivo `.env`
- ❌ **NUNCA** compartilhe suas chaves por email/chat
- ❌ **NUNCA** coloque chaves no código-fonte
- ❌ **NUNCA** poste prints com suas chaves

## 🛠️ Como Funciona

### 1. **Carregamento das Variáveis**
```dart
// No main.dart
await dotenv.load(fileName: ".env");
```

### 2. **Uso das Variáveis**
```dart
// No supabase_config.dart
static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? 'fallback';
static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? 'fallback';
```

### 3. **Validação Automática**
Se as credenciais não estiverem configuradas, o app mostra uma tela de erro com instruções.

## 🚨 Resolução de Problemas

### **Erro: "Credenciais não configuradas"**
- ✅ Verifique se o arquivo `.env` existe na raiz
- ✅ Confirme que as variáveis estão no formato correto
- ✅ Reinicie o aplicativo após alterar o `.env`

### **Erro: "Failed to load .env"**
- ✅ Confirme que o `.env` está listado nos `assets` do `pubspec.yaml`
- ✅ Execute `flutter pub get` após alterações
- ✅ Verifique se não há espaços extras nas linhas

### **Erro de Conexão com Supabase**
- ✅ Verifique se a `SUPABASE_URL` está correta
- ✅ Confirme se a `SUPABASE_ANON_KEY` é válida
- ✅ Teste a conectividade com a internet

## 📊 Exemplo de .env Configurado

```env
# ✅ Exemplo correto
SUPABASE_URL=https://abcdefghijk.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiY2RlZmdoaWprIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDAwMDAwMDAsImV4cCI6MjAxNTU1NTU1NX0.exemplo-token-aqui
```

## 🔄 Diferentes Ambientes

### **Desenvolvimento (.env)**
```env
SUPABASE_URL=https://projeto-dev.supabase.co
SUPABASE_ANON_KEY=chave-desenvolvimento
```

### **Produção (.env.prod)**  
```env
SUPABASE_URL=https://projeto-prod.supabase.co
SUPABASE_ANON_KEY=chave-producao
```

## 📞 Precisa de Ajuda?

1. **Verifique** se seguiu todos os passos
2. **Consulte** o arquivo `env.example`  
3. **Teste** suas credenciais no painel do Supabase
4. **Reinicie** o app após mudanças no `.env`

---

**🔐 Lembre-se: A segurança de suas credenciais é fundamental!**
