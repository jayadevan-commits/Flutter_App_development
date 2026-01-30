import'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String userEmail='';

  @override
 void initState() {
  super.initState();
  loadUserEmail();
 }

 Future<void> loadUserEmail() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    userEmail = prefs.getString('loggedInEmail') ?? 'No Email';
  });
 }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: Card(
          elevation: 4,
          margin:  const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          child: Padding(
            padding:const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.person, size: 40,color: Colors.white),
                ),

                const SizedBox(height: 12),
                const Text('Logged-in user',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                ),

                const SizedBox(height: 8),
                Text(
                  userEmail,
                  style: const TextStyle(fontSize: 14),
                )
              ], 
            ), 
            ),
        ),
      ),
    );
  }
 
}