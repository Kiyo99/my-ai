import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_ai/core/auth_local_datasource.dart';
import 'package:my_ai/widgets/message.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatViewModel extends ChangeNotifier {
  final AutoDisposeProviderReference _ref;

  ChatViewModel(this._ref);

  List<Message> _listMessages = [];

  List<Message> get listMessages => _listMessages;

  bool _showLoader = false;

  bool get showLoader => _showLoader;

  void getCachedMessages() {
    try {
      final cachedMessages =
          _ref.read(AuthLocalDataSource.provider).getCachedMessages();
      print("Cached messages: $cachedMessages");
      if (cachedMessages != null) {
        _listMessages.addAll(cachedMessages);
        notifyListeners();
      }
    } catch (e) {
      print("Error while getting messages: $e");
    }
  }

  void saveMessages(List<Message> messages) {
    _ref.read(AuthLocalDataSource.provider).cacheMessages(messages);
  }

  Future<void> promptGPT(String query) async {
    print("messages: $_listMessages");
    _listMessages = [..._listMessages, Message(text: query, isUser: true)];
    notifyListeners();

    _showLoader = true;

    final prompt = {
      "messages": _listMessages.map((msg) => msg.text).toList(),
    };

    try {
      final response = await http.post(
        Uri.parse("https://kiotech.onrender.com/chats"),
        headers: {"content-type": "application/json"},
        body: jsonEncode(prompt),
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        final botAnswer = res['answer'];
        print("Answer: $botAnswer");

        _listMessages.add(Message(isUser: false, text: botAnswer));
        _showLoader = false;
        saveMessages(_listMessages);
        notifyListeners();
      } else {
        _showLoader = false;
        print("API call failed with status code: ${response.statusCode}");
      }
    } catch (error) {
      _showLoader = false;
      print("API call failed with error: $error");
    }
    notifyListeners();
  }

  void clearMessages() {
    _ref.read(AuthLocalDataSource.provider).clearUserData();
    _listMessages.clear();
    Get.back();
    notifyListeners();
  }

  static final provider = ChangeNotifierProvider.autoDispose(
    (ref) => ChatViewModel(ref),
  );
}
