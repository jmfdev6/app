import 'package:flutter/material.dart';
import 'package:app/service/models.dart';
import 'package:app/service/database_service.dart';
import 'package:app/service/enums.dart';
import 'package:app/app_theme.dart';
import 'package:go_router/go_router.dart';

class GroupDetailsScreen extends StatefulWidget {
  final Grupo? grupo;
  
  const GroupDetailsScreen({Key? key, this.grupo}) : super(key: key);

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  final DatabaseService _databaseService = DatabaseService();
  
  List<Tag> _tags = [];
  Map<String, List<Leitura>> _tagReadings = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.grupo?.id != null) {
      _loadGroupData();
    } else {
      setState(() {
        _error = 'Grupo não encontrado';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadGroupData() async {
    if (widget.grupo?.id == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Carregar tags do grupo
      final tagsResult = await _databaseService.getTagsByGrupo(widget.grupo!.id!);
      
      if (tagsResult.success) {
        _tags = tagsResult.data!;
        
        // Carregar leituras para cada tag
        for (final tag in _tags) {
          if (tag.id != null) {
            final readingsResult = await _databaseService.getLeiturasByTag(tag.id!, limit: 10);
            if (readingsResult.success) {
              _tagReadings[tag.id!] = readingsResult.data!;
            }
          }
        }
        
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = tagsResult.error;
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
    await _loadGroupData();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.grupo == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Erro'),
          backgroundColor: const Color(0xff1E1E3F),
        ),
        body: const Center(
          child: Text('Grupo não encontrado'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.grupo!.nome),
        backgroundColor: const Color(0xff1E1E3F),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppTheme.darkTheme.iconTheme.color,
          ),
          onPressed: () => context.pop(),
        ),
        titleTextStyle: AppTheme.darkTheme.textTheme.headlineMedium,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: AppTheme.darkTheme.iconTheme.color,
            ),
            onPressed: _isLoading ? null : _refresh,
            tooltip: 'Atualizar',
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: AppTheme.darkTheme.iconTheme.color,
            ),
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _editGroup();
                  break;
                case 'end':
                  _endGroup();
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
                    Text('Editar Grupo'),
                  ],
                ),
              ),
              if (widget.grupo!.isActive)
                const PopupMenuItem(
                  value: 'end',
                  child: Row(
                    children: [
                      Icon(Icons.stop, size: 16, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Encerrar Grupo', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _buildBody(),
      ),
      floatingActionButton: widget.grupo!.isActive ? FloatingActionButton.extended(
        onPressed: _addTag,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar Tag'),
        backgroundColor: const Color(0xff1E1E3F),
        foregroundColor: Colors.white,
      ) : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Carregando dados do grupo...'),
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
              'Erro ao carregar grupo',
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

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card de informações do grupo
          _buildGroupInfoCard(),
          
          const SizedBox(height: 16.0),
          
          // Cards de estatísticas
          _buildStatisticsCards(),
          
          const SizedBox(height: 16.0),
          
          // Parâmetros do grupo
          _buildParametersCard(),
          
          const SizedBox(height: 16.0),
          
          // Lista de tags
          _buildTagsList(),
        ],
      ),
    );
  }

  Widget _buildGroupInfoCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.grupo!.isActive ? Colors.green.shade100 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                widget.grupo!.isActive ? Icons.folder_open : Icons.folder_off,
                color: widget.grupo!.isActive ? Colors.green.shade700 : Colors.grey.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.grupo!.nome,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Criado em ${_formatDate(widget.grupo!.dataCriacao)}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  if (!widget.grupo!.isActive) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Encerrado em ${widget.grupo!.dataEncerramento != null ? _formatDate(widget.grupo!.dataEncerramento!) : 'N/A'}',
                      style: TextStyle(
                        color: Colors.red.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: widget.grupo!.isActive ? Colors.green.shade100 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${_tags.length} Tags',
                style: TextStyle(
                  color: widget.grupo!.isActive ? Colors.green.shade700 : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCards() {
    final allReadings = _tagReadings.values.expand((readings) => readings).toList();
    final temperaturas = allReadings.map((r) => r.temperatura).toList();
    
    double? mediaTemp;
    double? minTemp;
    double? maxTemp;
    
    if (temperaturas.isNotEmpty) {
      mediaTemp = temperaturas.reduce((a, b) => a + b) / temperaturas.length;
      minTemp = temperaturas.reduce((a, b) => a < b ? a : b);
      maxTemp = temperaturas.reduce((a, b) => a > b ? a : b);
    }

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            Icons.bar_chart,
            mediaTemp?.toStringAsFixed(1) ?? 'N/A',
            'Temperatura Média',
            Colors.blue,
            mediaTemp != null ? '${mediaTemp.toStringAsFixed(1)}°C' : 'Sem dados',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            Icons.thermostat_outlined,
            minTemp?.toStringAsFixed(1) ?? 'N/A',
            'Temp. Mínima',
            Colors.cyan,
            minTemp != null ? '${minTemp.toStringAsFixed(1)}°C' : 'Sem dados',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            Icons.thermostat,
            maxTemp?.toStringAsFixed(1) ?? 'N/A',
            'Temp. Máxima',
            Colors.orange,
            maxTemp != null ? '${maxTemp.toStringAsFixed(1)}°C' : 'Sem dados',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label, Color color, String displayValue) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              displayValue,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParametersCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Parâmetros do Grupo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.thermostat, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                Text('Faixa ideal: ${widget.grupo!.temperaturaRange}'),
              ],
            ),
            if (widget.grupo!.quantidadeMinLeitura != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.bar_chart, color: Colors.purple.shade600),
                  const SizedBox(width: 8),
                  Text('Mínimo de leituras: ${widget.grupo!.quantidadeMinLeitura}'),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.green.shade600),
                const SizedBox(width: 8),
                Text('Status: ${widget.grupo!.isActive ? "Ativo" : "Encerrado"}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsList() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text(
                  'Tags Associadas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_tags.length} tags',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (_tags.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    const Text('Nenhuma tag associada a este grupo'),
                  ],
                ),
              ),
            )
          else
            Column(
              children: _tags.map((tag) => _buildTagListTile(tag)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildTagListTile(Tag tag) {
    final readings = _tagReadings[tag.id] ?? [];
    final lastReading = readings.isNotEmpty ? readings.first : null;
    
    Color statusColor;
    String statusText;
    
    if (!tag.isActive) {
      statusColor = Colors.grey;
      statusText = tag.status.displayName;
    } else if (lastReading != null) {
      switch (lastReading.status) {
        case ReadingStatus.ok:
          statusColor = Colors.green;
          statusText = 'Normal';
          break;
        case ReadingStatus.alerta:
          statusColor = Colors.orange;
          statusText = 'Alerta';
          break;
        case ReadingStatus.critico:
          statusColor = Colors.red;
          statusText = 'Crítico';
          break;
        case ReadingStatus.erro:
          statusColor = Colors.red.shade800;
          statusText = 'Erro';
          break;
      }
    } else {
      statusColor = Colors.grey;
      statusText = 'Sem dados';
    }

    return ListTile(
      leading: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: statusColor,
          shape: BoxShape.circle,
        ),
      ),
      title: Text(
        tag.tagCode,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status: $statusText',
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (lastReading != null)
            Text(
              'Última leitura: ${_formatDateTime(lastReading.dataHora)}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 11,
              ),
            ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (lastReading != null) ...[
            Text(
              lastReading.temperaturaFormatted,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
            Text(
              '${readings.length} leituras',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
          ] else ...[
            Icon(
              Icons.sensor_occupied,
              color: Colors.grey.shade400,
              size: 20,
            ),
            const Text(
              'Sem dados',
              style: TextStyle(fontSize: 10),
            ),
          ],
        ],
      ),
      onTap: () => _showTagDetails(tag),
    );
  }

  // Helper methods
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _editGroup() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade de edição será implementada'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _endGroup() async {
    final shouldEnd = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Encerrar Grupo'),
        content: Text('Deseja realmente encerrar o grupo "${widget.grupo!.nome}"?\n\nEsta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Encerrar'),
          ),
        ],
      ),
    );

    if (shouldEnd == true) {
      try {
        final result = await _databaseService.encerrarGrupo(widget.grupo!.id!);
        
        if (result.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Grupo encerrado com sucesso'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop(); // Voltar para a lista
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

  void _addTag() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade de adicionar tag será implementada'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showTagDetails(Tag tag) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tag ${tag.tagCode}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${tag.status.displayName}'),
            Text('Associada em: ${_formatDate(tag.dataAssociacao)}'),
            if (tag.dataFinalizacao != null)
              Text('Finalizada em: ${_formatDate(tag.dataFinalizacao!)}'),
            const SizedBox(height: 12),
            Text('Últimas leituras: ${(_tagReadings[tag.id] ?? []).length}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}