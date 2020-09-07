import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import './mqttState.dart';

class MQTTManager {
  final MQTTState _currentState;
  MqttServerClient _client;
  final String _identifier;
  final String _host;
  final String _topic;

  MQTTManager(
      {@required String host,
      @required String identifier,
      @required String topic,
      @required MQTTState state})
      : _identifier = identifier,
        _currentState = state,
        _host = host,
        _topic = topic;

  void initializeMQTTClient() {
    _client = MqttServerClient(_host, _identifier);
    _client.port = 1883;
    _client.onDisconnected = onDisconnected;
    _client.keepAlivePeriod = 10;
    _client.secure = false;
    _client.logging(on: true);
  }

  void connect() async {
    assert(_client != null);
    try {
      print("connecting...");
      _currentState.setConnectionState(MQTTConnectionState.connecting);
      await _client.connect("test", "test");
    } catch (e) {
      print('client exception - $e');
      disconnect();
    }
  }

  void disconnect() {
    print("disconnecting...");
    _client.disconnect();
  }

  void publish(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(_topic, MqttQos.exactlyOnce, builder.payload);
  }

  void onSubscribe() {
    print("is now subscriping on topic : $_topic");
  }

  void onConnected() {
    _currentState.setConnectionState(MQTTConnectionState.connected);
    print("client is connected");
    _client.subscribe(_topic, MqttQos.exactlyOnce);
    _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage resMess = c[0].payload;
      final String message =
          MqttPublishPayload.bytesToString(resMess.payload.message);
      _currentState.setReceivingText(message);
      print(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $message -->');
    });
  }

  void onDisconnected() {
    print("client on disconnect...");
    if (_client.connectionStatus.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      print("client had been disconnected");
    }
    _currentState.setConnectionState(MQTTConnectionState.disconnected);
  }
}
