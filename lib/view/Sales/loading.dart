import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class loading  extends StatefulWidget {
  const loading({Key? key}) : super(key: key);

  @override
  State<loading> createState() => _State();
}

class _State extends State<loading> {
  @override
  Widget build(BuildContext context) {
    return    AlertDialog(
      backgroundColor: Colors.green,  // Use transparent background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.green),
      ),
      elevation: 5,
      title: Center(
        child: Text(
          "Loading",
          style: TextStyle(color: Colors.white),
        ),
      ),
      content: Container(
        height: 40,
        width: 0,
        margin: EdgeInsets.all(10),  // Add margin to ensure visibility
        decoration: BoxDecoration(
          color: Colors.green,  // Background color for the Container
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }
}
