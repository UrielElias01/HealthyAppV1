# HealtlyApp
Proyecto desarrollado por:
- Cruz Breña Daniela Janeth
- Elías Velázquez Ángel Uriel
- Garay García Omar Ricardo

## Enunciado de Visión

Desarrollar una aplicación de monitoreo de salud para dispositivos IoT que permita a los usuarios rastrear en tiempo real sus signos vitales, como la temperatura, humedad, y aceleración, mediante una conexión establecida con un módulo ESP32. Los datos serán almacenados y gestionados a través del protocolo MQTT utilizando Mosquitto, proporcionando así una solución eficiente y accesible para el seguimiento de la salud desde la comodidad de un smartphone.

## Software Empleado

## Stack Tecnológico

| **Componente**                  | **Descripción**                                       | **Versión** | **Tipo**        |
|---------------------------------|-------------------------------------------------------|-------------|-----------------|
| **Lenguaje de Programación**    | Dart                                                  | x.x.x       | Lenguaje        |
| **Framework**                   | Flutter                                               | x.x.x       | Framework       |
| **Backend**                     | Mosquitto MQTT                                        |             | Backend         |
| **Base de Datos**               | [Base de Datos a Elegir, ej. Firebase, SQLite]        |             | Base de Datos   |
| **Autenticación**               | [Autenticación a Elegir]                              |             | Autenticación   |
| **Control de Versiones**        | Git                                                   |             | Control de Versión |
| **IDE**                         | Visual Studio Code                                    |             | IDE             |
| **Emulador**                    | Android Studio                                        |             | Emulador        |

## Hardware Empleado

| **Id** | **Componente**                       | **Descripción**                                                                                       | **Imagen**                                       | **Cantidad** | **Costo total (MXN)** |
|--------|--------------------------------------|-------------------------------------------------------------------------------------------------------|--------------------------------------------------|--------------|-----------------------|
| 1      | Sensor de Temperatura y Humedad      | Sensor para medir la temperatura y humedad ambiental                                                   | ![Sensor](https://m.media-amazon.com/images/I/51J9ha5fZKL.jpg)       | 1            | $87.45                |
| 2      | Protoboard                           | Protoboard de 830 puntos para pruebas de conexiones                                                   | ![Protoboard](https://aelectronics.com.mx/893/protoboard-blanca-de-830-puntos.jpg)   | 1            | $61.75                |
| 3      | Módulo ESP32 WiFi + Bluetooth        | Módulo de microcontrolador ESP32 con conectividad WiFi y Bluetooth                                      | ![ESP32](https://m.media-amazon.com/images/I/61o2ZUzB4XL._AC_UF894,1000_QL80_.jpg)        | 1            | $115.12               |
| 4      | Giroscopio Acelerómetro de 3 Ejes    | Sensor de giroscopio y acelerómetro para detectar la orientación y el movimiento                       | ![Giroscopio](https://m.media-amazon.com/images/I/71fRWt6pQ2L._AC_UF894,1000_QL80_.jpg)   | 1            | $64.99                |
| 5      | Pantalla OLED 128x32                 | Pantalla OLED para mostrar datos en tiempo real                                                        | ![Pantalla](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0xEVezQ607bIevqBh5xch5ma0XMIXLTt1GQ&s)     | 1            | $81.00                |
| 6      | Kit Buzzer Zumbador 5V               | Zumbador activo para emitir alertas audibles                                                           | ![Buzzer](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMXy2A84nGyNNJUbl8ERSyD4lGIj6Fvrr7Kw&s)       | 1            | $39.00                |

## Prototipos
<p align="center">
    <img src="./Primer boceto1.png" alt="Primer boceto" width="330"/>
    <img src="./Segundo boceto2.png" alt="Segundo boceto" width="330"/>
</p>

## Tablero Trello
   [Trello](https://trello.com/b/TBIptBx5/healtlyapp)

## Historias de Usuario

| Historia de Usuario              | Como                  | Quiero                                                | Para                                                   |
|----------------------------------|-----------------------|-------------------------------------------------------|--------------------------------------------------------|
| Registro de Signos Vitales       | Usuario               | Registrar mis signos vitales en tiempo real           | Monitorear mi salud de manera continua                 |
| Notificaciones de Alertas        | Usuario               | Recibir alertas cuando mis signos vitales sean anormales | Actuar rápidamente en caso de emergencia                |
| Visualización de Datos           | Usuario               | Ver mis datos de salud en una pantalla OLED           | Tener una referencia visual rápida y clara             |
| Acceso Rápido                    | Usuario               | Acceder a los datos de mi salud desde la app          | Monitorear mis signos vitales en cualquier momento     |
| Sincronización de Dispositivos   | Usuario               | Que los datos se sincronicen entre el ESP32 y mi smartphone | Tener acceso a la información actualizada en mi dispositivo móvil |
