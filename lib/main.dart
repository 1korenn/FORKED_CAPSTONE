import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_dashboard_ui/const/constant.dart';
import 'package:flutter/material.dart';
import 'package:fitness_dashboard_ui/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCUtV7uuQdRm32ylRATJczcs5YqxmoCRuM",
        authDomain: "capstone-forked.firebaseapp.com",
        projectId: "capstone-forked",
        storageBucket: "capstone-forked.firebasestorage.app",
        messagingSenderId: "843926843316",
        appId: "1:843926843316:web:00aa960c3d17a8a55b4ce1",
        databaseURL: "https://capstone-forked-default-rtdb.asia-southeast1.firebasedatabase.app", // Add this line
      ),
    );
  } catch (e) {
    print("Firebase initialization error: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capstone App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromARGB(209, 33, 34, 45), // Match the const value `cardBackgroundColor`
      ),
      home: const MainScreen(),
    );
  }
}