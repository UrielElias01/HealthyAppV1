import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
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
      debugShowCheckedModeBanner: false,
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
  int dailyStepGoal = 10000; // Límite de pasos recomendado por día
  late MqttService mqttService;
  late NotificationService notificationService;

  // Datos simulados de pasos por día
  List<int> stepsPerDay = [9000, 8000, 10000, 12000, 7500, 11000, 9500];

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
                  CircularPercentIndicator(
                    radius: 100.0,
                    lineWidth: 10.0,
                    percent: steps / dailyStepGoal,
                    center: new Text(
                      "${(steps / dailyStepGoal * 100).toStringAsFixed(1)}%",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    progressColor: Colors.blue,
                    backgroundColor: Colors.grey.shade300,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Pasos durante la última semana',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        barGroups: stepsPerDay.asMap().entries.map((entry) {
                          int index = entry.key;
                          int steps = entry.value;
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: steps.toDouble(),
                                color: steps >= dailyStepGoal
                                    ? Colors.green
                                    : Colors.red,
                                width: 16,
                              ),
                            ],
                          );
                        }).toList(),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const style = TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                );
                                switch (value.toInt()) {
                                  case 0:
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text('Lun', style: style),
                                    );
                                  case 1:
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text('Mar', style: style),
                                    );
                                  case 2:
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text('Mié', style: style),
                                    );
                                  case 3:
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text('Jue', style: style),
                                    );
                                  case 4:
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text('Vie', style: style),
                                    );
                                  case 5:
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text('Sáb', style: style),
                                    );
                                  case 6:
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text('Dom', style: style),
                                    );
                                  default:
                                    return Text('', style: style);
                                }
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles:
                                  false, // Ocultar títulos del eje izquierdo
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles:
                                  false, // Ocultar títulos del eje derecho
                            ),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles:
                                  false, // Ocultar títulos del eje superior
                            ),
                          ),
                        ),
                        gridData: FlGridData(show: false),
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
