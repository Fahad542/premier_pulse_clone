// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:mvvm/res/color.dart';
//
// import 'package:flutter/material.dart'; // Make sure to import the necessary package.
//
// import 'package:flutter/material.dart';
// import 'package:mvvm/respository/sales_repository.dart';
//
// import '../../../model/sales_model.dart';
// import '../../../respository/heirarchy repository.dart';
//
// class YourWidget extends StatefulWidget {
//   final Set<String> id;
//   final String? startdate;
//   final String? enddate;
//   final String name;
//
//   const YourWidget({
//     required this.id,
//     required this.startdate,
//     required this.enddate,
//     required this.name,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _YourWidgetState createState() => _YourWidgetState();
// }
//
// class _YourWidgetState extends State<YourWidget> {
//   late Future<List<SalesData>> salesDataFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     salesDataFuture = SalesRepository().fetchData(
//       widget.id,
//       widget.startdate ?? '', // Use null-aware operator
//       widget.enddate ?? '',
//       // Use null-aware operator
//     ) ;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       // Add any other widgets you need above the Expanded widget
//       FutureBuilder<List<SalesData>>(
//         future: salesDataFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Container(
//
//               child: LinearProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
//                 backgroundColor: Colors.green.shade100,
//               ),
//             );
//           } else if (snapshot.hasError) {
//             WidgetsBinding.instance!.addPostFrameCallback((_) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('Error: ${snapshot.error}'),
//                   backgroundColor: Colors.red, // Customize the color
//                 ),
//               );
//             });
//             return SizedBox.shrink();
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Text('No sales data available.');
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length - 1,
//               shrinkWrap: true,
//               itemBuilder: (context, index) {
//                 final salesData = snapshot.data![index];
//                 return Container(
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10)
//                   ),
//                   child: ListTile(
//                     title: Text(widget.name, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
//                     subtitle: Text(salesData.sales, style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500),),
//                     tileColor: Colors.green.shade100,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//
//                     ),
//                     contentPadding: EdgeInsets.all(8),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//
//         // Add any other widgets you need below the Expanded widget
//       );
//   }
// }
//
