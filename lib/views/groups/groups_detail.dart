import 'package:flutter/material.dart';

class GroupDetailsScreen extends StatelessWidget {
  const GroupDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos Eletrônicos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Replace with your actual logo widget
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              'https://via.placeholder.com/50', // Placeholder image URL
              width: 40,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.location_on),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Produtos Eletrônicos',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Agrupamento de tags'),
                        ],
                      ),
                    ),
                    const Text(
                      '3 Tags',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: const [
                          Icon(Icons.bar_chart),
                          SizedBox(height: 8.0),
                          Text(
                            '15.5°C',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Média de temperatura'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: const [
                          Icon(Icons.thermostat),
                          SizedBox(height: 8.0),
                          Text(
                            '4.75°C',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Temp. mínima registrada'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: const [
                          Icon(Icons.thermostat),
                          SizedBox(height: 8.0),
                          Text(
                            '18.2°C',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Temp. máxima registrada'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement add tag functionality
              },
              icon: const Icon(Icons.add),
              label: const Text('Adicionar tag'),
            ),
            const SizedBox(height: 16.0),
            // List of tags
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.circle, color: Colors.green, size: 12.0),
                    title: const Text('NFC_1579A'),
                    subtitle: const Text('SASG1579AGIB6A5B'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.thermostat),
                        SizedBox(width: 4.0),
                        Text('15.7°C'),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.circle, color: Colors.green, size: 12.0),
                    title: const Text('NFC_1580B'),
                    subtitle: const Text('SASG1580BGIB6A5B'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.thermostat),
                        SizedBox(width: 4.0),
                        Text('18.2°C'),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.circle, color: Colors.orange, size: 12.0),
                    title: const Text('NFC_1581C'),
                    subtitle: const Text('SASG1581CGIB6A5B'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.thermostat),
                        SizedBox(width: 4.0),
                        Text('12.5°C'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Parâmetros do Grupo',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: const [
                        Icon(Icons.thermostat),
                        SizedBox(width: 8.0),
                        Text('Faixa ideal: 15°C - 25°C'),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: const [
                        Icon(Icons.bar_chart),
                        SizedBox(width: 8.0),
                        Text('Mínimo de leituras: 5'),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    const Text('Monitoramento de temperatura: 15°C - 25°C'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}