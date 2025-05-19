import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String fontFamily = 'Poppins';
  String _selectedTimeRange = 'Day';
  final List<String> _timeRanges = ['Day', 'Week', 'Month'];

@override
  Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNewLocationHeader(),
            // Remove padding at the top of this container
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTemperatureCard(),
                  const SizedBox(height: 8),
                  _buildSoilMoistureCard(),
                  const SizedBox(height: 8),
                  _buildHumidityCard(),
                  const SizedBox(height: 20),
                  _buildTimeRangeSelector(),
                  const SizedBox(height: 20),
                  _buildChart(),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildNewLocationHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE0F7E0),  // Light green background
            Color(0xFFD8F3D8),
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kebun Bayam',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                  fontFamily: fontFamily
                ),
              ),
              SizedBox(height: 5),
              Text(
                '15 April 2025  Updated 5 min ago',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontFamily: fontFamily,
                ),
              ),
            ],
          ),
          Image.asset(
            'assets/plant_icon.png',
            width: 100,
            height: 100,
            errorBuilder: (context, error, stackTrace) {
              return SizedBox(
                width: 100,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.eco,
                      size: 60,
                      color: Colors.green,
                    ),
                    Container(
                      height: 25,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.brown,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.thermostat,
                color: Colors.red,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Temperature (°C)',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: fontFamily,
                  ),
                ),
                Text(
                  '27.5',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontFamily,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

Widget _buildSoilMoistureCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/plant.png',
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Soil Mosture (%)',
                    style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: fontFamily,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '70',
                    style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontFamily,
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

  Widget _buildHumidityCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.water_drop,
                color: Colors.blue,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Humidity (%)',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: fontFamily,
                  ),
                ),
                Text(
                  '60',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontFamily,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: _timeRanges.map((range) {
          bool isSelected = _selectedTimeRange == range;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTimeRange = range;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2E7D32) : null,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: Text(
                  range,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16,
                    fontFamily: fontFamily,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

Widget _buildChart() {
  final List<Color> lineColors = [
    Colors.red,      // Temperature
    Colors.green,    // Soil Moisture
    Colors.blue,     // Humidity
  ];

  final List<String> legends = [
    'Temperature',
    'Soil Moisture', 
    'Humidity'
  ];

  // Generate random fluctuations around average values
  List<double> generatePoints(double average, double variance, int count) {
    final random = Random();
    return List.generate(count, (index) {
      return average + (random.nextDouble() - 0.5) * variance;
    });
  }

  // Generate data points with random fluctuations
  final tempPoints = generatePoints(27.5, 2.0, 6);  // Variance of ±1.0
  final soilPoints = generatePoints(70.0, 4.0, 6);  // Variance of ±2.0
  final humiPoints = generatePoints(60.0, 4.0, 6);  // Variance of ±2.0

  return AspectRatio(
    aspectRatio: 1.7,
    child: Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 5,
                  minY: 0,
                  maxY: 100,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 20,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300],
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300],
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 20,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontFamily: fontFamily,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final hours = ['00:00', '04:00', '08:00', '12:00', '16:00', '20:00'];
                          final index = value.toInt();
                          if (index >= 0 && index < hours.length) {
                            return Text(
                              hours[index],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontFamily: fontFamily,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    // Temperature Line (Red)
                    LineChartBarData(
                      spots: List.generate(6, (index) => 
                        FlSpot(index.toDouble(), tempPoints[index])
                      ),
                      isCurved: false,
                      color: lineColors[0],
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                    // Soil Moisture Line (Green)
                    LineChartBarData(
                      spots: List.generate(6, (index) => 
                        FlSpot(index.toDouble(), soilPoints[index])
                      ),
                      isCurved: false,
                      color: lineColors[1],
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                    // Humidity Line (Blue)
                    LineChartBarData(
                      spots: List.generate(6, (index) => 
                        FlSpot(index.toDouble(), humiPoints[index])
                      ),
                      isCurved: false,
                      color: lineColors[2],
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                return Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: lineColors[index],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      legends[index],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontFamily: fontFamily,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    ),
  );
}
}