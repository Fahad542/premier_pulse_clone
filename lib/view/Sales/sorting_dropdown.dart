import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class SortingDropdown extends StatelessWidget {
  final List<String> sortOptions;
  final String selectedOption;
  final ValueChanged<String> onOptionChanged;

  SortingDropdown({
    required this.sortOptions,
    required this.selectedOption,
    required this.onOptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSortingOptions(context);
      },
      child: Row(
        children: [
          Text(
            'Sort: $selectedOption',
            style: TextStyle(color: Colors.white),
          ),
          Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    );
  }

  void showSortingOptions(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(0, button.size.height), ancestor: overlay),
        button.localToGlobal(button.size.bottomLeft(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    await showMenu(
      context: context,
      position: position,
      items: sortOptions.map((String option) {
        return PopupMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        onOptionChanged(value);
      }
    });
  }
}

