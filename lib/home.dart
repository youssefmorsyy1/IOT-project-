import 'package:flutter/material.dart';
import 'firebase/sign_in.dart';
import 'firebase/sign_up.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Make the title bold
            color: Colors.white, // Make the title blue
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              'https://th.bing.com/th/id/OIG2.YYR2r.SNmnz2noNO5ATs?w=1792&h=1024&rs=1&pid=ImgDetMain',
              fit: BoxFit.cover, // Adjust fit as needed
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => sign_in()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(193, 40, 64, 99),
                backgroundColor: Colors.white, // Change the text color
              ),
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const sign_up()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(
                    193, 40, 64, 99), // Change the text color
              ),
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
