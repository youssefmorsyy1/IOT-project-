// ignore_for_file: library_private_types_in_public_api, camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:project2/services/MQTT.dart';
import 'package:project2/services/air_quality.dart';

// ignore: use_key_in_widget_constructors
class sign_in extends StatefulWidget {
  @override
  _sign_inState createState() => _sign_inState();
}

class _sign_inState extends State<sign_in> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final MQTTClientWrapper mqttClientWrapper = MQTTClientWrapper();

  @override
  void initState() {
    super.initState();
    mqttClientWrapper.prepareMqttClient();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Sign In',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              obscureText: true, // Correctly set obscureText property
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handling sign-in logic
                // mqttClientWrapper.publishMessage('sign_in_topic',
                //     'User signed in with email: ${_emailController.text}');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const air_quality()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(
                    193, 40, 64, 99), // Change the text color
              ),
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
