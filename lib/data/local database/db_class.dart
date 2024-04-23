// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:http/http.dart' as http;
// import '../../model/heirarchy_model.dart';
// import '../../view/Attendance/Attendance_report/attendance_report_view.dart';
// class YourPage extends StatefulWidget {
//   @override
//   _YourPageState createState() => _YourPageState();
// }
//
// class _YourPageState extends State<YourPage> {
//   Future<void> fetchAndSaveData() async {
//     final Uri uri = Uri.parse(
//         "https://hris.premierspulse.com/pulse/teamList.php?empcode=99938");
//     final response = await http.get(uri);
//
//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       final userDetailsList = jsonResponse['response']['UserDetails']
//           .map<UserDetails>((data) => UserDetails(
//         empCode: data['emp_code'].toString(),
//         empName: data['emp_name'],
//         reportingTo: data['reporting_to'].toString(),
//         level: data['level'].toString(),
//         isCheck: data['is_check'] == 'False'
//             ? false
//             : true, // Convert to boolean
//       ))
//           .toList();
//
//       await DatabaseHelper.instance.insertUserDetails(userDetailsList);
//       _loadUserDetails(); // Reload data after inserting
//     } else {
//       throw Exception('Failed to load data from API');
//     }
//   }
//
//   List<UserDetails> userDetailsList = [];
//
//   void _loadUserDetails() async {
//     final data = await DatabaseHelper.instance.getUserDetails();
//     setState(() {
//       userDetailsList = data;
//     });
//   }
//
//   void _printUserDetails() async {
//     final data = await DatabaseHelper.instance.getUserDetails();
//     for (var userDetails in data) {
//       print('Emp Code: ${userDetails.empCode}');
//       print('Emp Name: ${userDetails.empName}');
//       print('Reporting To: ${userDetails.reportingTo}');
//       print('Level: ${userDetails.level}');
//       print('Is Check: ${userDetails.isCheck}');
//       print(''); // Add an empty line for separation
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Your Page'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 await fetchAndSaveData();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => AttendanceReport()),
//                 );
//
//                 _printUserDetails(); // Print user details
//                 // Navigator.push(
//                 //   context,
//                 //   MaterialPageRoute(builder: (context) => AttendanceReport()),
//                 // );
//               },
//               child: Text('View Attendance Report'),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: userDetailsList.length,
//                 itemBuilder: (context, index) {
//                   final userDetails = userDetailsList[index];
//                   return ListTile(
//                     title: Text(userDetails.empName),
//                     subtitle: Text('Emp Code: ${userDetails.empCode}'),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
//   static Database? _database;
//
//   DatabaseHelper._privateConstructor();
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }
//
//   Future<Database> _initDatabase() async {
//     final String path = join(await getDatabasesPath(), 'your_database.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _createDatabase,
//     );
//   }
//
//   Future<void> _createDatabase(Database db, int version) async {
//     await db.execute('''
//     CREATE TABLE user_details (
//       emp_code TEXT PRIMARY KEY,
//       emp_name TEXT,
//       reporting_to TEXT,
//       level TEXT,
//       is_check INTEGER DEFAULT 0
//     )
//   ''');
//   }
//
//   Future<void> insertUserDetails(List<UserDetails> userDetailsList) async {
//     final Database db = await database;
//     final Batch batch = db.batch();
//
//     for (var userDetails in userDetailsList) {
//       batch.insert(
//         'user_details',
//         userDetails.toMap(),
//         conflictAlgorithm: ConflictAlgorithm.replace,
//       );
//     }
//
//     await batch.commit();
//   }
//
//   Future<List<UserDetails>> getUserDetails() async {
//     final Database db = await database;
//     final List<Map<String, dynamic>> maps = await db.query('user_details');
//
//     return List.generate(maps.length, (i) {
//       return UserDetails(
//         empCode: maps[i]['emp_code'],
//         empName: maps[i]['emp_name'],
//         reportingTo: maps[i]['reporting_to'],
//         level: maps[i]['level'],
//         isCheck: maps[i]['is_check'] == 0,
//       );
//     });
//   }
// }
//
//
