
// class AttendanceReport extends StatefulWidget {
//   @override
//   State<AttendanceReport> createState() => _AttendanceReportState();
// }
//
// class _AttendanceReportState extends State<AttendanceReport> {
//   final List<Map<String, dynamic>> items = [
//     {'id': "1", "code": "0", "title": "Kashif bhai", "ischeck": "False"},
//     {'id': "2", "code": "1", "title": "Shakir Bhai", "ischeck": "False"},
//     {'id': "3", "code": "2", "title": "Imran Bhai", "ischeck": "False"},
//     {'id': "4", "code": "1", "title": "Faisal Bhai", "ischeck": "False"},
//     {'id': "5", "code": "2", "title": "Tariq Bhai", "ischeck": "False"},
//     {'id': "6", "code": "3", "title": "Noman", "ischeck": "False"},
//     {'id': "7", "code": "3", "title": "Hasham", "ischeck": "False"},
//     {'id': "8", "code": "7", "title": "Ahmed", "ischeck": "False"},
//     {'id': "9", "code": "7", "title": "hassan", "ischeck": "False"},
//     {'id': "10", "code": "9", "title": "Fahad", "ischeck": "False"},
//     {'id': "11", "code": "1", "title": "Zaid", "ischeck": "False"},
//     {'id': "12", "code": "2", "title": "Khan", "ischeck": "False"},
//     {'id': "13", "code": "2", "title": "Umar", "ischeck": "False"},
//     {'id': "14", "code": "4", "title": "Uzair", "ischeck": "False"},
//     {'id': "15", "code": "3", "title": "Zohaib", "ischeck": "False"},
//     {'id': "16", "code": "1", "title": "Zaid", "ischeck": "False"},
//     {'id': "17", "code": "1", "title": "Khan", "ischeck": "False"},
//     {'id': "18", "code": "1", "title": "Umar", "ischeck": "False"},
//     {'id': "19", "code": "1", "title": "Uzair", "ischeck": "False"},
//     {'id': "20", "code": "1", "title": "Zohaib", "ischeck": "False"},
//     {'id': "21", "code": "1", "title": "Ahmed", "ischeck": "False"},
//     {'id': "22", "code": "1", "title": "hassan", "ischeck": "False"},
//     {'id': "23", "code": "1", "title": "Fahad", "ischeck": "False"},
//     {'id': "24", "code": "1", "title": "Zaid", "ischeck": "False"},
//     {'id': "25", "code": "1", "title": "Khan", "ischeck": "False"},
//   ];
//
//   List<String> stackItems = [];
//   Map<String, bool> checkboxStates = {};
//   Set<String> selectedIds = {};
//   DateTime? startDate;
//   DateTime? endDate;
//   bool isFirstClick = true;
//   bool showsales=false;
//   bool showchildren=false;
//   void setChildrenCheckboxStatesToFalse(String parentId) {
//     for (final childItem in items.where((item) => item['code'] == parentId)) {
//       final String id = childItem['id'];
//       checkboxStates[id] = false;
//       final int index = items.indexOf(childItem);
//       setState(() {
//         checkboxStates[id] = false;
//       });
//       setChildrenCheckboxStatesToFalse(id);
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     for (final item in items) {
//       final String id = item['id'];
//       checkboxStates[id] = item['ischeck'] == "True";
//     }
//   }
//
//   bool isCheckboxSelected = false;
//   bool done = false;
//   bool showDateContainers = false;
//
//   void resetSelectedCheckboxes() {
//     for (final id in selectedIds) {
//       checkboxStates[id] = false;
//     }
//     selectedIds.clear();
//     setState(() {
//       done = false;
//     });
//   }
//
//   Widget buildHierarchyTree(String parentId) {
//     bool anyChildChecked = false;
//     final selectedItems = <Widget>[];
//     final children = items
//         .where((item) => item['code'] == parentId)
//         .map<Widget>((childItem) {
//       final String id = childItem['id'];
//       bool isChecked = checkboxStates[id] ?? false;
//       if (isChecked) {
//         anyChildChecked = true;
//         selectedItems.add(
//           Container(
//             height: 40,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               color: Colors.green.shade100,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.green,
//                   blurRadius: 1,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(childItem['title']),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }
//
//       return ListTile(
//         title: InkWell(
//           onTap: () {
//             setState(() {
//               if (!stackItems.contains(id)) {
//                 stackItems.add(id);
//               }
//               setChildrenCheckboxStatesToFalse(id);
//               bool anyCheckboxSelected = checkboxStates.containsValue(true);
//               isCheckboxSelected = anyCheckboxSelected;
//               setState(() {
//                 done = false;
//               });
//             });
//
//             resetSelectedCheckboxes();
//
//           },
//           child: Container(
//             height: 40,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               color: Colors.green.shade100,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.green.shade300,
//                   blurRadius: 5,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(childItem['title']),
//                 ),
//                 Spacer(),
//                 Padding(
//                   padding: const EdgeInsets.all(2.0),
//                   child: Checkbox(
//                     value: isChecked,
//                     onChanged: (value) {
//                       setState(() {
//                         checkboxStates[id] = value!;
//                         if (value!) {
//                           selectedIds.add(id);
//                         } else {
//                           selectedIds.remove(id);
//                         }
//
//                         bool atLeastOneChecked =
//                         checkboxStates.values.any((value) => value == true);
//
//                         bool allValuesUnchecked = checkboxStates.values
//                             .every((value) => value == false);
//
//                         done = atLeastOneChecked;
//
//                         if (allValuesUnchecked) {
//                           done = false;
//                         }
//
//                         isCheckboxSelected = checkboxStates.containsValue(true);
//                       });
//                     },
//                     activeColor: Colors.green,
//                     checkColor: Colors.white,
//                     hoverColor: Colors.yellow,
//                     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }).toList();
//
//     if (children.isEmpty) {
//       return Padding(
//         padding: const EdgeInsets.all(30),
//         child: Center(
//           child: Text(
//             "No Sub Level Employee Available",
//             style: TextStyle(color: Colors.green, fontSize: 20),
//           ),
//         ),
//       );
//     }
//     if (!anyChildChecked) {
//       done = false;
//     } if (showsales) {
//       // Return your "Sales Container" widget here
//       return salescontainer("Kashif Bhai", "Director","400000", showsales);
//       // Replace with the actual widget you want to display
//     }
//     return
//
//
//       Container(
//
//         child: Column(
//           children: children,
//         ),
//       );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Attendance Report'),
//         backgroundColor: Colors.green,
//       ),
//       body: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.green,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(3.0),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         stackItems.clear();
//                         for (final id in checkboxStates.keys) {
//                           checkboxStates[id] = false;
//                         }
//                         isCheckboxSelected = false;
//                         showsales=false;
//                         done = false;
//                       });
//                     },
//                     child: Text(
//                       'Root: ',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//
//                     ),
//                   ),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Padding(
//                         padding: const EdgeInsets.all(7.0),
//                         child: Row(
//                           children: stackItems
//                               .asMap()
//                               .map((index, stackItem) {
//                             final stackItemTitle = items.firstWhere(
//                                     (item) => item['id'] == stackItem)['title'];
//                             return MapEntry(
//                               index,
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 5),
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 10.0),
//                                   decoration: BoxDecoration(
//                                     color: index == stackItems.length - 1
//                                         ? Colors.green.shade100
//                                         : Colors.white,
//                                     border: Border.all(
//                                       color: index == stackItems.length - 1
//                                           ? Colors.green.shade100
//                                           : Colors.white,
//                                     ),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color:
//                                         index == stackItems.length - 1
//                                             ? Colors.black54
//                                             : Colors.green,
//                                         blurRadius: 5,
//                                         offset: Offset(0, 3),
//                                       ),
//                                     ],
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         for (int i = index + 1;
//                                         i < items.length;
//                                         i++) {
//                                           final idToRemove = items[i]['id'];
//                                           checkboxStates[idToRemove] =
//                                           false;
//                                         }
//                                         stackItems.removeRange(
//                                             index + 1, stackItems.length);
//                                         done = false;
//
//                                         showsales=false;
//                                         checkboxStates.removeWhere(
//                                                 (key, value) =>
//                                             items.firstWhere((item) =>
//                                             item['id'] ==
//                                                 key)['code'] == stackItem);
//                                       });
//                                     },
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(2.0),
//                                       child: Text(
//                                         stackItemTitle,
//                                         style: TextStyle(
//                                           color:
//                                           index == stackItems.length - 1
//                                               ? Colors.black
//                                               : Colors.black,
//                                         ),
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           })
//                               .values
//                               .toList(),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           //salescontainer("Kashif Bhai", "Director","400000", showsales),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Datecontainer(
//                   title: "Start Date",
//                   range: "yyyy-MM-dd",
//                   isVisible: showDateContainers,
//                   onDateSelected: (date) {
//                     setState(() {
//                       startDate = date;
//                     });
//                   },
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Datecontainer(
//                   title: "End Date",
//                   range: "yyyy-MM-dd",
//                   isVisible: showDateContainers,
//                   onDateSelected: (date) {
//                     setState(() {
//                       endDate = date;
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               physics: BouncingScrollPhysics(),
//               child: ListView(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 children: [
//                   buildHierarchyTree(
//                       stackItems.isEmpty ? "0" : stackItems.last),
//                 ],
//               ),
//             ),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Visibility(
//                 visible: done,
//                 child:RoundButton (
//                   title: "Done",
//                   onPress: () {
//
//                     setState(() {
//                       showDateContainers = true;
//                     });
//
//                     if (isFirstClick) {
//                       // Conditions for the first click
//                       // For example, check selectedIds here
//                       isFirstClick = false; // Set isFirstClick to false for subsequent clicks
//                     } else {
//                       // Conditions for subsequent clicks
//                       if (startDate != null && endDate != null) {
//                         if (startDate!.isBefore(endDate!)) {
//
//                           print('Start Date: $startDate');
//                           print('End Date: $endDate');
//                           print(selectedIds);
//                           Utils.snackBar("Data Fetch Succesfully", context);
//                           setState(() {
//                             resetSelectedCheckboxes();
//                             showDateContainers=false;
//                             done=false;
//                             showsales=true;
//                           });
//                         } else {
//                           Utils.flushBarErrorMessage('Start date should be less than the end date', context);
//                         }
//                       }
//                       else {
//
//                         Utils.flushBarErrorMessage(
//                             'Both start date and end date must be selected',
//                             context);
//
//                       }}
//                   },
//                 )
//
//
//             ),
//           ),
//         ],
//       ),
//     );}}
//
//
//
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
//   late DateTime selectedDate;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedDate = DateTime.now();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       title: Text('Select a Date'),
//       content: SizedBox(
//         width: double.maxFinite,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Container(
//               padding: EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.green,
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               child: Theme(
//                 data: ThemeData.light().copyWith(
//                   primaryColor: Colors.white,
//                   accentColor: Colors.white,
//                   primaryTextTheme: TextTheme(
//                     headline6: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 child: SizedBox(
//                   height: 200.0,
//                   child: CalendarDatePicker(
//                     initialDate: selectedDate,
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime.now(),
//                     onDateChanged: (date) {
//                       setState(() {
//                         selectedDate = date;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 if (widget.onDateSelected != null) {
//                   widget.onDateSelected!(selectedDate);
//                 }
//                 Navigator.of(context).pop();
//               },
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.green,
//               ),
//               child: Text(
//                 'Select',
//                 style: TextStyle(color: Colors.white),
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
// class Datecontainer extends StatefulWidget {
//   final String title;
//   final String range;
//   final Function(DateTime) onDateSelected;
//   bool isVisible;
//
//   Datecontainer({
//     Key? key,
//     required this.title,
//     required this.range,
//     required this.isVisible,
//     required this.onDateSelected
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
//       widget.onDateSelected?.call(date);
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
//               return DatePickerDialog(onDateSelected: _onDateSelected);
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
///2
// class AttendanceReport extends StatefulWidget {
//   @override
//   State<AttendanceReport> createState() => _AttendanceReportState();
// }
// final salesViewModel = SalesHeirarchyViewModel();
// class _AttendanceReportState extends State<AttendanceReport> {
//   // The empCode to initially show
//   bool showInitialHierarchy = true;
// //String parentid='99938';
//   @override
//   void initState() {
//     super.initState();
//     _loadUserDetails();
//     // Load data from the database
//   }
//
//   void _loadUserDetails() async {
//     await salesViewModel.initializeDatabase();
//     final data = await salesViewModel.getUserDetailsFromLocalDatabase();
//     setState(() {
//       userDetailsList = data;
//       for (final item in userDetailsList) {
//         final String id = item.empCode;
//         checkboxStates[id] = item.isCheck;
//       }
//     });
//   }
//
//   List<UserDetails> userDetailsList = [];
//
//   List<String> stackItems = [];
//   Map<String, bool> checkboxStates = {};
//   Set<String> selectedIds = {};
//   DateTime? startDate;
//   DateTime? endDate;
//   bool isFirstClick = true;
//   bool showsales = false;
//   bool showchildren = false;
//   void setChildrenCheckboxStatesToFalse(String parentId) {
//     for (final childItem
//     in userDetailsList.where((item) => item.reportingTo == parentId)) {
//       final String id = childItem.empCode;
//       checkboxStates[id] = false;
//       final int index = userDetailsList.indexOf(childItem);
//       setState(() {
//         checkboxStates[id] = false;
//       });
//       setChildrenCheckboxStatesToFalse(id);
//     }
//   }
//
//   bool isCheckboxSelected = false;
//   bool done = false;
//   bool showDateContainers = false;
//
//   void resetSelectedCheckboxes() {
//     for (final id in selectedIds) {
//       checkboxStates[id] = false;
//     }
//     selectedIds.clear();
//     setState(() {
//       done = false;
//     });
//   }
//
//   Widget buildHierarchyTree(String parentId) {
//     bool anyChildChecked = false;
//     final selectedItems = <Widget>[];
//     final children = userDetailsList
//         .where((item) => item.reportingTo == parentId)
//         .map<Widget>((childItem) {
//       final String id = childItem.empCode;
//       bool isChecked = checkboxStates[id] ?? false;
//       if (isChecked) {
//         anyChildChecked = true;
//         selectedItems.add(
//           Container(
//             height: 40,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               color: Colors.green.shade100,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.green,
//                   blurRadius: 1,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(childItem.empName),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }
//
//       return ListTile(
//         title: InkWell(
//           onTap: () {
//             setState(() {
//               if (!stackItems.contains(id)) {
//                 stackItems.add(id);
//               }
//               setChildrenCheckboxStatesToFalse(id);
//               bool anyCheckboxSelected = checkboxStates.containsValue(true);
//               isCheckboxSelected = anyCheckboxSelected;
//               setState(() {
//                 done = false;
//               });
//             });
//
//             resetSelectedCheckboxes();
//           },
//           child: Container(
//             height: 40,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               color: Colors.green.shade100,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.green.shade300,
//                   blurRadius: 5,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       Text(
//                         childItem.empName,
//                       ),
//                       Text(id)
//                     ],
//                   ),
//                 ),
//                 Spacer(),
//                 Padding(
//                   padding: const EdgeInsets.all(2.0),
//                   child: Checkbox(
//                     value: isChecked,
//                     onChanged: (value) {
//                       setState(() {
//                         checkboxStates[id] = value!;
//                         if (value!) {
//                           selectedIds.add(id);
//                         } else {
//                           selectedIds.remove(id);
//                         }
//
//                         bool atLeastOneChecked =
//                         checkboxStates.values.any((value) => value == true);
//
//                         bool allValuesUnchecked = checkboxStates.values
//                             .every((value) => value == false);
//
//                         done = atLeastOneChecked;
//
//                         if (allValuesUnchecked) {
//                           done = false;
//                         }
//
//                         isCheckboxSelected = checkboxStates.containsValue(true);
//                       });
//                     },
//                     activeColor: Colors.green,
//                     checkColor: Colors.white,
//                     hoverColor: Colors.yellow,
//                     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }).toList();
// /////
//
//     final childre = userDetailsList
//         .where((item) => item.reportingTo == parentId)
//         .map<Widget>((childItem) {
//       final String id = childItem.empCode;
//       selectedItems.add(
//
//       // Return your "Sales Container" widget here
//      salescontainer(childItem.empName,"400000", showsales));
//       // Replace with the actual widget you want to display
//
//
//
//       return ListTile(
//         title: InkWell(
//           onTap: () {
//             setState(() {
//               if (!stackItems.contains(id)) {
//                 stackItems.add(id);
//               }
//             });
//           },
//           child:  salescontainer(childItem.empName,"400000", showsales))
//
//       );
//     }).toList();
//
//     if (children.isEmpty) {
//       return Padding(
//         padding: const EdgeInsets.all(30),
//         child: Center(
//           child: Text(
//             "No Sub Level Employee Available",
//             style: TextStyle(color: Colors.green, fontSize: 20),
//           ),
//         ),
//       );
//     }
//     if (!anyChildChecked) {
//       done = false;
//     }
//
//     if (showsales) {
//       // Return your "Sales Container" widget here
//       return Container(
//         child: Column(
//           children: childre,
//         ),
//       );
//       // Replace with the actual widget you want to display
//     }
//     return Container(
//       child: Column(
//         children: children,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Attendance Report'),
//         backgroundColor: Colors.green,
//       ),
//       body:  (userDetailsList.isEmpty) // Check if userDetailsList is empty
//           ? Container(
//         color: Colors.white, // Set the container color to black
//         child: Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//               Text(
//               'Please mark your attendance!',
//               style: TextStyle(
//                 color: Colors.green,
//                 fontSize: 18,
//               ),
//             )
//        ]
//             ))): Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.green,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(3.0),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         stackItems.clear();
//                         for (final id in checkboxStates.keys) {
//                           checkboxStates[id] = false;
//                         }
//                         isCheckboxSelected = false;
//                         showsales = false;
//                         done = false;
//                       });
//                     },
//                     child: Text(
//                       'Root: ',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Padding(
//                         padding: const EdgeInsets.all(7.0),
//                         child: Row(
//                           children: stackItems
//                               .asMap()
//                               .map((index, stackItem) {
//                             final stackItemTitle = userDetailsList
//                                 .firstWhere(
//                                     (item) => item.empCode == stackItem)
//                                 .empName;
//                             return MapEntry(
//                               index,
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 5),
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 10.0),
//                                   decoration: BoxDecoration(
//                                     color: index == stackItems.length - 1
//                                         ? Colors.green.shade100
//                                         : Colors.white,
//                                     border: Border.all(
//                                       color: index == stackItems.length - 1
//                                           ? Colors.green.shade100
//                                           : Colors.white,
//                                     ),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color:
//                                         index == stackItems.length - 1
//                                             ? Colors.black54
//                                             : Colors.green,
//                                         blurRadius: 5,
//                                         offset: Offset(0, 3),
//                                       ),
//                                     ],
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         for (int i = index + 1;
//                                         i < userDetailsList.length;
//                                         i++) {
//                                           final idToRemove =
//                                               userDetailsList[i].empCode;
//                                           checkboxStates[idToRemove] =
//                                           false;
//                                         }
//                                         stackItems.removeRange(
//                                             index + 1, stackItems.length);
//                                         done = false;
//
//                                         showsales = false;
//                                         checkboxStates.removeWhere(
//                                                 (key, value) =>
//                                             userDetailsList
//                                                 .firstWhere((item) =>
//                                             item.empCode == key)
//                                                 .reportingTo ==
//                                                 stackItem);
//                                       });
//                                     },
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(2.0),
//                                       child: Text(
//                                         stackItemTitle,
//                                         style: TextStyle(
//                                           color:
//                                           index == stackItems.length - 1
//                                               ? Colors.black
//                                               : Colors.black,
//                                         ),
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           })
//                               .values
//                               .toList(),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           //salescontainer("Kashif Bhai", "Director","400000", showsales),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Datecontainer(
//                   title: "Start Date",
//                   range: "yyyy-MM-dd",
//                   isVisible: showDateContainers,
//                   onDateSelected: (date) {
//                     setState(() {
//                       startDate = date;
//                     });
//                   },
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 Datecontainer(
//                   title: "End Date",
//                   range: "yyyy-MM-dd",
//                   isVisible: showDateContainers,
//                   onDateSelected: (date) {
//                     setState(() {
//                       endDate = date;
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               physics: BouncingScrollPhysics(),
//               child: ListView(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 children: [
//                   // Only show the initial hierarchy if the flag is set
//
//                   buildHierarchyTree(
//                       stackItems.isEmpty ? "99938" : stackItems.last),
//                 ],
//               ),
//             ),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Visibility(
//                 visible: done,
//                 child: RoundButton(
//                   title: "Done",
//                   onPress: () {
//                     setState(() {
//                       showDateContainers = true;
//                     });
//
//                     if (isFirstClick) {
//                       // Conditions for the first click
//                       // For example, check selectedIds here
//                       isFirstClick =
//                       false; // Set isFirstClick to false for subsequent clicks
//                     } else {
//                       // Conditions for subsequent clicks
//                       if (startDate != null && endDate != null) {
//                         if (startDate!.isBefore(endDate!)) {
//                           print('Start Date: $startDate');
//                           print('End Date: $endDate');
//                           print(selectedIds);
//                           Utils.snackBar("Data Fetch Succesfully", context);
//                           setState(() {
//                             resetSelectedCheckboxes();
//                             showDateContainers = false;
//                             done = false;
//                             showsales = true;
//                           });
//                         } else {
//                           Utils.flushBarErrorMessage(
//                               'Start date should be less than the end date',
//                               context);
//                         }
//                       } else {
//                         Utils.flushBarErrorMessage(
//                             'Both start date and end date must be selected',
//                             context);
//                       }
//                     }
//                   },
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
// }
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
//   late DateTime selectedDate;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedDate = DateTime.now();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       title: Text('Select a Date'),
//       content: SizedBox(
//         width: double.maxFinite,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Container(
//               padding: EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.green,
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               child: Theme(
//                 data: ThemeData.light().copyWith(
//                   primaryColor: Colors.white,
//                   accentColor: Colors.black,
//                   primaryTextTheme: TextTheme(
//                     headline6: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 child: SizedBox(
//                   height: 200.0,
//                   child: CalendarDatePicker(
//                     initialDate: selectedDate,
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime.now(),
//                     onDateChanged: (date) {
//                       setState(() {
//                         selectedDate = date;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 if (widget.onDateSelected != null) {
//                   widget.onDateSelected!(selectedDate);
//                 }
//                 Navigator.of(context).pop();
//               },
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.green,
//               ),
//               child: Text(
//                 'Select',
//                 style: TextStyle(color: Colors.white),
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
// class Datecontainer extends StatefulWidget {
//   final String title;
//   final String range;
//   final Function(DateTime) onDateSelected;
//   bool isVisible;
//
//   Datecontainer({
//     Key? key,
//     required this.title,
//     required this.range,
//     required this.isVisible,
//     required this.onDateSelected
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
//       widget.onDateSelected?.call(date);
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
//               return DatePickerDialog(onDateSelected: _onDateSelected);
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