import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DetailsTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TAG 1582D"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/logo.png'), // Replace with your logo asset
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "TAG 1582D",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text("SASG1582DGIB6A5BH477"),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Última temp. registrada"),
                          Text(
                            "20.30°C",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text("15/01/2024 - 11:00"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Icon(Icons.bar_chart),
                            Text("15.91°C", style: Theme.of(context).textTheme.titleMedium),
                            Text("Média de temperatura"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Icon(Icons.thermostat),
                            Text("4.75°C", style: Theme.of(context).textTheme.titleMedium),
                            Text("Temp. mínima registrada"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Icon(Icons.thermostat),
                            Text("35.20°C", style: Theme.of(context).textTheme.titleMedium),
                            Text("Temp. máxima registrada"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Temperatura x Leitura",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        height: 200,
                        child: _buildTemperatureChart(),
                      ),
                      SizedBox(height: 16.0),
                      Wrap(
                        spacing: 16.0,
                        runSpacing: 8.0,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildLegendItem(Colors.blue, "Variação de temperatura"),
                          _buildLegendItem(Colors.green, "Temperatura mínima configurada"),
                          _buildLegendItem(Colors.red, "Temperatura máxima configurada"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Informações do Grupo",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Container(
                            width: 16.0,
                            height: 16.0,
                            color: Colors.green,
                          ),
                          SizedBox(width: 8.0),
                          Text("Inventário Escritório"),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.thermostat),
                          SizedBox(width: 8.0),
                          Text("Faixa ideal: 18°C - 22°C"),
                        ],
                      ),
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

  Widget _buildTemperatureChart() {
    // Sample data for the chart
    final List<FlSpot> temperatureSpots = [
      FlSpot(0, 18.5),
      FlSpot(1, 19.2),
      FlSpot(2, 20.3),
      FlSpot(3, 21.0),
      FlSpot(4, 20.5),
    ];

    return LineChart(
      LineChartData(
        minY: 15,
        maxY: 25,
        lineBarsData: [
          // Temperature line
          LineChartBarData(
            spots: temperatureSpots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: true),
          ),
          // Min temperature line
          LineChartBarData(
            spots: [
              FlSpot(0, 18),
              FlSpot(1, 18),
              FlSpot(2, 18),
              FlSpot(3, 18),
              FlSpot(4, 18),
            ],
            isCurved: false,
            color: Colors.green,
            barWidth: 2,
            dashArray: [5, 5],
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: false),
          ),
          // Max temperature line
          LineChartBarData(
            spots: [
              FlSpot(0, 22),
              FlSpot(1, 22),
              FlSpot(2, 22),
              FlSpot(3, 22),
              FlSpot(4, 22),
            ],
            isCurved: false,
            color: Colors.red,
            barWidth: 2,
            dashArray: [5, 5],
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: false),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return Text('09:00', style: TextStyle(fontSize: 10));
                  case 1:
                    return Text('10:00', style: TextStyle(fontSize: 10));
                  case 2:
                    return Text('11:00', style: TextStyle(fontSize: 10));
                  case 3:
                    return Text('12:00', style: TextStyle(fontSize: 10));
                  case 4:
                    return Text('13:00', style: TextStyle(fontSize: 10));
                  default:
                    return Text('');
                }
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()}°C', style: TextStyle(fontSize: 10));
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey, width: 1),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16.0,
          height: 16.0,
          color: color,
        ),
        SizedBox(width: 4.0),
        Text(text, style: TextStyle(fontSize: 12.0)),
      ],
    );
  }
}

class TemperatureReading {
  final DateTime time;
  final double temperature;

  TemperatureReading(this.time, this.temperature);
}