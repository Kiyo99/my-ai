import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_ai/main.dart';
import 'package:my_ai/widgets/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

final preferenceManagerProvider = Provider<PreferenceManager>(
  (ref) => PreferenceManager(ref.watch(sharedPreferencesProvider)),
);

class PreferenceManager {
  final SharedPreferences prefs;

  static late final SharedPreferences staticPrefs;

  PreferenceManager(this.prefs) {
    staticPrefs = prefs;
  }

  List<Map<String, dynamic>> getJsonList(String key) {
    return List<Map<String, dynamic>>.from(
      jsonDecode(prefs.getString(key) ?? '[]'),
    );
  }

  Map<String, dynamic> getJsonMap(String key) {
    return Map<String, dynamic>.from(jsonDecode(prefs.getString(key) ?? '{}'));
  }

  void saveJson(String key, List<Map<String, dynamic>> json) {
    prefs.setString(key, jsonEncode(json));
  }

  void saveJsonMap(String key, Map<String, dynamic> json) {
    prefs.setString(key, jsonEncode(json));
  }

  Future<void> saveMessages(String key, List<Message> messages) async {
    try {
      final List<Map<String, dynamic>> messagesJsonList =
          messages.map((message) => message.toJson()).toList();

      await prefs.setString(key, jsonEncode(messagesJsonList));
    } catch (e) {
      print("Error: ${e}");
    }
  }

  String? getMessages(String key) {
    return prefs.getString(key);
  }
}
