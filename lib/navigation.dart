import 'package:coba/CapturePage.dart';
import 'package:coba/Dashboard.dart';
import 'package:coba/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class navigation extends StatefulWidget {
  const navigation({Key key}) : super(key: key);

  @override
  State<navigation> createState() => _navigationState();
}

class _navigationState extends State<navigation> {
  int index = 1;
  final screens = [
    CapturePage(),
    Dashboard(),
    Dashboard(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            indicatorColor: Colors.deepPurpleAccent,
            backgroundColor: Colors.deepPurple,
            labelTextStyle: MaterialStateProperty.all(TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ))),
        child: NavigationBar(
          selectedIndex: index,
          height: 60,
          onDestinationSelected: (index) => setState(() => this.index = index),
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.camera,
                color: Colors.white,
              ),
              label: 'Capture',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              label: 'Exit',
            ),
          ],
        ),
      ),
    );
  }
}
