import 'package:flutter/material.dart';

enum SortOptions {
  Select,
  byAscendingName,
  byDecendingName,
  byMaximumSale,
  byMinimumSale,
}

class SortDialog {
  static void showSortDialog(BuildContext context, Function(SortOptions) onSortSelected) {
    SortOptions selectedSortOption = SortOptions.Select;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.green[800],
          title: Text(
            'Sort Options',
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.green[800],
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: DropdownButton<SortOptions>(
              value: selectedSortOption,
              onChanged: (SortOptions? newValue) {
                if (newValue != null) {
                  onSortSelected(newValue);
                  Navigator.of(context).pop();
                }
              },
              items: [
                buildDropdownItem(
                  SortOptions.Select,
                  'Select Sort',
                ),
                buildDropdownItem(
                  SortOptions.byAscendingName,
                  'Sort by Name in Ascending order',
                ),
                buildDropdownItem(
                  SortOptions.byDecendingName,
                  'Sort by Name in Descending order',
                ),
                buildDropdownItem(
                  SortOptions.byMaximumSale,
                  'Sort by Maximum to Minimum Sale',
                ),
                buildDropdownItem(
                  SortOptions.byMinimumSale,
                  'Sort by Minimum to Maximum Sale',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static DropdownMenuItem<SortOptions> buildDropdownItem(SortOptions value, String text) {
    return DropdownMenuItem<SortOptions>(
      value: value,
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
