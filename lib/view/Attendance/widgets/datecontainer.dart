// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
//
// class Datecontainer extends StatefulWidget {
//   final String title;
//   final String range;
//   bool isVisible;
//
//   Datecontainer({
//     Key? key,
//     required this.title,
//     required this.range,
//     required this.isVisible,
//   }) : super(key: key);
//
//   @override
//   _DatecontainerState createState() => _DatecontainerState();
// }
//
// class _DatecontainerState extends State<Datecontainer> {
//   DateTime? selectedDate;
//
//   void _onDateSelected(DateTime date) {
//     setState(() {
//       selectedDate = date;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Visibility(
//       visible: widget.isVisible,
//       child: GestureDetector(
//         onTap: () {
//           showDialog(
//             context: context,
//             builder: (context) {
//               return DatePickerDialog(onDateSelected:_onDateSelected);
//             },
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             height: 80,
//             width: 120,
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.green,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black38,
//                   blurRadius: 5,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     widget.title,
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                   Text(
//                     selectedDate != null
//                         ? DateFormat('yyyy-MM-dd').format(selectedDate!)
//                         : widget.range,
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }