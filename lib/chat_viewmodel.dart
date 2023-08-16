import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_ai/message.dart';
import 'package:my_ai/messageBubble.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatViewModel extends ChangeNotifier {
  final AutoDisposeProviderReference _ref;

  ChatViewModel(this._ref);

  List<Message> _listMessages = [];

  List<Message> get listMessages => _listMessages;

  bool _showLoader = false;

  bool get showLoader => _showLoader;

  Future<void> promptGPT(String query) async {
    _listMessages = [..._listMessages, Message(query, true)];
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
        print("Answer: ${botAnswer}");

        _listMessages.add(Message(botAnswer, false));
        _showLoader = false;
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

  static final provider = ChangeNotifierProvider.autoDispose(
    (ref) => ChatViewModel(ref),
  );
}
