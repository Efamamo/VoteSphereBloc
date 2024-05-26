import 'package:flutter/cupertino.dart';

class GroupProvider with ChangeNotifier {
  String _group = '';

  String get group => _group;

  void createGroup(groupName) {
    _group = groupName.text;
    notifyListeners();
  }
}
