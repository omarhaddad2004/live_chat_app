import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../wedgets/ChatBubble.dart';
import '../wedgets/Text_chat_field.dart';


class ChatPage extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;
  final String displayName;
  final String? imageUrl;


  const ChatPage({super.key,required this.currentUserId,
    required this.otherUserId,
    required this.displayName,
    this.imageUrl,

  });


  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final  _controller = ScrollController();


  String getChatId(String user1, String user2) {
    return user1.hashCode <= user2.hashCode
        ? '${user1}_$user2'
        : '${user2}_$user1';
  }
  void scrolltounder(){

  _controller.animateTo(0.0, duration: Duration(seconds: 1), curve:Curves.ease);

}

  @override
  Widget build(BuildContext context) {
    final chatId = getChatId(widget.currentUserId, widget.otherUserId);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1e1e2f),
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage(
                (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                    ? widget.imageUrl!
                    : 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
              ),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(width: 12),
            Text(
              widget.displayName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1e1e2f),
              Color(0xFF8B8C8C),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(chatId)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    controller: _controller,
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isme = (msg['senderId']??'')==widget.currentUserId;




                      return Chatbubble(msg['text'],isme);
                    },
                  );
                },
              ),
            ),
            TextChatField(currentUserId: widget.currentUserId, otherUserId: widget.otherUserId,gotounder:scrolltounder,
                ),


          ],
        ),
      ),
    );
  }
}

