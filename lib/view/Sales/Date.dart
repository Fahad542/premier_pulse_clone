import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../res/color.dart';

class DateContainer extends StatefulWidget {
  final String title;
  final String range;
  final Function(DateTime) onDateSelected;
  DateTime? selectedDate;
  bool isVisible;

  DateContainer({
    Key? key,
    required this.title,
    required this.range,
    required this.isVisible,
    required this.onDateSelected,
     this.selectedDate,
  }) : super(key: key);

  @override
  _DateContainerState createState() => _DateContainerState();
}

class _DateContainerState extends State<DateContainer> {
  //DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible,
      child: GestureDetector(
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: widget.selectedDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  primaryColor: AppColors.greencolor, // Set your desired color here
                  accentColor: Colors.green,
                  colorScheme: ColorScheme.light(primary: AppColors.greencolor ?? Colors.green),
                  buttonTheme: ButtonThemeData(
                      textTheme: ButtonTextTheme.primary),
                ),
                child: child!,
              );
            },
          );

          if (picked != null && picked != widget.selectedDate) {
            setState(() {
              widget.selectedDate = picked;
              widget.onDateSelected?.call(picked);
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 60,
            width: 150,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:AppColors.greencolor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.selectedDate != null
                        ? DateFormat('yyyy-MM-dd').format(widget.selectedDate!)
                        : widget.range,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}