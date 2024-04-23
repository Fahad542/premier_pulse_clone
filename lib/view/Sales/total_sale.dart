import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyContainer extends StatefulWidget {
  final String title;
  final String value;
  final Color? containerColor; // Make it nullable

  const MyContainer({
    Key? key,
    required this.title,
    required this.value,
    this.containerColor, // Allow null, default is Colors.green[800]
  }) : super(key: key);

  @override
  State<MyContainer> createState() => _MyContainerState();
}

class _MyContainerState extends State<MyContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child:  Container(

          height: 40, // Adjust the percentage as needed
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.2), // Adjust the percentage as needed
          width: 100, // Adjust the percentage as needed
          decoration: BoxDecoration(

            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.green[800]!,  // Darker shade of green
                Colors.green[400]!,  // Lighter shade of green
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.green[800] ??Colors.white,
            //     offset: Offset(0, 2),
            //     blurRadius: 4.0,
            //   ),
            // ],

          ),

             child:   Text(
                  widget.value,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red),
                ),

        //
        // Text(
        //         widget.title,
        //         textAlign: TextAlign.center,
        //         style: TextStyle(fontSize:10, fontWeight: FontWeight.bold, color: Colors.white,  ),
        //       ),

          ),



    );

  }
}
class uniquecustomercontainer extends StatefulWidget {
  const uniquecustomercontainer({Key? key}) : super(key: key);

  @override
  State<uniquecustomercontainer> createState() => _uniquecustomercontainerState();
}

class _uniquecustomercontainerState extends State<uniquecustomercontainer> {
  @override
  Widget build(BuildContext context) {
    return   Container(
      decoration: BoxDecoration(color: Colors.white,
        borderRadius: BorderRadius.circular(12)
        , boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            color: Colors.green[800] ?? Colors.transparent,
            blurRadius: 4.0,
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Text(textAlign: TextAlign.center,"Total Customer", style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold),),
      ),
    );
  }
}
