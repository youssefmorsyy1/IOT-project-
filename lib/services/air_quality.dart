// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:project2/services/writing.dart';
import 'MQTT.dart';
// import 'package:project2/firebase/sign_in.dart';

class air_quality extends StatefulWidget {
  const air_quality({super.key});

  @override
  _SensorReadingsWidgetState createState() => _SensorReadingsWidgetState();
}

class _SensorReadingsWidgetState extends State<air_quality> {
  // Initialize with a default value
  late String temperatureReading = 'N/A';
  late String humidityReading = 'N/A';
  late String gasReading = 'N/A';
  late String dustReading = 'N/A';

  final MQTTClientWrapper mqttClientWrapper = MQTTClientWrapper();
  // final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    mqttClientWrapper.prepareMqttClient();
    // mqttClientWrapper.subscribeToTopic("home/airquality/temperature");
    // mqttClientWrapper.subscribeToTopic("home/airquality/humidity");
    // mqttClientWrapper.subscribeToTopic("home/airquality/gas");
    // mqttClientWrapper.subscribeToTopic("home/airquality/PM");
    // mqttClientWrapper.onMessageReceived = (message) {
    //   setState(() {
    //     // final topic = message.topic;
    //     // final payload =
    //     //     MqttPublishPayload.bytesToStringAsString(message.payload.message);
    //     temperatureReading = mqttClientWrapper.temperatureReading;
    //     humidityReading = mqttClientWrapper.humidityReading;
    //     gasReading = mqttClientWrapper.gasReading;
    //     dustReading = mqttClientWrapper.dustReading;
    //     // Handle messages based on topic
    //   });
    // };
  }

  // Set up your MQTT client and subscribe to relevant topics
  // (You'll need to replace this with your actual implementation)

  // Example method to update sensor readings
  // void updateReadings(String temperature, String humidity) {
  //   setState(() {
  //     temperatureReading = mqttClientWrapper.temperatureReading;
  //     humidityReading = mqttClientWrapper.humidityReading;
  //     gasReading = mqttClientWrapper.gasReading;
  //     dustReading = mqttClientWrapper.dustReading;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Air Quality Readings'),
        actions: [
          // Add your custom button here
          IconButton(
            icon: const Icon(Icons.yard),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => devices_control()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2, // Two columns
          padding: const EdgeInsets.all(16),
          children: const [
            SensorCard(
              icon: Icons.thermostat_outlined,
              label: 'Temperature',
              value: '29°C', //temperatureReading
            ),
            SensorCard(
              icon: Icons.opacity_outlined,
              label: 'Humidity',
              value: '53.2%', //humidityReading
            ),
            SensorCard(
              icon: Icons.eco_outlined,
              label: 'CO₂',
              value: '497 PPM', //gasReading
            ),
            SensorCard(
              icon: Icons.air_outlined,
              label: 'VOC',
              value: '6.3 PPM', //dustReading
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //         centerTitle: true,
  //         title: const Text(
  //           'Air Quality',
  //           style: TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //         actions: [
  //           IconButton(
  //             onPressed: () {
  //               Navigator.popAndPushNamed(context, '/writing');
  //             },
  //             icon: const Icon(Icons.list_sharp),
  //           ),
  //         ],
  //       ),
  //       body: Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Text('Temperature: $temperatureReading °C'),
  //               Text('Humidity: $humidityReading %'),
  //               // Add more widgets for other sensors (e.g., gas sensor, dust sensor)

  //               // Example button to trigger data retrieval (you can replace this)
  //               ElevatedButton(
  //                 onPressed: () {
  //                   // Retrieve sensor data from MQTT broker and call updateReadings
  //                   // (Replace with your actual logic)
  //                   updateReadings('25.5', '60');
  //                 },
  //                 child: Text('Refresh Readings'),
  //               ),
  //             ],
  //           )));
  // }
}

class SensorCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const SensorCard(
      {super.key,
      required this.icon,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
