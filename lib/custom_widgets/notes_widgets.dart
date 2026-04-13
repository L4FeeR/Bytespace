import 'package:flutter/material.dart';

class Tiles extends StatelessWidget {
  String title;
  final Color color; // Add this

  Tiles({super.key, required this.title, required this.color}); // Add color

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text(title)),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color, // Use dynamic color
      ),
    );
  }
}
