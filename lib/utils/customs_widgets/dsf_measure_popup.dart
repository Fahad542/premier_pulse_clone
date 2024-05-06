

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/dsf_measure_model.dart';
import '../../respository/dsf_meansure_repository.dart';

class DSFMeasurePopup extends StatefulWidget {
  final String startDate;
  final String endDate;
  final String dsfCode;

  DSFMeasurePopup({
    required this.startDate,
    required this.endDate,
    required this.dsfCode,
  });

  @override
  _DSFMeasurePopupState createState() => _DSFMeasurePopupState();
}

class _DSFMeasurePopupState extends State<DSFMeasurePopup> {
  final dsfMeasureRepository = dsf_measure_Repository();
  late Future<List<DsfMeasureModel>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = fetchData();
  }

  Future<List<DsfMeasureModel>> fetchData() async {
    try {
      return await dsfMeasureRepository.fetchData(
        widget.startDate,
        widget.endDate,
        int.parse(widget.dsfCode),
      );
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), ),
        child: AlertDialog(
          title: Center( child: Text('DSF KPI', style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, ))), // Set the text color to white
          backgroundColor: Colors.white,

          // Set the background color to green[800]
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5, // Set the height to 40% of the screen height
            child: SingleChildScrollView(
              child: FutureBuilder<List<DsfMeasureModel>>(
                future: _futureData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)), // Center the CircularProgressIndicator
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white));
                  } else {
                    List<DsfMeasureModel> data = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          for (var item in data)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDataRow('Name', item.dsfDsfName),
                                Divider(),
                                SizedBox(height: 10),
                                _buildDataRow('SAF Customer', item.safCustomer.toString()),
                                Divider(),
                                SizedBox(height: 10),
                                _buildDataRow('Avg Sku Per Bill', item.avgSkuPerBill?.toStringAsFixed(2) ?? '0.00'),
                                Divider(),


                                SizedBox(height: 10),
                                _buildDataRow('DSF SAF BusinessLine', item.dsfSafBusinessLine),
                                Divider(),
                                SizedBox(height: 10),
                                _buildDataRow('Duration', item.duration.toString()),
                                Divider(),
                                SizedBox(height: 10),
                                _buildDataRow('Eco Percentage', item.ecoPercentage),
                                Divider(),
                                SizedBox(height: 10),
                                _buildDataRow('First Order', item.firstOrder != null ? DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(item.firstOrder!)) : 'N/A'),
                                SizedBox(height: 10),
                                Divider(),
                                _buildDataRow('Last Order', item.lastOrder != null ? DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(item.lastOrder!)) : 'N/A'),
                                Divider(),
                                SizedBox(height: 10),
                                _buildDataRow('Order Quantity', "${NumberFormat('#,##,###').format(item.orderQuantity)}"),
                                Divider(),
                                SizedBox(height: 10),
                                _buildDataRow('Order Value', NumberFormat.decimalPattern().format(item.orderValue)),
                                Divider(),
                                SizedBox(height: 10),
                                _buildDataRow('Productive Customer', item.productiveCustomer.toString()),
                                Divider(),
                                SizedBox(height: 10),
                                _buildDataRow('DSF Target Days Remaining', item.DSFTargetDaysDSFRemaining.toString()),
                                Divider(),
                                SizedBox(height: 10),
                                _buildDataRow('DSF Target Days Worked', item.DSFTargetDaysDSFWorked.toString()),
                              ],
                            ),
                          // Add more widgets as needed
                        ],
                      ),

                    );
                  }
                },
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close', style: TextStyle(color: Colors.green[800])),
            ),
          ],
        ),
      ),
    );
  }
}
Widget _buildDataRow(String heading, String value) {
  return Row(

    children: [
      Expanded(
          flex: 6,
          child: Text('$heading:', style: TextStyle(color: Colors.black,
              fontWeight: FontWeight.bold, fontSize: 13),)),

      Expanded(
          flex: 4,
          child: Text(value, style: TextStyle(color: Colors.green[800], fontSize: 13))),


    ],

  );
}
