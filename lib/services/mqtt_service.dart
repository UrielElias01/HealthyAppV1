import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'notification_service.dart';

class MqttService {
  late final MqttServerClient client;
  final NotificationService notificationService;

  MqttService(this.notificationService) {
    // Usa un identificador único para el cliente
    client = MqttServerClient('broker.emqx.io', '');
    client.logging(on: true);
    client.onDisconnected = onDisconnected;

    _connectAndSubscribe();
  }

  Future<void> _connectAndSubscribe() async {
    try {
      // Conectar al broker
      final MqttClientConnectionStatus? status = await client.connect();
      if (status?.state == MqttConnectionState.connected) {
        print('MQTT client connected');
        // Suscribirse a los temas
        client.subscribe('sensor/temperature', MqttQos.atMostOnce);
        client.subscribe('health', MqttQos.atMostOnce);

        // Escuchar mensajes
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
      } else {
        print(
            'MQTT client connection failed - disconnecting, status is ${status?.state}');
        client.disconnect();
      }
    } catch (e) {
      print('Error al conectar o suscribirse: $e');
      client.disconnect();
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
      try {
        final double temperature = double.parse(payload);
        if (temperature < 35) {
          notificationService.showNotification(
              'Alerta de Temperatura', 'La temperatura es baja.');
        } else if (temperature > 38) {
          notificationService.showNotification(
              'Alerta de Temperatura', 'La temperatura es alta.');
        }
      } catch (e) {
        print('Error al procesar mensaje de temperatura: $e');
      }
    } else if (topic == 'health') {
      try {
        final int steps = int.parse(payload);
        // Procesar pasos (actualizar UI u otras acciones)
      } catch (e) {
        print('Error al procesar mensaje de health: $e');
      }
    }
  }
}
