import 'package:expensetracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseDatabase extends ChangeNotifier{
  static late Isar isar;
  List<Expense> _allExpenses =[];


//setup

//init db
static Future <void> initalize() async{
  final dir =await getApplicationDocumentsDirectory();
  isar=await Isar.open([ExpenseSchema], directory: dir.path);
}




//getters

List<Expense> get allExpense =>_allExpenses;



//operations

//create-add a new expense
Future <void> createNewExpense(Expense newExpense) async{
await isar.writeTxn(() => isar.expenses.put(newExpense));

}
//read-expenses from db
Future <void> readExpenes
//update -edit an expense

//delete -an expense




//help


}
