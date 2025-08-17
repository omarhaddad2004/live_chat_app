
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextChatField extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;
  final VoidCallback? gotounder;
  const TextChatField({super.key,required this.currentUserId,
    required this.otherUserId,this.gotounder});

  @override
  State<TextChatField> createState() => _TextChatFieldState();
}

class _TextChatFieldState extends State<TextChatField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode Stayfoucesd =FocusNode();

  String getChatId(String user1, String user2) {
    return user1.hashCode <= user2.hashCode
        ? '${user1}_$user2'
        : '${user2}_$user1';
  }

  void sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final chatId = getChatId(widget.currentUserId, widget.otherUserId);
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': widget.currentUserId,
      'receiverId': widget.otherUserId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _controller.clear();
    Stayfoucesd.requestFocus();
    widget.gotounder?.call();
  }
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24, width: 1.5),
        ),
        child: TextField(
          onSubmitted: (value)=>sendMessage(),
          focusNode: Stayfoucesd,
          controller: _controller,
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.black, fontSize: 18),
          decoration: InputDecoration(
            hintText: "Write Your Thoughts...",
            hintStyle: const TextStyle(color: Colors.black),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              onPressed: sendMessage,
            ),
            filled: true,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.white),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFF1e1e2f)),
            ),
          ),
        ),
      ),
    );
  }
}
