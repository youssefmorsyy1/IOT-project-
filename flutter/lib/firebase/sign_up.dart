// ignore_for_file: camel_case_types, non_constant_identifier_names, use_build_context_synchronously, avoid_print

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:project2/firebase/firebase_options.dart';
import 'package:project2/firebase/sign_in.dart';

class sign_up extends StatefulWidget {
  const sign_up({super.key});

  @override
  State<sign_up> createState() => _sign_upState();
}

class _sign_upState extends State<sign_up> {
  bool isBasswordVisible = false;
  final _EmailController = TextEditingController();
  final _PasswordController = TextEditingController();
  final _ConfirmPasswordController = TextEditingController();
  final _FirstNameController = TextEditingController();
  final _LastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
  }

  @override
  void dispose() {
    super.dispose();
    _EmailController.dispose();
    _PasswordController.dispose();
    _ConfirmPasswordController.dispose();
    _FirstNameController.dispose();
    _LastNameController.dispose();
  }

  bool PasswordCorrect() {
    return _PasswordController.text.trim() ==
        _ConfirmPasswordController.text.trim();
  }

  void SignIn() {
    Navigator.of(context).pushReplacementNamed('LoginScreen');
  }

  Future<void> SignUp() async {
    if (PasswordCorrect()) {
      try {
        // final userCredential =
        //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
        //   email: _EmailController.text.trim(),
        //   password: _PasswordController.text.trim(),
        // );

        // Send email verification
        // await userCredential.user?.sendEmailVerification();

        // Store user's first and last name in Firestore
        // await FirebaseFirestore.instance
        //     .collection('users')
        //     .doc(userCredential.user?.uid)
        //     .set({
        //   'email': _EmailController.text.trim(),
        //   'password': _PasswordController.text.trim(),
        //   'first_name': _FirstNameController.text.trim(),
        //   'last_name': _LastNameController.text.trim(),
        // });
        Fluttertoast.showToast(msg: "Please Check your email to verify");
        // Navigate to the verification page or show a message to verify email
        Navigator.of(context).popAndPushNamed("/sign_in");
      } catch (e) {
        // Handle any errors during sign-up
        print("Error during sign-up: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Sign Up',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _FirstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                hintText: 'Enter your first name',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _LastNameController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                hintText: 'Enter your last name',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _EmailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _PasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _ConfirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Confirm your password',
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Implementing signup logic
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => sign_in()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(
                    193, 40, 64, 99), // Change the text color
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
