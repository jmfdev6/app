import 'package:flutter/material.dart';
import 'package:app/service/database_service.dart';
import 'package:app/service/models.dart';
import 'package:app/service/auth_service.dart';
import 'package:go_router/go_router.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _tempMinController = TextEditingController();
  final _tempMaxController = TextEditingController();
  final _minLeituraController = TextEditingController();
  
  final DatabaseService _databaseService = DatabaseService();
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _tempMinController.dispose();
    _tempMaxController.dispose();
    _minLeituraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Header sem AppBar
              _buildHeader(),
              
              // Conteúdo scrollável
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      _buildWelcomeSection(),
                      const SizedBox(height: 32),
                      _buildFormCard(),
                      const SizedBox(height: 24),
                      _buildTipCard(),
                      const SizedBox(height: 24),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _cancelar,
            icon: const Icon(Icons.close),
            tooltip: 'Cancelar',
          ),
          const Expanded(
            child: Text(
              'Criar Novo Grupo',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 48), // Para balancear o botão close
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xff1E1E3F),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff1E1E3F).withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.folder_special,
            size: 48,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Configure seu Grupo",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Defina os parâmetros de monitoramento\npara suas tags NFC",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNomeField(),
            const SizedBox(height: 24),
            _buildTemperatureFields(),
            const SizedBox(height: 24),
            _buildMinLeituraField(),
          ],
        ),
      ),
    );
  }

  Widget _buildNomeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Nome do Grupo",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nomeController,
          decoration: InputDecoration(
            hintText: "Ex: Produtos Refrigerados",
            prefixIcon: const Icon(Icons.folder),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Nome do grupo é obrigatório';
            }
            if (value.trim().length < 3) {
              return 'Nome deve ter pelo menos 3 caracteres';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTemperatureFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Faixa de Temperatura (°C)",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _tempMinController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: "Mínima",
                  hintText: "0.0",
                  prefixIcon: const Icon(Icons.thermostat),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Obrigatório';
                  }
                  final temp = double.tryParse(value);
                  if (temp == null) {
                    return 'Valor inválido';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _tempMaxController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: "Máxima",
                  hintText: "25.0",
                  prefixIcon: const Icon(Icons.thermostat),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.red.shade50,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Obrigatório';
                  }
                  final temp = double.tryParse(value);
                  if (temp == null) {
                    return 'Valor inválido';
                  }
                  final tempMin = double.tryParse(_tempMinController.text);
                  if (tempMin != null && temp <= tempMin) {
                    return 'Deve ser > mínima';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMinLeituraField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quantidade Mínima de Leituras",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _minLeituraController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Ex: 10 (opcional)",
            prefixIcon: const Icon(Icons.bar_chart),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.purple.shade50,
            helperText: "Número mínimo de leituras para validação",
          ),
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final minLeitura = int.tryParse(value);
              if (minLeitura == null || minLeitura < 1) {
                return 'Deve ser um número inteiro positivo';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTipCard() {
    return Card(
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: Colors.blue.shade600,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "💡 Dica",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "• Configure temperaturas adequadas ao produto\n"
                    "• Use quantidade mínima para maior confiabilidade\n"
                    "• Você pode adicionar tags após criar o grupo",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : _cancelar,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Cancelar",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _criarGrupo,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff1E1E3F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    "Criar Grupo",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _cancelar() {
    if (_isLoading) return;
    
    // Se há dados preenchidos, confirmar antes de cancelar
    if (_hasFormData()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cancelar Criação'),
          content: const Text('Deseja realmente cancelar? Os dados preenchidos serão perdidos.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continuar Editando'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Sim, Cancelar'),
            ),
          ],
        ),
      );
    } else {
      context.pop();
    }
  }

  bool _hasFormData() {
    return _nomeController.text.trim().isNotEmpty ||
           _tempMinController.text.trim().isNotEmpty ||
           _tempMaxController.text.trim().isNotEmpty ||
           _minLeituraController.text.trim().isNotEmpty;
  }

  Future<void> _criarGrupo() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_authService.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário não autenticado'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final tempMin = double.parse(_tempMinController.text.trim());
      final tempMax = double.parse(_tempMaxController.text.trim());
      final minLeitura = _minLeituraController.text.trim().isNotEmpty
          ? int.parse(_minLeituraController.text.trim())
          : null;

      final grupo = Grupo(
        nome: _nomeController.text.trim(),
        temperaturaMin: tempMin,
        temperaturaMax: tempMax,
        quantidadeMinLeitura: minLeitura,
        dataCriacao: DateTime.now(),
        userId: _authService.currentUser!.id,
      );

      final result = await _databaseService.createGrupo(grupo);

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Grupo criado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Retorna true para indicar que um grupo foi criado
        context.pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.error ?? 'Erro ao criar grupo'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro inesperado: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}