// // ignore_for_file: file names, use key_in widget_constructors, depend_on_referenced_packages

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:project/home.dart';
// import 'package:project/firebase/sign_in.dart';

// class Auth extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:StreamBuilder<User?>(
//         stream:FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return HomePage();
//           } else {
//             return sign_in();
//           }
//         }),
//     );
//   }}