import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvvm/res/components/round_button.dart';
import 'package:mvvm/utils/routes/routes_name.dart';
import 'package:mvvm/utils/utils.dart';
import 'package:mvvm/view/Company_analysis/Divisions/division_view.dart';
import 'package:mvvm/view/Home/home_screen.dart';
import 'package:mvvm/view/login_view.dart';
import '../view/Home/conformation_popup.dart';
import '../view/Sales/Sales_viewmodel.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}
final salesViewModel = SalesHeirarchyViewModel();

class _CustomDrawerState extends State<CustomDrawer> {
  final List<Widget> itemPages = [
    HomeScreen(), // For 'Home'
    // For 'Attendance'
    // For 'CMS'
  ];

  Map<String, bool> tileExpansionState = {};

  @override
  Widget build(BuildContext context) {
    final TextStyle whiteTextStyle = TextStyle(
        color: Colors.green[800], fontSize: 15, );

    return
      ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(40.0), // Adjust the radius as needed
        bottomRight: Radius.circular(40.0), // Adjust the radius as needed
      ),
      child:
      Drawer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white
          ),
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //crossAxisAlignment: CrossAxisAlignment.,
              children: [
                Container(
                  color: Colors.green[800],
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(""),
                          Container(
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), // Half of the avatar's height/width
                    boxShadow: [
                BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),


            ),],),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Image.asset('assets/person.jpg'))
                            ),
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: (){
                                  showLogoutConfirmationDialog(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: Colors.red,
                                    borderRadius: BorderRadius.circular(24),
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: Icon(Icons.logout, color: Colors.white,)),
                              ),
                              SizedBox(height: 4,),
                              Text("Logout", style: TextStyle(color: Colors.white, fontSize: 9),)
                            ],

                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      Row(
                        children: [
                          Text(
                            empcode.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ("(${(empcode.auth)})"),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Text(
                       empcode.designation,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      // Divider(
                      //   color: Colors.white,
                      //   thickness: 1.5,
                      // ),
                    ],
                  ),
                ),


Container(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,

    children: [
    //             AnimatedCustomExpansionTile(
    //
    //               title: 'Home',
    //
    //               children: <Widget>[
    //                 ListTile(
    //                   title: Text(
    //                     'Dashboard',
    //                     style: whiteTextStyle.copyWith(fontSize: 12),
    //                   ),
    //                   leading: Icon(
    //                     Icons.dashboard,
    //                     color: Colors.green[800],
    //                   ),
    //
    //                   onTap: () async {
    //               await salesViewModel.initializeDatabase();
    //              final isTableEmpty = await salesViewModel.isDatabaseTableEmpty();
    // if (isTableEmpty) {
    //                     Navigator.pushNamed(context, RoutesName.home);
    // }
    // else{
    //   Navigator.pushNamed(context, RoutesName.attandece);
    //   Utils.flushBarErrorMessage("Please Mark your attendance", context);
    //
    // }
    //                   },
    //                 ),
    //               ],
    //             ),
                AnimatedCustomExpansionTile(

                  title: 'Attendance',
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Mark Attendance',
                        style: whiteTextStyle.copyWith(fontSize: 12),
                      ),
                      leading: Icon(
                        Icons.calendar_today,
                        color: Colors.green[800],
                      ),
                      onTap: () async {
                        Navigator.pushNamed(context, RoutesName.attandece);
                        }
                    ),
                  ],
                ),

                AnimatedCustomExpansionTile(
                  title: 'Executive Sale',
                  children: <Widget>[

                    ListTile(
                      title: Text(
                        'Team Analysis',
                        style: whiteTextStyle.copyWith(fontSize: 12),
                      ),
                      leading: Icon(
                        Icons.group,
                        color: Colors.green[800],
                      ),

    onTap: () async {
    await salesViewModel.initializeDatabase();
    final isTableEmpty = await salesViewModel.isDatabaseTableEmpty();
    if (!isTableEmpty) {
                        Navigator.pushNamed(
                            context, RoutesName.sales);}
    else{
      Navigator.pushNamed(context, RoutesName.attandece);
      Utils.flushBarErrorMessage("Please Mark your attendance", context);

    }
                      },
                    ),
          ListTile(
              title: Text(
                'Company Analysis',
                style: whiteTextStyle.copyWith(fontSize: 12),
              ),
              leading: Icon(
                Icons.business,
                color: Colors.green[800],
              ),

              onTap: () async {
        await salesViewModel.initializeDatabase();
        final isTableEmpty = await salesViewModel.isDatabaseTableEmpty();
        if (!isTableEmpty) {
        Navigator.pushNamed(
        context, RoutesName.company_analysis
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => division()),
        );
        }
        else{
        Navigator.pushNamed(context, RoutesName.attandece);
        Utils.flushBarErrorMessage("Please Mark your attendance", context);

        }
        },
        )


                  ],
                ),

      ],
            ),
          ),


              ]),
      ),
    ),

      )

    );

  }
}

class AnimatedCustomExpansionTile extends StatefulWidget {
  final String title;
  final List<Widget> children;

  AnimatedCustomExpansionTile({required this.title, required this.children});

  @override
  _AnimatedCustomExpansionTileState createState() =>
      _AnimatedCustomExpansionTileState();
}

class _AnimatedCustomExpansionTileState
    extends State<AnimatedCustomExpansionTile>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          title: Text(
            widget.title,
            style: TextStyle(
              color: Colors.green[800],
              fontWeight: FontWeight.bold,
              fontSize: 15
            ),
          ),
          trailing: AnimatedCrossFade(
            firstChild: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.green[800],
            ),
            secondChild: Icon(
              Icons.keyboard_arrow_up,
              color: Colors.green[800],
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 300),
          ),
        ),
        AnimatedSize(
          vsync: this,
          duration: Duration(milliseconds: 300),
          child: Container(
            height: isExpanded ? null : 0,
            child: Column(
              children: widget.children,
            ),
          ),
        ),

      ],

    );
  }
}
