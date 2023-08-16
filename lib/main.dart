import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:my_ai/chat_page.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //   primarySwatch: Color(0xffEFB982)
        // ),
        home: MyHomePage(title: 'My AI'),
        routes: {
          ChatScreen.id: (context) => const ChatScreen(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showCards = false;
  final tasks = [];

  Future<void> _incrementCounter() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:3001/api/getTasks"),
      );
      print("Tasks are: ${response.body}");
      setState(() {
        tasks.clear();
        tasks.addAll(jsonDecode(response.body));
        showCards = true;
      });
    } catch (e) {
      print("Error is ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        foregroundColor: Colors.black,
        backgroundColor: Color(0xffEFB982),
      ),
      backgroundColor: Color(0xff101010),
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
              if (showCards == true)
                SizedBox(
                  height: 600,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Container(
                        color: Color(0xffEFB982),
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            Text(tasks[index]["taskName"]),
                            Text(tasks[index]["taskDesc"])
                          ],
                        ),
                      );
                    },
                    itemCount: tasks.length,
                  ),
                ),
              SizedBox(height: 10),
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
              SizedBox(height: 10),
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
        backgroundColor: Color(0xffEFB982),
      ),
    );
  }
}
