class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isUser': isUser,
    };
  }

  // Named constructor to create a Message object from a JSON map
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'],
      isUser: json['isUser'],
    );
  }
}
