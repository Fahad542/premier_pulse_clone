import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// class DatePickerDialog extends StatefulWidget {
//   final Function(DateTime)? onDateSelected;
//
//   DatePickerDialog({required this.onDateSelected});
//
//   @override
//   _DatePickerDialogState createState() => _DatePickerDialogState();
// }
//
// class _DatePickerDialogState extends State<DatePickerDialog> {
//   DateTime? selectedDate;
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Select a Date'),
//       content: SizedBox(
//         width: double.maxFinite, // Expand to the maximum available width
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               SizedBox(
//                 height: 200.0,
//                 child: CalendarDatePicker(
//                   initialDate: selectedDate ?? DateTime.now(),
//                   firstDate: DateTime(2000),
//                   lastDate: DateTime(2101),
//                   onDateChanged: (date) {
//                     setState(() {
//                       selectedDate = date;
//                     });
//                   },
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   if (widget.onDateSelected != null && selectedDate != null) {
//                     widget.onDateSelected!(selectedDate!);
//                   }
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('Select'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }