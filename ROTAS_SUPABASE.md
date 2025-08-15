# 🗺️ Guia Completo - Rotas e Endpoints do Supabase

## 🌐 **Acessos Principais**

### **1. Dashboard Principal**
```
https://supabase.com/dashboard/projects
```
→ Lista todos seus projetos

### **2. Projeto Específico**  
```
https://supabase.com/dashboard/project/[SEU-PROJECT-ID]
```
→ Dashboard do seu projeto MooveTag

---

## 🔧 **Configurações e APIs**

### **3. API Settings (Suas Credenciais)**
```
https://supabase.com/dashboard/project/[SEU-PROJECT-ID]/settings/api
```
→ **AQUI você pega:**
- ✅ `Project URL` → Para o `.env`
- ✅ `anon/public key` → Para o `.env`
- ✅ `service_role key` → Para admin

### **4. Database Settings**
```
https://supabase.com/dashboard/project/[SEU-PROJECT-ID]/settings/database
```
→ String de conexão PostgreSQL

---

## 🗄️ **Gerenciamento de Dados**

### **5. Table Editor (Visualizar/Editar Tabelas)**
```
https://supabase.com/dashboard/project/[SEU-PROJECT-ID]/editor
```
→ Ver suas tabelas: `groups`, `tags`, `tag_readings`

### **6. SQL Editor (Executar Queries)**
```
https://supabase.com/dashboard/project/[SEU-PROJECT-ID]/sql
```
→ Executar o arquivo `supabase_schema.sql`

### **7. Database Functions**
```
https://supabase.com/dashboard/project/[SEU-PROJECT-ID]/database/functions
```
→ Ver função `get_user_stats()`

---

## 👤 **Autenticação**

### **8. Authentication Users**
```
https://supabase.com/dashboard/project/[SEU-PROJECT-ID]/auth/users
```
→ **IMPORTANTE:** Criar usuários para login

### **9. Auth Settings**
```
https://supabase.com/dashboard/project/[SEU-PROJECT-ID]/auth/settings
```
→ Configurar URLs de redirect, providers

### **10. Auth Policies (RLS)**
```
https://supabase.com/dashboard/project/[SEU-PROJECT-ID]/auth/policies
```
→ Ver políticas de segurança Row Level Security

---

## 📊 **Monitoramento**

### **11. Logs**
```
https://supabase.com/dashboard/project/[SEU-PROJECT-ID]/logs
```
→ Ver logs de API, Auth, Database

### **12. API Logs**
```
https://supabase.com/dashboard/project/[SEU-PROJECT-ID]/logs/api
```
→ Requisições da API REST

---

## 🔗 **Endpoints da API REST**

### **Base URL do seu projeto:**
```
https://[SEU-PROJECT-ID].supabase.co
```

### **Principais endpoints:**

#### **🔐 Autenticação**
```
POST https://[PROJECT-ID].supabase.co/auth/v1/token?grant_type=password
POST https://[PROJECT-ID].supabase.co/auth/v1/logout
GET  https://[PROJECT-ID].supabase.co/auth/v1/user
```

#### **📊 Database (REST API)**
```
GET    https://[PROJECT-ID].supabase.co/rest/v1/groups
POST   https://[PROJECT-ID].supabase.co/rest/v1/groups
GET    https://[PROJECT-ID].supabase.co/rest/v1/tags
POST   https://[PROJECT-ID].supabase.co/rest/v1/tags
GET    https://[PROJECT-ID].supabase.co/rest/v1/tag_readings
POST   https://[PROJECT-ID].supabase.co/rest/v1/tag_readings
```

#### **⚡ Real-time (WebSocket)**
```
wss://[PROJECT-ID].supabase.co/realtime/v1/websocket
```

---

## 🛠️ **Como Encontrar Seu Project ID**

### **Método 1: No Dashboard**
1. Acesse `https://supabase.com/dashboard/projects`
2. Clique no seu projeto
3. Na URL você verá: `project/[AQUI-ESTA-SEU-ID]`

### **Método 2: Na Project URL**
Se sua URL é: `https://abcdefg123.supabase.co`
Então seu ID é: `abcdefg123`

---

## 🔍 **Verificando no Seu App**

Você pode ver as URLs que seu app está usando:

### **1. Verificar .env**
```bash
cat .env
```

### **2. Verificar no código**
```dart
// lib/service/supabase_config.dart
static String get supabaseUrl => dotenv.env['SUPABASE_URL'];
```

### **3. Debug no console**
Adicione no código para debug:
```dart
print('Supabase URL: ${SupabaseConfig.supabaseUrl}');
print('Supabase Client: ${SupabaseConfig.client.supabaseUrl}');
```

---

## 🚨 **Problemas Comuns**

### **❌ "Invalid API URL"**
- ✅ Verifique se a URL está correta no `.env`
- ✅ Não deve ter espaços ou quebras de linha
- ✅ Deve começar com `https://`

### **❌ "API key not found"**
- ✅ Verifique se a chave `anon` está correta
- ✅ Copie novamente do dashboard
- ✅ Não use a chave `service_role` no frontend

### **❌ "Failed to load .env"**
- ✅ Arquivo `.env` deve estar na raiz do projeto
- ✅ Deve estar listado em `assets` no `pubspec.yaml`
- ✅ Execute `flutter pub get` após mudanças

---

## 🎯 **Próximos Passos**

1. **Configure** suas credenciais no `.env`
2. **Crie** usuários em Auth > Users
3. **Execute** o schema SQL em SQL Editor  
4. **Teste** o login no app

**📞 Precisa de ajuda?** Me avise qual rota específica você quer acessar!
