import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvvm/model/division_type_model.dart';
import 'package:mvvm/respository/division_type_repository.dart';
import 'package:mvvm/view/Company_analysis/compnay_analysis_view.dart';
import '../../../res/components/round_button.dart';
import '../../../respository/measure_repository.dart';
import '../../../utils/Drawer.dart';
import '../../../utils/utils.dart';
import '../../Sales/Date.dart';

class division extends StatefulWidget {
  const division({Key? key}) : super(key: key);

  @override
  State<division> createState() => _DivisionState();
}


class _DivisionState extends State<division> {
  List<division_type_model> team = [];
  bool isLoading=false;
  num totalcompany=0;
  bool showDateContainers=false;
  bool company=false;
  DateTime? startDate= DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime? endDate= DateTime.now();
  final formatter = NumberFormat('#,###');
  String formattedTotals='';
  Future<void> executeApiCall(String start, String end) async {
    setState(() {
      isLoading = true;

    });

    try {
      String startDateFormatted = DateFormat('yyyy,MM,dd').format(startDate!);
      String endDateFormatted = DateFormat('yyyy,MM,dd').format(endDate!);
      final result = await division_type_Repository().team_company_fetchData(startDateFormatted,endDateFormatted);

      // Process the result as needed
      print('API Result: $result');

      setState(() {
        team = result;
       // showDateContainers=true;
       // company=true;
        totalcompany = 0; // Reset total company sales
        for (int i = 0; i < team.length; i++) {
          totalcompany += team[i].sales;
        }
        formattedTotals = formatter.format(totalcompany); // Update formattedTotals here




      });
    } catch (e) {
      // Handle errors
      setState(() {
        isLoading = false;
        showDateContainers=true;
        company=true;
      });
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    final repository = measure_repository();
    repository.fetchDataAndSave();
    executeApiCall("", "");
  }


  final List<Map<String, dynamic>> divisions = [
    {"name": "All", "sales": "\$1000", "image": "assets/p-solid.png", "color": Colors.blueAccent},
    {"name": "Pharma", "sales": "\$500", "image": "assets/c-solid.png", "color": Color(0xFF2FC89A)},
    {"name": "Consumer", "sales": "\$800", "image": "assets/f-solid.png", "color": Color(0xFFFAB718)},
    {"name": "FMCG", "sales": "\$1200", "image": "assets/p-solid.png", "color": Color(0xFFFD5E60)},
    {"name": "PCP", "sales": "\$700", "image": "assets/cart-shopping-solid.png", "color": Color(0xFF32AFFF)},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          title: const Text('Company Analysis'),
          backgroundColor: Colors.green[800],
          leading: Builder(
            builder: (BuildContext context) {
              return Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Center(
                  child: IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              );
            },

          ),
          actions: [
            Visibility(

              child: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () {
                  setState(() {
                    company=!company;
                    showDateContainers = !showDateContainers;
                  }
                  );
                },
              ),
            ),
          ],
        ),
        drawer: CustomDrawer(),
        body:  isLoading ? Padding(
          padding: const EdgeInsets.all(8.0),

          child: Center(child: CircularProgressIndicator(color: Colors.green[800],)),
        ) :
        WillPopScope(

          onWillPop: () async {
            return false;
          },
          child: InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => company_analysis(name: "Company", startdate: startDate, enddate: endDate,

                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child:
                              Visibility(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Flexible(
                                      child: DateContainer(
                                        title: "Start Date",
                                        range: "yyyy-MM-dd",
                                        selectedDate: startDate,
                                        isVisible: !showDateContainers  ,
                                        onDateSelected: (date) {
                                          setState(() {
                                            startDate= date;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.02,
                                    ), // Adjust the percentage as needed
                                    Flexible(
                                      child: DateContainer(
                                        title: "End Date",
                                        range: "yyyy-MM-dd",
                                        selectedDate: endDate,
                                        isVisible: !showDateContainers  ,
                                        onDateSelected: (date) async {
                                          setState(() {
                                            endDate = date;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),



                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFF008000), // Dark Green
                                      Color(0xFF32CD32), // Green 600
                                    ],

                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 3,
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/total_sales.png", height: 30, width: 30,color: Colors.white,),

                                        SizedBox(height: 20), // Add space at the top
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10,right: 10),
                                          child: Text(
                                            "PSPL",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 10, right: 10),
                                                child: Text(
                                                  "Total Sales: $formattedTotals",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                ),
                                ),
                            ),




                            SizedBox(height: 20,),
                            Column(
                              children: team.map((item) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => company_analysis(
                                          name: item.Product_Class_Name.toString(),
                                          startdate: startDate,
                                          enddate: endDate,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Reusable(
                                    containerColor: divisions[team.indexOf(item)]["color"]!,
                                    imagePath: divisions[team.indexOf(item)]["image"]!,
                                    labelText: item.Product_Class_Name,
                                    labelColor: Colors.black,
                                    valueText: item.sales.toString(),
                                    valueColor: Colors.black,
                                    text: NumberFormat('#,###').format(double.tryParse(item.sales.toString().replaceAll(',', '')) ?? 0),
                                  ),
                                );
                              }).toList(),
                            ),




                            Visibility(
                                visible: !showDateContainers && !company ,
                                child: RoundButton(title: "Done", onPress: (){
                                  if (startDate!.isBefore(endDate!))
    {
      String startDateFormatted = DateFormat('yyyy,MM,dd').format(startDate!);
      String endDateFormatted = DateFormat('yyyy,MM,dd').format(endDate!);
      executeApiCall(startDateFormatted,endDateFormatted);



    }else{
                                    Utils.flushBarErrorMessage(
                                        'Start date should be less than to end date',
                                        context);


                                  }
                                }))
                          ] ),
            ),

              ),
          ),
        ),
        );
  }}



class Reusable extends StatefulWidget {
  final Color containerColor;
  final String imagePath;
  final String labelText;
  final Color labelColor;
  final String valueText;
  final Color valueColor;
  final String text;

  const Reusable({
    Key? key,
    required this.containerColor,
    required this.imagePath,
    required this.labelText,
    required this.labelColor,
    required this.valueText,
    required this.valueColor,
    required this.text,
  }) : super(key: key);

  @override
  State<Reusable> createState() => _ReusableState();
}

class _ReusableState extends State<Reusable> {
  Color getShadowColor(Color containerColor) {
    // Calculate the shadow color based on the container color
    // You can customize this logic as per your design requirements
    return containerColor.withOpacity(0.5);
  }

  @override
  Widget build(BuildContext context) {
    return
      Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                height: 50,
                width: 60,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: widget.containerColor == Colors.white ? Colors.grey[200] : widget.containerColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Image.asset(
                        widget.imagePath,
                        fit: BoxFit.contain,
                        height: 30, // Adjust the height of the image
                        width: 30,  // Adjust the width of the image
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 15),

              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                        text: widget.labelText,
                        style: TextStyle(
                          color: widget.labelColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                        widget.text, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.green[800])
                    ),
                  ),

                ],
              ),


            ],
          ),
          Divider()
        ],
      ),
    );
  }
}

