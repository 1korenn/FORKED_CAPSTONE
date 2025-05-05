import 'package:fl_chart/fl_chart.dart';


const minYmoisture = 0;
const maxYmoisture = 100;
const minXph = -14;
const maxXph = 14;

class LineData {
  // Dynamic list for Test1 spots
  final List<FlSpot> test1Spots = [];

  // Titles for the left axis
  final leftTitle = {
    0: '0',
    20: '20',
    40: '40',
    60: '60',
    80: '80',
    100: '100'
  };
} 
