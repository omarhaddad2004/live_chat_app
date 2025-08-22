import 'package:chat_app/Screens/Chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../wedgets/Search_user_bar.dart';
import '../wedgets/User_continer.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1e1e2f),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              'Omars Chat',
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 7),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/logo/app_logo.png',
                  height: 32,
                ),
                const SizedBox(width: 8), 
                Expanded(
                  child: Searchbar(
                    onSearch: (value) {
                      setState(() {
                        user = value.trim();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('displayName', isNotEqualTo: null)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No users found", style: TextStyle(color: Colors.white)),
                    );
                  }

                  final allUsers = snapshot.data!.docs;
                  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

                  final filteredUsers = user == null || user!.isEmpty
                      ? allUsers.where((doc)=>doc.id !=currentUserId).toList()
                      : allUsers.where((doc) {
                    final displayName = (doc['displayName'] ?? '').toString().toLowerCase();
                    return displayName.contains(user!.toLowerCase());
                  }).toList();

                  if (filteredUsers.isEmpty) {
                    return const Center(
                      child: Text("No matching users", style: TextStyle(color: Colors.white)),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final userDoc = filteredUsers[index];

                      return GestureDetector(
                        onTap: () {
                          final selectedUserId = userDoc.id;
                          final displayName = userDoc['displayName'];



                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                currentUserId: currentUserId,
                                otherUserId: selectedUserId,
                                displayName: displayName,
                              ),
                            ),
                          );
                        },

                        child: Usercontiner(
                          displayName: userDoc['displayName'],
                          //imageUrl: userDoc['imageUrl'],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
