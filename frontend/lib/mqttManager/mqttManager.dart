import 'package:flutter/material.dart';

enum MQTTConnectionState { connected, disconnected, connecting }

class MQTTState with ChangeNotifier {
  MQTTConnectionState _appConnectionState = MQTTConnectionState.disconnected;
  String _receivingText;
  List<String> _historyText;

  void setReceivingText(String message) {
    this._receivingText = message;
    _historyText.add(message);
    notifyListeners();
  }

  void setConnectionState(MQTTConnectionState state) {
    this._appConnectionState = state;
    notifyListeners();
  }

  String get getReceivingText => _receivingText;
  List<String> get getHistoryText => _historyText;
  MQTTConnectionState get connectionState => _appConnectionState;
}
