import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPopupMenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final bool showDateContainers;
  final bool ischeck;
  final Function() onTap;

  const CustomPopupMenuItem({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.showDateContainers,
    required this.ischeck,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuItem(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.green[800],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          SizedBox(width: 6),
          Text(text, style: TextStyle(fontSize: 14)),
        ],
      ),
      value: text.toLowerCase(),
      onTap: onTap,
    );
  }
}
