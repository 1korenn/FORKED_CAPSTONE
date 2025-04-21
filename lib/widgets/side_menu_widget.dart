 // Add this import
 // Add this import

import 'package:fitness_dashboard_ui/const/constant.dart';
import 'package:fitness_dashboard_ui/data/side_menu_data.dart';
import 'package:fitness_dashboard_ui/screens/main_screen.dart';
import 'package:fitness_dashboard_ui/screens/settings_screen.dart';
import 'package:fitness_dashboard_ui/screens/test_screen.dart';
import 'package:fitness_dashboard_ui/ui/dashboard_screen.dart';
import 'package:flutter/material.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({super.key});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final data = SideMenuData();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: cardBackgroundColor,
      child: ListView.builder(
        itemCount: data.menu.length,
        itemBuilder: (context, index) => buildMenuEntry(data, index),
      ),
    );
  }

  Widget buildMenuEntry(SideMenuData data, int index) {
    final isSelected = selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(6.0),
        ),
        color: isSelected ? selectionColor : Colors.transparent,
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
          navigateToScreen(context, data.menu[index].title);
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              child: Icon(
                data.menu[index].icon,
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
            Text(
              data.menu[index].title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.black : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }

  void navigateToScreen(BuildContext context, String title) {
    Widget screen;
    switch (title) {
      case 'Dashboard':
        screen = DashboardScreen();
        break;
      case 'Test':
        screen = TestScreen();
        break;
      case 'Settings':
        screen = SettingsScreen();
        break;
      case 'SignOut':
        // Handle sign out logic here
        return;
      default:
        screen = MainScreen(); // Default screen if no match is found
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}