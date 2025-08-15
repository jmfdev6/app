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
    context.push('/groupDetails', extra: grupo);
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
    final hasAlerts = _hasTemperatureAlerts();
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: hasAlerts 
            ? BorderSide(color: Colors.orange.shade300, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header do grupo
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: grupo.isActive ? Colors.green.shade100 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      grupo.isActive ? Icons.folder_open : Icons.folder_off,
                      color: grupo.isActive ? Colors.green.shade700 : Colors.grey.shade600,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                grupo.nome,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (hasAlerts)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'ALERTA',
                                  style: TextStyle(
                                    color: Colors.orange.shade700,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Criado em ${_formatDate(grupo.dataCriacao)}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit();
                          break;
                        case 'delete':
                          onDelete();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 16),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 16, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Excluir', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    child: const Icon(Icons.more_vert, color: Colors.grey),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Informações do grupo
              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      Icons.thermostat,
                      grupo.temperaturaRange,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildInfoChip(
                      Icons.nfc,
                      '${tags.length} tags',
                      Colors.green,
                    ),
                  ),
                  if (grupo.quantidadeMinLeitura != null)
                    Expanded(
                      child: _buildInfoChip(
                        Icons.bar_chart,
                        'Min: ${grupo.quantidadeMinLeitura}',
                        Colors.purple,
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Preview das tags
              const Text(
                'Tags Associadas:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              
              if (tags.isEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Text(
                        'Nenhuma tag associada a este grupo',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: tags.take(3).map((tag) => _buildTagPreview(tag)).toList(),
                ),
              
              if (tags.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '+${tags.length - 3} tags adicionais',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: _getDarkerColor(color)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: _getDarkerColor(color),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDarkerColor(Color color) {
    if (color == Colors.blue) return Colors.blue.shade700;
    if (color == Colors.green) return Colors.green.shade700;
    if (color == Colors.purple) return Colors.purple.shade700;
    return color;
  }

  Widget _buildTagPreview(Tag tag) {
    final readings = lastReadings[tag.id] ?? [];
    final lastReading = readings.isNotEmpty ? readings.first : null;
    
    Color statusColor;
    if (!tag.isActive) {
      statusColor = Colors.grey;
    } else if (lastReading != null) {
      switch (lastReading.status) {
        case ReadingStatus.ok:
          statusColor = Colors.green;
          break;
        case ReadingStatus.alerta:
          statusColor = Colors.orange;
          break;
        case ReadingStatus.critico:
          statusColor = Colors.red;
          break;
        case ReadingStatus.erro:
          statusColor = Colors.red.shade800;
          break;
      }
    } else {
      statusColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tag.tagCode,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          if (lastReading != null)
            Text(
              lastReading.temperaturaFormatted,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: statusColor,
              ),
            )
          else
            Text(
              'Sem dados',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          const SizedBox(width: 8),
          Icon(
            tag.status.isActive ? Icons.check_circle : Icons.pause_circle,
            size: 16,
            color: tag.status.isActive ? Colors.green : Colors.grey,
          ),
        ],
      ),
    );
  }

  bool _hasTemperatureAlerts() {
    for (final tag in tags) {
      final readings = lastReadings[tag.id] ?? [];
      if (readings.isNotEmpty) {
        final lastReading = readings.first;
        if (lastReading.status.needsAttention) {
          return true;
        }
      }
    }
    return false;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}