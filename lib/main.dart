import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healtlyapp/services/mqtt_service.dart';
import 'package:healtlyapp/services/notification_service.dart'; // Añadir para fuentes personalizadas

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
          titleLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold), // Usar titleLarge o similar
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
            _buildDataCard('Temperatura', '$temperature°C', Icons.thermostat),
            SizedBox(height: 20),
            _buildDataCard('Pasos', '$steps', Icons.directions_walk),
            SizedBox(height: 20),
            _buildDataCard(
                'Calorías Quemadas',
                '${caloriesBurned.toStringAsFixed(2)} kcal',
                Icons.local_fire_department),
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
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge, // Usar titleLarge o similar
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
    const double caloriesPerStep = 0.05; // Valor promedio
    return steps * caloriesPerStep;
  }
}
