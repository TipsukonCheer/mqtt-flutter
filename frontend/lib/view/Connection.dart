import 'package:flutter/material.dart';
import '../mqttManager/mqttManager.dart';
import '../mqttManager/mqttState.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

class Connection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ConnectionState();
  }
}

class _ConnectionState extends State<Connection> {
  final String host = "localhost";
  final String topic = "test";
  MQTTState currentState;
  MQTTManager manager;
  @override
  Widget build(BuildContext context) {
    final MQTTState state = Provider.of<MQTTState>(context);
    currentState = state;
    final Scaffold scaffold = Scaffold(
        appBar: AppBar(
          title: const Text('Test connection'),
        ),
        body: Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                color: Colors.lightBlueAccent,
                child: const Text('Connect'),
                onPressed: currentState.connectionState ==
                        MQTTConnectionState.disconnected
                    ? connect
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RaisedButton(
                color: Colors.redAccent,
                child: const Text('Disconnect'),
                onPressed: currentState.connectionState ==
                        MQTTConnectionState.connected
                    ? _disconnect
                    : null,
              ),
            ),
          ],
        ));
    return scaffold;
  }

  void connect() {
    String osPrefix = 'Flutter_iOS';
    if (Platform.isAndroid) {
      osPrefix = 'Flutter_Android';
    }
    manager = MQTTManager(
        host: host, topic: topic, identifier: osPrefix, state: currentState);
    manager.initializeMQTTClient();
    manager.connect();
    currentState.setConnectionState(MQTTConnectionState.connected);
  }

  void _disconnect() {
    manager.disconnect();
  }
}
