import 'package:app/app_theme.dart';
import 'package:flutter/material.dart';

class ReadTagsScreen extends StatefulWidget {
  @override
  _ReadTagsScreenState createState() => _ReadTagsScreenState();
}

class _ReadTagsScreenState extends State<ReadTagsScreen> {
  String? _selectedGroup;
  List<String> _groups = ['Grupo 1', 'Grupo 2', 'Grupo 3']; // Example groups

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1E1E3F),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.darkTheme.iconTheme.color,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Leitura de Tags", style: AppTheme.darkTheme.textTheme.headlineMedium,),
       
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selecionar Grupo',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    DropdownButtonFormField<String>(

                      value: _selectedGroup,
                      hint: Text('Escolha um grupo para associar as tags'),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedGroup = newValue;
                        });
                      },
                      items: _groups.map((group) {
                        return DropdownMenuItem(
                          value: group,
                          child: Text(group),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Leitura Inativa',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '0 tags',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 18, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('Localização atual (Exemplo)'),
                      ],
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement start reading logic
                      },
                      child: Text('Iniciar Leitura'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(40), // Full width button
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Como usar:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    _buildNumberedListItem('1','Selecione um grupo para associar as tags'),
                    _buildNumberedListItem('2','Inicie a leitura automática'),
                    _buildNumberedListItem('3','Aproxime as tags NFC do dispositivo'),
                    _buildNumberedListItem('4','Monitore as temperaturas capturadas'),
                    _buildNumberedListItem('5','Finalize o registro quando terminar'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberedListItem( String numero,String text , ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(numero, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(' • ', style: TextStyle(fontSize: 16)), // Simple bullet for numbering
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}