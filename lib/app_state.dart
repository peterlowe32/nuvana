import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _getVersionsShortNameVar =
          prefs.getString('ff_getVersionsShortNameVar') ??
              _getVersionsShortNameVar;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _getVersionsShortNameVar = 'KJV';
  String get getVersionsShortNameVar => _getVersionsShortNameVar;
  set getVersionsShortNameVar(String value) {
    _getVersionsShortNameVar = value;
    prefs.setString('ff_getVersionsShortNameVar', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
