import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo/screens/home.dart';

void main() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid = AndroidInitializationSettings(
      'app_icon'); // Replace 'app_icon' with your app icon
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Display the SplashScreen first
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a delay to simulate a splash screen effect
    Timer(
      Duration(seconds: 2),
      () {
        // Navigate to the HomeScreen after the delay
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlutterLogo(size: 150),
      ),
    );
  }
}
