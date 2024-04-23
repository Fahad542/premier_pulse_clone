import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../model/measures.dart';
import '../../res/components/round_button.dart';
import '../../respository/measure_repository.dart';
class filters extends StatefulWidget {
  final Function(List<String>) onSelectionDone;
   List<String> selectedvalues;

  filters({required this.onSelectionDone, this.selectedvalues = const []});

  @override
  _FiltersTreeState createState() => _FiltersTreeState();
}


class _FiltersTreeState extends State<filters> {
  final repository = measure_repository();
  List<String> groupNames = [];
  List<String> selectedValues = [];

  @override
  void initState() {
    setState(() {
     selectedValues= widget.selectedvalues;
    });
    super.initState();
    print("object");
    fetchGroupNames();
  }

  Future<void> fetchGroupNames() async {
    final List<Measure> measures =
    await repository.getAllMeasuresGroupByGroupName();
    setState(() {
      groupNames = measures.map((measure) => measure.measureGroupName).toList();
    });
  }

  void updateSelectedValues(String value, bool isChecked) {
    setState(() {
      if (isChecked) {
        selectedValues.add(value);
      } else {
        selectedValues.remove(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      title: Text('Select any 4 Measures',textAlign: TextAlign.center,style: TextStyle(color: Colors.green[800]),),
      content: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
         width: double.maxFinite,
          child: Column(
            children: [
              Container(
                height: 35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // horizontal scrolling
                  itemCount: widget.selectedvalues.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Chip(
                        //   label: Text(widget.selectedvalues[index]),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Container(
                    padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(

                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(children: [
                              Text(widget.selectedvalues[index], style: TextStyle(color: Colors.green[800],fontWeight: FontWeight.bold, fontSize: 11),),
                              SizedBox(width: 2,),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.selectedvalues.removeAt(index);

                                  });
                                },
                                child: Icon(Icons.cancel),
                              ),
                            ],),
                          ),
                        ),

                      ],
                    );
                  },
                ),
              ),





              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Count: ${selectedValues.length.toString()}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green[800]),),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedValues.clear();
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                      minimumSize: MaterialStateProperty.all<Size>(Size(40, 25)), // Adjust the Size as needed
                    ),
                    child: Text('Clear'),
                  ),

                ],
              ),

              Expanded(
                flex: 10,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: groupNames
                            .map(
                              (groupName) =>
                              FilterGroup(
                                groupName: groupName,
                                repository: repository,
                                onSelectionChanged: updateSelectedValues,
                              ),
                        )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              //Spacer(),
              SizedBox(height: 4,),
              InkWell(
                onTap: (){
                  if (selectedValues.length > 4) {
                    Fluttertoast.showToast(
                      msg: "You have reached the maximum number of selections.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  } else {
                    Navigator.of(context).pop();
                    widget.onSelectionDone(selectedValues);


                  }
                },

                child: Container(
                  height: 35,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Done", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
class FilterGroup extends StatefulWidget {
  final String groupName;
  final measure_repository repository;
  final Function(String, bool) onSelectionChanged;

  FilterGroup(
      {required this.groupName,
        required this.repository,
        required this.onSelectionChanged});

  @override
  _FilterGroupState createState() => _FilterGroupState();
}

class _FilterGroupState extends State<FilterGroup> {
  bool showChildren = false;
  List<String> displayFolders = [];
  List<String> displayNames = [];

  @override
  void initState() {
    super.initState();
    fetchDisplayFolders();
  }

  Future<void> fetchDisplayFolders() async {
    List<String> folders =
    await widget.repository.getDisplayFoldersByGroupName(widget.groupName);
    setState(() {
      displayFolders = folders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                showChildren = !showChildren;
              });
            },
            child: Row(
              children: [
                Icon(
                  showChildren ? Icons.remove : Icons.add,
                  color: showChildren ? Colors.black : Colors.green,
                ),

                SizedBox(width: 8),
                Text(widget.groupName),
              ],
            ),
          ),
          if (showChildren)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: displayFolders
                  .map(
                    (folder) => FolderItem(
                      group: widget.groupName,
                  folderName: folder,
                  repository: widget.repository,
                  onSelectionChanged: widget.onSelectionChanged,
                ),
              )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class FolderItem extends StatefulWidget {
  final String folderName;
  final String group;
  final measure_repository repository;
  final Function(String, bool) onSelectionChanged;

  FolderItem(
      {required this.folderName,
        required this.repository,
        required this.onSelectionChanged,
      required this.group
      });

  @override
  _FolderItemState createState() => _FolderItemState();
}

class _FolderItemState extends State<FolderItem> {
  bool showChildren2 = false;
  List<String> displayNames = [];
  List<bool> isCheckedList = [];

  @override
  void initState() {
    super.initState();
    fetchDisplayNames();
  }

  Future<void> fetchDisplayNames() async {
    List<String> names =
    await widget.repository.getDisplayFoldersByName(widget.folderName, widget.group);
    setState(() {
      displayNames = names;
      isCheckedList = List.filled(displayNames.length, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                showChildren2 = !showChildren2;
              });
            },
            child: Row(
              children: [
                Icon(
                  showChildren2 ? Icons.remove : Icons.add,
                  color: showChildren2 ? Colors.black : Colors.green,
                ),
                SizedBox(width: 16),
                Expanded(child: Text(widget.folderName)),
              ],
            ),
          ),
          if (showChildren2)
            Column(
              children: displayNames.asMap().entries.map((entry) {
                int index = entry.key;
                String name = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0), // Adjust the vertical spacing here
                  child: CheckboxListTile(
                    activeColor: Colors.green,
                    title: Text(name),
                    value: isCheckedList[index],
                    onChanged: (bool? value) {
                      setState(() {
                        isCheckedList[index] = value!;
                        widget.onSelectionChanged(name, value);
                      });
                    },
                  ),
                );
              }).toList(),
            ),


        ],
      ),
    );
  }


}

