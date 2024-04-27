import 'dart:math';

import 'package:expensetracker/bar_graph/individual_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatefulWidget {
  final List<double> monthlySummary;
  final int startMonth;

  const MyBarGraph({super.key,
  required this.monthlySummary,
  required this.startMonth
  });

  @override
  State<MyBarGraph> createState() => _MyBarGraphState();
}

class _MyBarGraphState extends State<MyBarGraph> {
  List<IndividualBar> barData =[];

  void  initalizeBarData(){
    barData=List.generate(widget.monthlySummary.length, (index) => IndividualBar(x: index, y: widget.monthlySummary[index]));
  }
  @override
  Widget build(BuildContext context) {
    initalizeBarData();
    double barWidth =20;
    double spaceBetweenBars =15;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: barWidth*barData.length+spaceBetweenBars*(barData.length-1),
        child: BarChart(
         BarChartData(
          minY: 0,
          maxY: 100,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData:const FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles:AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true,
          getTitlesWidget: getBottomTitles,
          reservedSize: 24,
          )),
          ),
          barGroups: barData.map((data) => BarChartGroupData(x: data.x,barRods: [
            BarChartRodData(toY: data.y,
            width: 20,
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey.shade800,
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 100,
              color: Colors.white
            ),
            )
          ],),).toList(),
        
         ),
        ),
      ),
    );
  }

  //bottom titles

}
  Widget getBottomTitles(double value,TitleMeta meta){
    const textstyle =TextStyle(color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,

    );
    int monthIndex = (value.toInt()% 12) ;
    String text;
    switch (monthIndex) {
      case 0:
        text='J';
        break;
      case 1:
        text='F';
        break;
        case 2:
        text='M';
        break;
        case 3:
        text='A';
        break;
        case 4:
        text='M';
        break;
        case 5:
        text='J';
        break;
        case 6:
        text='J';
        break;
        case 7:
        text='A';
        break;
        case 8:
        text='S';
        break;
        case 9:
        text='O';
        break;
        case 10:
        text='N';
        break;
        case 11:
        text='D';
        break;
        
        
      default:
      text='';
      break;
    }
    return SideTitleWidget(child: Text(text,style: textstyle,), axisSide: meta.axisSide);
  }