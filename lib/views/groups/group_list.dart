import 'package:app/app_theme.dart';
import 'package:app/service/database_service.dart';
import 'package:app/service/models.dart';
import 'package:app/service/enums.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupListScreen extends StatefulWidget {
  GroupListScreen({Key? key}) : super(key: key);

  @override
  State<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends State<GroupListScreen> {
  final DatabaseService _databaseService = DatabaseService();
  
  List<Grupo> _grupos = [];
  Map<String, List<Tag>> _tagsPerGroup = {};
  Map<String, List<Leitura>> _lastReadings = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadGrupos();
  }

  Future<void> _loadGrupos() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Carregar grupos do usuário
      final result = await _databaseService.getUserGrupos();
      
      if (result.success) {
        _grupos = result.data!;
        
        // Para cada grupo, carregar tags e últimas leituras
        for (final grupo in _grupos) {
          if (grupo.id != null) {
            // Carregar tags do grupo
            final tagsResult = await _databaseService.getTagsByGrupo(grupo.id!);
            if (tagsResult.success) {
              _tagsPerGroup[grupo.id!] = tagsResult.data!;
              
              // Para cada tag, carregar última leitura
              for (final tag in tagsResult.data!) {
                if (tag.id != null) {
                  final readingsResult = await _databaseService.getLeiturasByTag(tag.id!, limit: 1);
                  if (readingsResult.success && readingsResult.data!.isNotEmpty) {
                    _lastReadings[tag.id!] = readingsResult.data!;
                  }
                }
              }
            }
          }
        }
        
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = result.error;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro inesperado: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    await _loadGrupos();
  }

  void _navigateToCreateGroup() async {
    final result = await context.push('/createGroup');
    if (result == true) {
      // Se retornou true, significa que um grupo foi criado
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalGroups = _grupos.length;
    final totalTags = _tagsPerGroup.values.fold(0, (sum, tags) => sum + tags.length);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1E1E3F),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppTheme.darkTheme.iconTheme.color,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Grupos de Tags",
          style: AppTheme.darkTheme.textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: AppTheme.darkTheme.iconTheme.color,
            ),
            onPressed: _isLoading ? null : _refresh,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _buildBody(totalGroups, totalTags),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreateGroup,
        icon: const Icon(Icons.add),
        label: const Text('Novo Grupo'),
        backgroundColor: const Color(0xff1E1E3F),
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildBody(int totalGroups, int totalTags) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Carregando grupos...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar grupos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade300,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red.shade300),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    if (_grupos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum grupo encontrado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Crie seu primeiro grupo de monitoramento',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _navigateToCreateGroup,
              icon: const Icon(Icons.add),
              label: const Text('Criar Primeiro Grupo'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card de estatísticas
            Card(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade300, Colors.purple.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('Total de Grupos', totalGroups.toString(), Icons.folder),
                    _buildStatCard('Tags Registradas', totalTags.toString(), Icons.nfc),
                    _buildStatCard('Grupos Ativos', _grupos.where((g) => g.isActive).length.toString(), Icons.play_circle),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            
            // Lista de grupos
            ..._grupos.map((grupo) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: GrupoCard(
                grupo: grupo,
                tags: _tagsPerGroup[grupo.id] ?? [],
                lastReadings: _lastReadings,
                onTap: () => _navigateToGroupDetails(grupo),
                onEdit: () => _editGrupo(grupo),
                onDelete: () => _deleteGrupo(grupo),
              ),
            )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void _navigateToGroupDetails(Grupo grupo) {
    // Navegar para detalhes do grupo
    context.push('/tagDetails', extra: grupo);
  }

  void _editGrupo(Grupo grupo) {
    // TODO: Implementar edição de grupo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade de edição será implementada'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteGrupo(Grupo grupo) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja realmente excluir o grupo "${grupo.nome}"?\n\nEsta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (shouldDelete == true && grupo.id != null) {
      try {
        final result = await _databaseService.encerrarGrupo(grupo.id!);
        
        if (result.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Grupo encerrado com sucesso'),
              backgroundColor: Colors.green,
            ),
          );
          _refresh();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.error ?? 'Erro ao encerrar grupo'),
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
      }
    }
  }
}

// Widget para exibir o card de cada grupo
class GrupoCard extends StatelessWidget {
  final Grupo grupo;
  final List<Tag> tags;
  final Map<String, List<Leitura>> lastReadings;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GrupoCard({
    Key? key,
    required this.grupo,
    required this.tags,
    required this.lastReadings,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.folder_open),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.name,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(group.description),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Row(
                    children: [
                      Icon(Icons.remove_red_eye, color: Colors.grey.shade600),
                      const SizedBox(width: 4.0),
                      Text(
                        group.tagsCount.toString(),
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8.0),
                  const Icon(Icons.arrow_forward_ios, size: 16.0),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.thermostat, size: 16.0),
                  const SizedBox(width: 4.0),
                  Text(group.temperatureRange),
                  const SizedBox(width: 16.0),
                  const Icon(Icons.bar_chart, size: 16.0),
                  const SizedBox(width: 4.0),
                  Text('Min. leituras: ${group.minReadings}'),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Preview das tags:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              if (group.tagsPreview.isEmpty)
                Text(
                  'Nenhuma tag neste grupo',
                  style: TextStyle(color: Colors.grey),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: group.tagsPreview.length,
                  itemBuilder: (context, index) {
                    final tag = group.tagsPreview[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Container(
                            width: 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              color: tag.statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(child: Text(tag.name)),
                          Text(tag.temp),
                          const SizedBox(width: 8.0),
                          const Icon(
                            Icons.refresh,
                            size: 16.0,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}