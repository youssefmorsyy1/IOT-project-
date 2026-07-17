import 'package:flutter/material.dart';
import 'MQTT.dart';

class devices_control extends StatefulWidget {
  const devices_control({super.key});

  @override
  _DeviceControlWidgetState createState() => _DeviceControlWidgetState();
}

class _DeviceControlWidgetState extends State<devices_control> {
  bool fanOn = false;
  bool servoActivated = false;

  // Set up your MQTT client and subscribe to relevant topics
  // (You'll need to replace this with your actual implementation)

  // Example method to publish control commands
  void toggleFan() {
    // Publish MQTT message to turn the fan on/off
    // (Replace with your actual logic)
    setState(() {
      fanOn = !fanOn;
    });
  }

  void toggleServo() {
    // Publish MQTT message to activate/deactivate the servo motor
    // (Replace with your actual logic)
    setState(() {
      servoActivated = !servoActivated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Fan: ${fanOn ? 'ON' : 'OFF'}'),
        ElevatedButton(
          onPressed: toggleFan,
          child: Text(fanOn ? 'Turn Off Fan' : 'Turn On Fan'),
        ),
        const SizedBox(height: 20),
        Text('Servo Motor: ${servoActivated ? 'Activated' : 'Deactivated'}'),
        ElevatedButton(
          onPressed: toggleServo,
          child: Text(servoActivated ? 'Deactivate Servo' : 'Activate Servo'),
        ),
      ],
    );
  }
}
