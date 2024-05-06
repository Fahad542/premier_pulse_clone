import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvvm/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'circle_avatar_index.dart';

class ProductItem extends StatefulWidget {

  final Map<String, dynamic> item;
  final List<String> selectedmeasures;
  final int index;
  final String name;
  bool? check;
  bool? checkdsf;
  double? lat;
  double? long;
  String? phone;
  String? code;
  VoidCallback? onTap;
  bool? empcheck;


  ProductItem({required this.item, this.empcheck,required this.selectedmeasures , required this.index, required this.name, this.code, this.lat, this.long, this.phone, this.check, this.checkdsf, this.onTap});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  final NumberFormat formatter = NumberFormat('#,###');

  //final String Execution ;
  String? unique_cus;

  @override
  Widget build(BuildContext context) {
    return
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Circle_avater(index: widget.index + 1),
            SizedBox(width: 5),
            Expanded(
              flex: 7,
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: "${widget.item["${widget.name}"]}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.empcheck==true)
                    TextSpan(
                      text: " (${widget.item["${widget.code}"]})",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Text(
              formatter
                  .format(double.parse(widget.item['Sales_Inc_ST']?.toString()?.replaceAll(',', '') ?? '0')),
              style: TextStyle(
                color: Colors.red,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (widget.selectedmeasures.isNotEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(widget.selectedmeasures.length, (index) {
              var selectedMeasureKey = widget.selectedmeasures[index].toString().replaceAll(' ', '_');
              var itemValue = widget.item[selectedMeasureKey];
              var formattedValue = itemValue is num ? formatter.format(itemValue).toString() : '0';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.selectedmeasures[index] != null ? "${widget.selectedmeasures[index].toString()}: " : '',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: widget.selectedmeasures[index] != null && itemValue != null
                              ? (itemValue is String && itemValue.endsWith('%') ? itemValue : formattedValue)
                              : '0',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 3),

                ],
              );
            }),
          ),
        SizedBox(height: 20,),
        Visibility(
          visible: widget.check==true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [


              Visibility(
                visible: widget.phone!="", // Icon sirf tab dikhao agar phone number khali nahi hai
                child: InkWell(
                  onTap: () {
                    launch('tel:${widget.phone.toString().replaceFirst('92', '0')}');
                  },
                  child: Icon(Icons.phone, color: Colors.black),
                ),
              ),

              Visibility(
                  visible: widget.phone!="",
                  child: SizedBox(width: 8,)),

              Visibility(
                visible: !widget.phone.toString().startsWith('(021)') && widget.phone.toString().length == 12,
                child: InkWell(
                  onTap: () {
                    launch('https://wa.me/${widget.phone}');
                  },
                  child: Image.asset('assets/whatsapp.png', height: 20, width: 20,),
                ),
              ),



              Visibility(
                  visible: widget.phone!="",
                  child: SizedBox(width: 8,)),
              //Text(customerData.phone.toString()),
              InkWell(
                onTap: () {
                  launch('https://www.google.com/maps/search/?api=1&query=${widget.lat},${widget.long}');
                },
                child: Icon(Icons.location_on, color: Colors.red),
              ),

            ],),
        ),
        if(widget.item['EmpDesignation']=="DSF")
        Visibility(
          visible: widget.checkdsf == true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               InkWell(
                 onTap:
                    widget.onTap,


                 child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.green[800],
                      borderRadius: BorderRadius.circular(10.0), // Add border radius here
                    ),
                    child: Text(
                      "DSF KPI",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
               ),

            ],
          ),
        ),


        Divider(color: Colors.green[800]),
      ],
    );
  }
}
