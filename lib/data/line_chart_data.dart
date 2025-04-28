import 'package:fl_chart/fl_chart.dart';

class LineData {
  // Data for Test1
  final test1Spots = const [
    FlSpot(0, 20),
    FlSpot(1, 40),
    FlSpot(2, 60),
 
    FlSpot(20, 100),
    FlSpot(21, 80),
    FlSpot(22, 60),
    FlSpot(23, 40),
    FlSpot(24, 20),
  ];

  // Data for pH
  final phSpots = const [
    FlSpot(0, 7),
    FlSpot(1, 6.8),
    FlSpot(2, 7.2),
    FlSpot(3, 7.1),
   
  ];
  // Data for Moisture
  final moistureSpots = const [
    FlSpot(0, 30),
    FlSpot(1, 35),
    FlSpot(2, 40),
   
  ];

  // Data for Heat
  final heatSpots = const [
    FlSpot(0, 25),
    FlSpot(1, 30),
    FlSpot(2, 35),
    FlSpot(3, 40),
    FlSpot(4, 45),
    FlSpot(5, 50),
    FlSpot(6, 55),
    FlSpot(7, 60),
    FlSpot(8, 65),
    FlSpot(9, 70),
  ];

  // Titles for the left axis
  final leftTitle = {
    0: '0',
    20: '20',
    40: '40',
    60: '60',
    80: '80',
    100: '100'
  };

  // Titles for the bottom axis
  final bottomTitle = {
    0: "0",
    3: "3",
    6: "6",
    9: "9",
    12: "12",
    15: "15",
    18: "18",
    21: "21",
    24: "24"
  };
}