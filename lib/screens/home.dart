import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mlambe_emergency/models/emergency.dart';
import 'package:mlambe_emergency/screens/emergency.dart';

import 'package:mlambe_emergency/screens/map.dart';
import 'package:url_launcher/url_launcher.dart';

import 'email/email.dart'; // Import url_launcher package

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          MapPage(),
          const SendEmailPage(
              emergencyData:
                  EmergencyData(email: '', latitude: 0, longitude: 0)),
          EmergencyPage(),
        ],
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emergency_outlined),
              label: 'Emergency',
            ),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.black,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          elevation: 5.0,
          onTap: (index) {
            if (_currentIndex != index) {
              setState(() {
                _currentIndex = index;
              });

              // Open the web app when Chat tab is selected
              if (index == 1) {
                _launchWebApp();
              }
            }
          },
        ),
      ),
    );
  }

  // Function to launch the web app
  Future<void> _launchWebApp() async {
    const url =
        'http://localhost:3000'; // Replace YOUR_PORT with the port of your web app
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
