import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_ai/core/constants.dart';
import 'package:my_ai/core/preference_manager.dart';
import 'package:my_ai/widgets/message.dart';

class AuthLocalDataSource {
  final PreferenceManager _preferenceManager;
  static final provider = Provider<AuthLocalDataSource>(
    (ref) => AuthLocalDataSource(ref.watch(preferenceManagerProvider)),
  );

  const AuthLocalDataSource(this._preferenceManager);

  void cacheMessages(List<Message> messages) {
    try {
      _preferenceManager.saveMessages(Constants.prefsMessageKey, messages);
    } catch (e) {
      print("Errrrrrr: ${e}");
    }
  }

  List<Message>? getCachedMessages() {
    try {
      final messages =
          _preferenceManager.getMessages(Constants.prefsMessageKey);
      if (messages != null) {
        final List<dynamic> messagesJsonList = json.decode(messages);

        final List<Message> loadedMessages =
            messagesJsonList.map((json) => Message.fromJson(json)).toList();

        return loadedMessages;
      }
      return null;
    } catch (e) {
      print("Error while gettttting messages: $e");
    }
  }

  void clearUserData() {
    _preferenceManager.prefs.remove(Constants.prefsMessageKey);
  }
}
