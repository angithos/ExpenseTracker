import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:expensetracker/database/expense_db.dart';

/*  
These are some helpful functions

//prgoram to convert number 



  */







  double convertStringToDouble(String string){
    double? amount =double.tryParse(string);
    return amount ?? 0;
  }
String FormatAmount(double amount){
  final format =NumberFormat.currency(locale: "en-US",symbol: "\BHD ",decimalDigits: 2);
  return format.format(amount);
}


//calcualte the monthly expense

//get the start month and the end month


//calculate the number of months since the start first month

int calculateMonthCount(int startYear,startMonth,currentYear,currentMonth){
  int monthCount =(currentYear-startYear)*12+currentMonth-startMonth+1;
  return monthCount;
}

//get curretn month name 
String getCurrentMonthName(){
  DateTime now =DateTime.now();
  List <String> months = [
  "JAN",
  "FEB",
  "MAR",
  "APR",
  "MAY",
  "JUN",
  "JUL",
  "AUG",
  "SEP",
  "OCT",
  "NOV",
  "DEC"

  ];
  return months[now.month-1];
}

