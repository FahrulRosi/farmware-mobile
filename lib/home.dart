import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class SensorData {
  final double suhu;
  final double kelembabanUdara;
  final double kelembabanTanah;
  final String timestamp;

  SensorData({
    this.suhu = 0,
    this.kelembabanUdara = 0,
    this.kelembabanTanah = 0,
    required this.timestamp,
  });
}

class _HomePageState extends State<HomePage> {
  static const String fontFamily = 'Poppins';
  String _selectedTimeRange = 'Day';
  final List<String> _timeRanges = ['Day', 'Week', 'Month'];

  // Add MQTT and sensor data variables
  late MqttServerClient _client;
  double _temperature = 0;
  double _humidity = 0;
  double _soilMoisture = 0;
  List<SensorData> _sensorHistory = [];
  static const int maxDataPoints = 10;

  @override
  void initState() {
    super.initState();
    _setupMqttClient();
  }

  Future<void> _setupMqttClient() async {
    _client = MqttServerClient(
        's1c71808.ala.asia-southeast1.emqxsl.com',
        'flutter_client_${DateTime.now().millisecondsSinceEpoch}');

    _client.port = 8883; // Port untuk MQTT over SSL
    _client.secure = true; // Menggunakan SSL
    _client.logging(on: true);
    _client.keepAlivePeriod = 60;
    _client.onDisconnected = onDisconnected;
    _client.onConnected = onConnected;
    _client.onSubscribed = onSubscribed;

    final connMessage = MqttConnectMessage()
        .authenticateAs('lokatani', 'lokatani711')
        .withClientIdentifier('flutter_client_${DateTime.now().millisecondsSinceEpoch}')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    _client.connectionMessage = connMessage;

    try {
      await _client.connect();
      if (_client.connectionStatus!.state == MqttConnectionState.connected) {
        debugPrint('Connected to MQTT broker');
        _client.subscribe('monitoring/sensor', MqttQos.atLeastOnce);

        _client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
          final recMess = messages[0].payload as MqttPublishMessage;
          final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
          _processMessage(payload);
        });
      }
    } catch (e) {
      debugPrint('Exception: $e');
      _client.disconnect();
    }
  }

  void onConnected() {
    debugPrint('Connected to MQTT broker');
  }

  void onDisconnected() {
    debugPrint('Disconnected from MQTT broker');
  }

  void onSubscribed(String topic) {
    debugPrint('Subscribed to topic: $topic');
  }

  void _processMessage(String payload) {
    try {
      final data = jsonDecode(payload);
      final timestamp = DateTime.now().toIso8601String();

      setState(() {
        if (data['node_id'] == 'node1') {
          if (data['tipe'] == 'kelembabanTanah') {
            _soilMoisture = data['nilai'].toDouble();
          }
        } else if (data['node_id'] == 'node2') {
          for (var item in data['data']) {
            if (item['tipe'] == 'suhu') {
              _temperature = item['nilai'].toDouble();
            } else if (item['tipe'] == 'kelembabanUdara') {
              _humidity = item['nilai'].toDouble();
            }
          }
        }

        // Update history
        final newData = SensorData(
          suhu: _temperature,
          kelembabanUdara: _humidity,
          kelembabanTanah: _soilMoisture,
          timestamp: timestamp,
        );

        _sensorHistory.add(newData);
        if (_sensorHistory.length > maxDataPoints) {
          _sensorHistory.removeAt(0);
        }
      });
    } catch (e) {
      debugPrint('Error processing message: $e');
    }
  }

  @override
  void dispose() {
    _client.disconnect();
    super.dispose();
  }

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
            Color(0xFFE0F7E0), // Light green background
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
                    fontFamily: fontFamily),
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

  // Modify _buildTemperatureCard to use real data
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
              children: [
                const Text(
                  'Temperature (°C)',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: fontFamily,
                  ),
                ),
                Text(
                  _temperature.toStringAsFixed(1),
                  style: const TextStyle(
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

  // Modify _buildSoilMoistureCard to use real data
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
                    _soilMoisture.toStringAsFixed(1),
                    style: const TextStyle(
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

  // Modify _buildHumidityCard to use real data
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
              children: [
                const Text(
                  'Humidity (%)',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: fontFamily,
                  ),
                ),
                Text(
                  _humidity.toStringAsFixed(1),
                  style: const TextStyle(
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

  // Modify _buildChart to use real data
  Widget _buildChart() {
    // Instead of random data, use _sensorHistory
    final spots = List<List<FlSpot>>.generate(3, (i) {
      return _sensorHistory.asMap().entries.map((entry) {
        final value = i == 0 ? entry.value.suhu :
                     i == 1 ? entry.value.kelembabanTanah :
                             entry.value.kelembabanUdara;
        return FlSpot(entry.key.toDouble(), value);
      }).toList();
    });

    final List<Color> lineColors = [
      Colors.red, // Temperature
      Colors.green, // Soil Moisture
      Colors.blue, // Humidity
    ];

    final List<String> legends = [
      'Temperature',
      'Soil Moisture',
      'Humidity'
    ];

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
                        spots: spots[0],
                        isCurved: false,
                        color: lineColors[0],
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                      // Soil Moisture Line (Green)
                      LineChartBarData(
                        spots: spots[1],
                        isCurved: false,
                        color: lineColors[1],
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                      // Humidity Line (Blue)
                      LineChartBarData(
                        spots: spots[2],
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