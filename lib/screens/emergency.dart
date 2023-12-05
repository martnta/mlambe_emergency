// emergency_page.dart

import 'package:flutter/material.dart';
import '../controllers/emergency.dart';

import 'emergency_view.dart';

class EmergencyPage extends StatefulWidget {
  @override
  _EmergencyPageState createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  late EmergencyController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EmergencyController();
  }

  @override
  Widget build(BuildContext context) {
    return EmergencyView(controller: _controller);
  }
}
