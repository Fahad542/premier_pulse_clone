

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvvm/res/color.dart';
import 'package:mvvm/utils/routes/routes_name.dart';
import 'package:provider/provider.dart';

import '../view_model/user_view_model.dart';
import 'Drawer.dart';


class GeneralAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function ontapmenu;
  final String title;
  final Widget? optionalWidget;
  final IconData? icon;
  final IconData? icons;

  GeneralAppBar({
    required this.ontapmenu,
    required this.title,
    this.optionalWidget,
    this.icon,
    this.icons,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: AppColors.greencolor,
      leading: IconButton(
        icon: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5), // Black color with 50% opacity
                spreadRadius: 1, // Spread radius
                blurRadius: 2, // Blur radius
                offset: Offset(0, 3), // Offset in x and y direction
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              // Call the onTap function to toggle the drawer
              ontapmenu?.call();
            },
            child: Icon(
              Icons.menu,
              size: 25,
              color: AppColors.greencolor,
            ),
          ),
        ),
        onPressed: () {
          ontapmenu(); // Open the drawer
        },
      ),
      actions: [


        IconButton(
          icon:

            Icon(
              icon ,
              color: Colors.white
            ),

          onPressed: () {
            // Perform logout action or other action based on the icon
          },
        ),
        IconButton(
          icon: Container(
            // ... (unchanged)
            child: Icon(
                icons ,
                color: Colors.white
            ),
          ),
          onPressed: () {
            // Perform logout action or other action based on the icon
          },
        ),
      ],
    );
  }
}


class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function ontapmenu;
  final String title;
  final Function onTapLogout; // Add a callback for logout

  MyAppBar({required this.ontapmenu, required this.title, required this.onTapLogout});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(child: Text(title)),
      //elevation: 0.0,
      backgroundColor: Colors.green[800], // Set the AppBar color to green
      leading: IconButton(
        icon:Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5), // Black color with 50% opacity
              spreadRadius: 1, // Spread radius
              blurRadius: 2, // Blur radius
              offset: Offset(0, 3), // Offset in x and y direction
            ),
          ],
          ),
          child: InkWell(
            onTap: () {
              // Call the onTap function to toggle the drawer
              ontapmenu?.call();

            },
            child: Icon(
              Icons.menu,
              size: 25,
              color: AppColors.greencolor,
            ),
          ),
        ),
        onPressed: () {
          ontapmenu(); // Open the drawer
        },
      ),
      actions: [
        IconButton(
          icon: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10), boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5), // Black color with 50% opacity
                spreadRadius: 1, // Spread radius
                blurRadius: 2, // Blur radius
                offset: Offset(0, 3), // Offset in x and y direction
              ),
            ],

            ),
            child: Icon(
              Icons.logout,
              color: Colors.green, // Set the icon color to white
            ),
          ),
          onPressed: () {
            onTapLogout(); // Perform logout action
          },
        ),
      ],
    );
  }
}
