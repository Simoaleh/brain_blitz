import 'package:flutter/material.dart';

class UserState extends ChangeNotifier {
  String _name = 'Player';
  String _username = 'player123';

  String get name => _name;
  String get username => _username;

  void setUser({required String name, required String username}) {
    _name = name;
    _username = username;
    notifyListeners();
  }

  void updateName(String name) {
    _name = name;
    notifyListeners();
  }

  void updateUsername(String username) {
    _username = username;
    notifyListeners();
  }
}
