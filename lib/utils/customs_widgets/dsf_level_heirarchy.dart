import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'circle_avatar_index.dart';

class dsf extends StatefulWidget {
  final int index;
  final String sales;
  final String code;
  final String title;
  final VoidCallback onTapCallback;
  bool? check;
  //final String Execution ;
  String? unique_cus;
  double? lat;
  double? long;
  String? phone;

   dsf({
    Key? key,
    required this.index,
    required this.sales,
    required this.title,
     required this.code,
    required this.onTapCallback,
    this.check,
     this.long,
     this.lat,
     this.phone,
   // required this.Execution,
    this.unique_cus
  }) : super(key: key);

  @override
  State<dsf> createState() => _dsfState();
}

class _dsfState extends State<dsf> {
  @override

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
child: InkWell(
onTap: widget.onTapCallback,
  child:   Column(

    children: [
    Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Circle_avater(index: widget.index+1),
       SizedBox(width: 8,),

          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('(${widget.code})', style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold, fontSize: 12),), Text(
                  widget.title, style: TextStyle(color: Colors.green[800],  fontWeight: FontWeight.bold, ),),
                SizedBox(height: 5,),
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
              ],
            ),
          ),


    Expanded(flex: 2,child:Text(textAlign: TextAlign.right,widget.sales.isEmpty ? '  0':widget.sales,  style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold, fontSize: 16)),),
          //Expanded(flex: 2,child:Text(textAlign: TextAlign.right,widget.Execution.isEmpty ? '      0' : '  ${widget.Execution}',  style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,))),
          //Expanded(flex: 2,child:Text(widget.unique_cus ?? "",  style: TextStyle(color: Colors.red,fontWeight: FontWeight.w500)),),
        ],
      ),
    ),

      //Expanded(flex: 3,child:Text(widget.Execution,  style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,))),
    Divider( // Add a divider line
      color: Colors.green[800], // You can set the color to match your text color
    ),
  ],),
));





//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: InkWell(
//           onTap: widget.onTapCallback,
// //           child: Container(
// //             height: 50,
// //             padding: EdgeInsets.all(8),
// //             decoration: BoxDecoration(
// //               borderRadius: BorderRadius.circular(12),
// //               color: Colors.green.shade100,
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.green.shade300,
// //                   blurRadius: 1,
// //                   offset: Offset(0, 3),
// //                 ),
// //               ],
// //             ),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //
// //                   Circle_avater(index: widget.index+1),
// // SizedBox(width: 5,),
// //
// //               Expanded(
// //                 child: RichText(
// //                       text: TextSpan(
// //                         style: DefaultTextStyle.of(context).style,
// //                         children: [
// //
// //                           TextSpan(
// //                             text: widget.title,
// //                             style: TextStyle(
// //                               fontSize: 14.5,
// //                               fontWeight: FontWeight.w500,
// //                               color: Colors.black,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //               ),
// //
// //                 Container(
// //                   padding: EdgeInsets.all(8),
// //                   decoration: BoxDecoration(
// //                       gradient: LinearGradient(
// //                         begin: Alignment.topLeft,
// //                         end: Alignment.bottomRight,
// //                         colors: [
// //                           Colors.green[800]!,  // Darker shade of green
// //                           Colors.green[400]!,  // Lighter shade of green
// //                         ],
// //                       ),
// //                       borderRadius: BorderRadius.circular(10)),
// //                   child: RichText(
// //                     text: TextSpan(
// //                       children: [
// //                         TextSpan(
// //                           text: "Rs: ",
// //                           style: TextStyle(
// //                             fontSize: 14,
// //                             color: Colors.white,
// //                           ),
// //                         ),
// //                         TextSpan(
// //                           text: widget.sales.isNotEmpty
// //                               ? widget.sales
// //                               : '0',
// //                           style: TextStyle(
// //                             fontSize: 17,
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.white,
// //                           ),
// //                         ),
// //
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //
// //                 Container(
// //                   padding: EdgeInsets.all(8),
// //                   decoration: BoxDecoration(
// //                       gradient: LinearGradient(
// //                         begin: Alignment.topLeft,
// //                         end: Alignment.bottomRight,
// //                         colors: [
// //                           Colors.green[800]!,  // Darker shade of green
// //                           Colors.green[400]!,  // Lighter shade of green
// //                         ],
// //                       ),
// //                       borderRadius: BorderRadius.circular(10)),
// //                   child: RichText(
// //                     text: TextSpan(
// //                       children: [
// //
// //                         TextSpan(
// //                           text: widget.Execution,
// //
// //                           style: TextStyle(
// //                             fontSize: 17,
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.black,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
//
//   child: Row(
//     children: [],
//   ))));
  }
}


