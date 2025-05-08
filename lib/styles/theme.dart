import 'package:capstone_project/const/constant.dart';
import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: cardBackgroundColor, 
    titleTextStyle: const TextStyle(
      color: Colors.white, 
      fontSize: 20, 
      fontWeight: FontWeight.bold,
    
    ),
    iconTheme: const IconThemeData(
      color: selectionColor, // Set IconButton color to white
    ),
  ),
  scaffoldBackgroundColor: backgroundColor, 
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: cardBackgroundColor, 
    selectedItemColor: Colors.white, 
    unselectedItemColor: Colors.grey, 
  ),
);