import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:my_ai/screens/chat_screen.dart';

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My AI"),
        foregroundColor: Colors.black,
        backgroundColor: const Color(0xffEFB982),
      ),
      backgroundColor: const Color(0xff101010),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'I am your personal AI 🙂',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    Get.toNamed(ChatScreen.id);
                  },
                  child: const Text(
                    "Chat",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xffEFB982),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(ChatScreen.id);
        },
        tooltip: 'Increment',
        child: const Icon(
          Icons.chat_outlined,
          color: Colors.black,
        ),
        backgroundColor: const Color(0xffEFB982),
      ),
    );
  }
}
