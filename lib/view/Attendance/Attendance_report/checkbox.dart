import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../res/color.dart';

class MyCheckbox extends StatefulWidget {
  final bool isChecked;
  final ValueChanged<bool>? onChanged;

  MyCheckbox({
    this.isChecked = false,
    this.onChanged,
  });

  @override
  _MyCheckboxState createState() => _MyCheckboxState();
}

class _MyCheckboxState extends State<MyCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final newValue = !widget.isChecked;
        if (widget.onChanged != null) {
          widget.onChanged!(newValue);
        }
      },
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.isChecked ? AppColors.greencolor : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(4),
          color: widget.isChecked ? AppColors.greencolor : Colors.transparent,
        ),
        child: widget.isChecked
            ? Icon(
          Icons.check,
          size: 16,
          color: Colors.white,
        )
            : null,
      ),
    );
  }
}
