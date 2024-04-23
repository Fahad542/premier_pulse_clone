// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'package:flutter/material.dart';
//
// import 'package:flutter/material.dart';
// import 'package:mvvm/res/color.dart';
// import 'package:pie_chart/pie_chart.dart';
//
// import '../../../utils/font.dart';
//
// class SalesPage extends StatefulWidget {
//   const SalesPage({Key? key}) : super(key: key);
//
//   @override
//   _SalesPageState createState() => _SalesPageState();
// }
//
// class _SalesPageState extends State<SalesPage> {
//   String? selectedCompany;
//
//   List<String> companies = [
//     'Company A',
//     'Company B',
//     'Company C',
//     // Add more company names here
//   ];
//   List<String> texts = ["Total Sales", "Total Invoices", "Pendeng Invoices", "Total Pendeng Invoices"];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Total Sales'),
//         backgroundColor: AppColors.greencolor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 20, right: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       // Implement logic for selecting start date here
//                     },
//                     style: ElevatedButton.styleFrom(
//                       primary: Colors.green, // Green background color
//                     ),
//                     child: Text(
//                       'Start Date',
//                       style: TextStyle(
//                           color: Colors.white), // White text color
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Implement logic for selecting end date here
//                     },
//                     style: ElevatedButton.styleFrom(
//                       primary: Colors.green, // Green background color
//                     ),
//                     child: Text(
//                       'End Date',
//                       style: TextStyle(
//                           color: Colors.white), // White text color
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16),
//             Container(
//               padding: EdgeInsets.only(left: 10),
//               decoration: BoxDecoration(
//                 color: AppColors.whiteColor,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5), // Shadow color
//                     spreadRadius: 3, // Spread radius
//                     blurRadius: 5, // Blur radius
//                     offset: Offset(0, 2), // Offset in the x and y directions
//                   ),
//                 ],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: DropdownButton<String>(
//                 hint: Text(
//                   'Select a Company',
//                   style: TextStyle(
//                     color: Colors.green, // Green text color
//                     fontSize: 16, // Adjust font size as needed
//                   ),
//                 ),
//                 value: selectedCompany,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     selectedCompany = newValue;
//                   });
//                 },
//                 items: companies.map((String company) {
//                   return DropdownMenuItem<String>(
//                     value: company,
//                     child: Text(
//                       company,
//                       style: TextStyle(
//                         color: Colors.green, // Green text color
//                         fontSize: 16, // Adjust font size as needed
//                       ),
//                     ),
//                   );
//                 }).toList(),
//                 style: TextStyle(
//                   color: Colors.green, // Green text color
//                   fontSize: 16, // Adjust font size as needed
//                 ),
//                 dropdownColor: Colors.white, // Dropdown background color
//                 icon: Icon(
//                   Icons.arrow_drop_down,
//                   color: Colors.green, // Dropdown icon color
//                 ),
//                 elevation: 2, // Shadow elevation
//                 underline: Container(
//                   // Remove the underline
//                   height: 0,
//                   color: Colors.transparent,
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             // Display a fixed number of containers for the selected company
//             selectedCompany != null
//                 ? Expanded(
//               child:
//
//             ListView.builder(
//             itemCount: texts.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     height: 100,
//                     width: 100,
//                     padding: EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       color: Colors.green
//                     ),
//                     child: Center(
//                       child: Text(
//                         texts[index], // Display different text for each container
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.whiteColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ))
//
//                 : Container(), // Placeholder or empty container
//           ],
//         ),
//       ),
//     );
//   }
// }
