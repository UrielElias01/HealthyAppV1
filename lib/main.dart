import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:healtlyapp/services/mqtt_service.dart';
import 'package:healtlyapp/services/notification_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme:
            GoogleFonts.openSansTextTheme(Theme.of(context).textTheme).copyWith(
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double temperature = 0.0;
  int steps = 0;
  double caloriesBurned = 0.0;
  final int dailyStepGoal = 10000; // Límite de pasos diario
  late MqttService mqttService;
  late NotificationService notificationService;

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService();
    mqttService = MqttService(notificationService);
    // Aquí se puede añadir la lógica de suscripción a los datos MQTT
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitor de Sensor'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildDataCard(
                      'Temperatura', '$temperature°C', Icons.thermostat),
                  SizedBox(height: 20),
                  _buildDataCard('Pasos', '$steps', Icons.directions_walk),
                  SizedBox(height: 20),
                  _buildDataCard(
                      'Calorías Quemadas',
                      '${caloriesBurned.toStringAsFixed(2)} kcal',
                      Icons.local_fire_department),
                  SizedBox(height: 20),
                  _buildCircularStepIndicator(),
                  SizedBox(height: 20),
                  Container(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: true),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: const Color(0xff37434d),
                            width: 1,
                          ),
                        ),
                        minX: 0,
                        maxX: 10,
                        minY: 0,
                        maxY: 10,
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              FlSpot(0, 1),
                              FlSpot(1, 3),
                              FlSpot(2, 5),
                              FlSpot(3, 2),
                              FlSpot(4, 7),
                              FlSpot(5, 3),
                              FlSpot(6, 5),
                              FlSpot(7, 8),
                              FlSpot(8, 6),
                              FlSpot(9, 7),
                            ],
                            isCurved: true,
                            color: Colors.blue,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
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

  Widget _buildDataCard(String title, String value, IconData icon) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularStepIndicator() {
    double percentComplete = steps / dailyStepGoal;
    return CircularPercentIndicator(
      radius: 120.0,
      lineWidth: 13.0,
      animation: true,
      percent: percentComplete > 1.0 ? 1.0 : percentComplete,
      center: Text(
        "${(percentComplete * 100).toStringAsFixed(1)}%",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      footer: Text(
        "Progreso de Pasos",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: percentComplete >= 1.0 ? Colors.green : Colors.blue,
      backgroundColor: Colors.grey[300]!,
    );
  }

  void updateTemperature(double temp) {
    setState(() {
      temperature = temp;
    });
  }

  void updateSteps(int stepCount) {
    setState(() {
      steps = stepCount;
      caloriesBurned = _calculateCaloriesBurned(steps);
    });
  }

  double _calculateCaloriesBurned(int steps) {
    const double caloriesPerStep = 0.04; // Valor promedio
    return steps * caloriesPerStep;
  }
}
