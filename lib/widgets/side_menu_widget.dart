import 'package:capstone_project/const/constant.dart';
import 'package:capstone_project/data/side_menu_data.dart';
import 'package:capstone_project/screens/graph_screen.dart';
import 'package:capstone_project/screens/main_screen.dart';
import 'package:capstone_project/screens/settings_screen.dart';
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
        screen = MainScreen();
        break;
      case 'Charts':
        screen = GraphScreen(); // Navigates to TestScreen
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