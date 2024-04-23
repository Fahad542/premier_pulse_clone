
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvvm/model/get_bracnhes_model.dart';
import '../../model/get_channels_model.dart';
import '../../utils/customs_widgets/circle_avatar_index.dart';



class CompanyHeirarchyViewModel with ChangeNotifier {
//int total=0;

  void showCompanyDetailsDialog(BuildContext context,
      List<get_bracnhes_model> team, String companyid, String branch, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green[800],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
                child: Text('Branches', style: TextStyle(color: Colors.white))),
          ),
          content: Container(
            margin: EdgeInsets.only(top: 10),
            width: double.maxFinite,
            child: Column(
              children: [
                Center(child: Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800], fontSize: 15))),
                SizedBox(height: 10,),
                Expanded(
                  child: ListView.builder(
                    itemCount: team.length,
                    itemBuilder: (BuildContext context, int index) {

                      team.sort((a, b) => int.parse(b.Sales.replaceAll(',', '')) - int.parse(a.Sales.replaceAll(',', '')));

                      get_bracnhes_model item = team[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              children: [
                                Circle_avater(index: index + 1),
                                // Adjust the size as needed
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item.Branch ?? ''}',
                                      style: TextStyle(fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[800]),
                                    ),
                                    Text('Sale: ${item.Sales ?? ''}',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.green[800]),
                                    ),
                                    Text(
                                      'Booked: ${item.Booked}',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.green[800]),
                                    ),
                                    Text('Execution: ${item.Execution ?? ''}',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.green[800])),
                                  ],
                                ),
                              ],
                            ),
                            Divider(color: Colors.green[800]),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          // Adjust the horizontal padding as needed
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            // Adjust the border radius as needed
            side: BorderSide(width: 2,
                color: Colors.transparent), // Set the border width and color
          ),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.green,
              ),

              child: Text('Total Sales: ${branch.toString()}', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close',
                  style: TextStyle(fontSize: 16, color: Colors.green[800])),
            ),
          ],
        );
      },
    );
  }
void showchannelDetailsDialog(BuildContext context, List<get_channels_model> team, String companyid, String total, String name) {
  // Initialize totalSales variable to store the sum of sales

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green[800],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text('Channels', style: TextStyle(color: Colors.white)),
          ),
        ),
        content: Container(
          margin: EdgeInsets.only(top: 10),
          width: double.maxFinite,
          child: Column(
            children: [
              Center(child: Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800], fontSize: 13))),
              SizedBox(height: 10,),
              Expanded(
                child: ListView.builder(
                  itemCount: team.length,
                  itemBuilder: (BuildContext context, int index) {
                    team.sort((a, b) => int.parse(b.Sales.replaceAll(',', '')) - int.parse(a.Sales.replaceAll(',', '')));

                    get_channels_model item = team[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Circle_avater(index: index + 1),
                              SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${item.Class ?? ''}',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                  Text(
                                    'Sale: ${item.Sales ?? ''}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                  Text(
                                    'Booked: ${item.Booked}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                  Text(
                                    'Execution: ${item.Execution ?? ''}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(color: Colors.green[800]),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(width: 2, color: Colors.transparent),
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.green,
            ),
            child: Text('Total Sales: ${total.toString()}', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}


List<String> items = [
      "Category",
       "Sub Category",
       "Brand",
        "Product"

  ];
  String selectedCategory = '';

  void category(BuildContext context, Function(String) onSelectCategory) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ListView.builder(
                              itemCount: items.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {

                                      onSelectCategory(items[index]);

                                    items.removeRange(0, index + 1); // Remove items before and including the selected item
                                    Navigator.of(context).pop();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            items[index],
                                            style: TextStyle(
                                              color: Colors.green[800],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
                                            ),
                                          ),
                                        ),
                                        Divider(color: Colors.green[800])
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close',
                  style: TextStyle(fontSize: 16, color: Colors.green[800]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}