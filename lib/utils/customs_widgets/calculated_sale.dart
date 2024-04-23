import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvvm/res/color.dart';

class calculated_sale extends StatefulWidget {
  final String totalsale;

  const calculated_sale({Key? key, required this.totalsale}) : super(key: key);

  @override
  State<calculated_sale> createState() => _CalculatedSaleState();
}

class _CalculatedSaleState extends State<calculated_sale> {
  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.greencolor, // Darker shade of green
             AppColors.greencolor// Lighter shade of green
            ],
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              offset: Offset(0, 3),
              color: Colors.green[800]??Colors.white
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Total Sales: ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),


            Text(
              widget.totalsale != null ? widget.totalsale! : '0',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

          ],
        ),
      ),
    );
  }
}




class calculated_saleint extends StatefulWidget {
  final int totalsale;

  const calculated_saleint({Key? key, required this.totalsale}) : super(key: key);

  @override
  State<calculated_saleint> createState() => _CalculatedSaleintState();
}

class _CalculatedSaleintState extends State<calculated_saleint> {
  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.greencolor,  // Darker shade of green
              AppColors.greencolor,  // Lighter shade of green
            ],
          ),
          boxShadow: [
            BoxShadow(
                blurRadius: 1,
                offset: Offset(0, 3),
                color: AppColors.greencolor??Colors.white
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Total Sales: ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),


            Text(
              widget.totalsale.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
