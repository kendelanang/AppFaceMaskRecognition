import 'package:coba/Dashboard.dart';
import 'package:coba/LoginPage.dart';
import 'package:coba/CapturePage.dart';
import 'package:coba/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Mask Recognition',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AutoLogiin(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AutoLogiin extends StatefulWidget {
  const AutoLogiin({Key key}) : super(key: key);

  @override
  State<AutoLogiin> createState() => _AutoLogiinState();
}

class _AutoLogiinState extends State<AutoLogiin> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return navigation();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
