import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class heading_container extends StatefulWidget {
  final String title;
  final double fontSize;
  final Color color;
  final Color? backgroundColor;
  final Color? gradientColor;

  const heading_container({
    Key? key,
    required this.title,
    this.fontSize = 13.0,
    this.color = Colors.white,
    this.backgroundColor,
    this.gradientColor, // Optional gradient color
  }) : super(key: key);

  @override
  State<heading_container> createState() => _HeadingContainerState();
}

class _HeadingContainerState extends State<heading_container> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: widget.gradientColor != null
              ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green[800]!,  // Darker shade of green
              Colors.green[400]!,  // Lighter shade of green
            ],
          )
              : null,
          color: widget.gradientColor ?? widget.backgroundColor, // Use provided gradient color or background color
          boxShadow: [
            BoxShadow(
              color:  Colors.black38,
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          widget.title,
          style: TextStyle(
            color: widget.color,
            fontSize: widget.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
