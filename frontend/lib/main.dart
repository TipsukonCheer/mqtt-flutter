import 'package:flutter/material.dart';
import './view/Connection.dart';
import './mqttManager/mqttState.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Connection',
      home: ChangeNotifierProvider<MQTTState>(
        create: (_) => MQTTState(),
        child: Connection(),
      ),
    );
  }
}
