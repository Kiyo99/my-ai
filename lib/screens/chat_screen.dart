import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_ai/viewmodel/chat_viewmodel.dart';
import 'package:my_ai/widgets/messageBubble.dart';

class ChatScreen extends HookWidget {
  static String id = "chat_screen";

  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
    final chatViewModel = useProvider(ChatViewModel.provider);

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
        chatViewModel.getCachedMessages();
      });
      return;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My AI'),
        backgroundColor: const Color(0xffEFB982),
        foregroundColor: Colors.black,
        actions: [
          PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    child: const Text("Clear conversation"),
                    value: 'clear',
                  )
                ];
              },
              icon: const Icon(
                Icons.more_vert_outlined,
                color: Colors.black,
              ),
              onSelected: (value) {
                if (value == 'clear') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Clear Conversation'),
                        content: const Text(
                            'Are you sure you want to clear the conversation?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              chatViewModel.clearMessages();
                            },
                            child: const Text(
                              'Clear',
                              style: TextStyle(color: Color(0xffEFB982)),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              }),
        ],
      ),
      backgroundColor: const Color(0xff101010),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: chatViewModel.listMessages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                      text: chatViewModel.listMessages[index].text,
                      isUser: chatViewModel.listMessages[index].isUser,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Color(0xffEFB982),
                        ),
                        onPressed: () async {
                          final inputMessage = textController.text;
                          textController.clear();

                          chatViewModel.promptGPT(inputMessage);
                        }),
                  ],
                ),
              ),
            ],
          ),
          Center(
            child: chatViewModel.showLoader
                ? const CircularProgressIndicator(color: Color(0xffEFB982))
                : const SizedBox(),
          )
        ],
      ),
    );
  }
}
