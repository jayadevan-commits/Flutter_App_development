import 'package:flutter/material.dart';
//import 'bottom_navigation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.teal.shade50, // background color
      child: const Center(
        child: Text('welcome to Home Page',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
        ),
      )
    );
  }
}