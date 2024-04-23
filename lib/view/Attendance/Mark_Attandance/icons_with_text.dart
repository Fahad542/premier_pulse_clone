import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final IconData iconData;
  final String text;

  IconText({required this.iconData, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          iconData,
          color: Colors.green,
          size: 40,// Icon color set to green
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
