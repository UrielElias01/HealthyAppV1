import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'notification_service.dart';

class MqttService {
  late final MqttServerClient client;
  final NotificationService notificationService;

  MqttService(this.notificationService) {
    client = MqttServerClient('broker.hivemq.com', '');
    client.logging(on: true);
    client.onDisconnected = onDisconnected;

    _connectAndSubscribe();
  }

  Future<void> _connectAndSubscribe() async {
    try {
      await client.connect();
      client.subscribe('sensor/temperature', MqttQos.atMostOnce);
      client.subscribe('sensor/steps', MqttQos.atMostOnce);

      // Verifica si el cliente no es null antes de intentar escuchar
      client.updates?.listen(
        (List<MqttReceivedMessage<MqttMessage>> event) {
          onMessage(event);
        },
        onError: (error) {
          print('Error en la recepción de mensajes: $error');
        },
        onDone: () {
          print('Suscripción finalizada.');
        },
        cancelOnError: true,
      );
    } catch (e) {
      print('Error al conectar o suscribirse: $e');
    }
  }

  void onDisconnected() {
    print('Disconnected');
  }

  void onMessage(List<MqttReceivedMessage<MqttMessage>> event) {
    final MqttPublishMessage message = event[0].payload as MqttPublishMessage;
    final String topic = event[0].topic;
    final String payload =
        MqttPublishPayload.bytesToStringAsString(message.payload.message);

    if (topic == 'sensor/temperature') {
      final double temperature = double.parse(payload);
      if (temperature < 35) {
        notificationService.showNotification(
            'Alerta de Temperatura', 'La temperatura es baja.');
      } else if (temperature > 38) {
        notificationService.showNotification(
            'Alerta de Temperatura', 'La temperatura es alta.');
      }
    } else if (topic == 'sensor/steps') {
      final int steps = int.parse(payload);
      // Procesar pasos (actualizar UI u otras acciones)
    }
  }
}
