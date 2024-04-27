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
await readExpenses();
}
//read-expenses from db
Future <void> readExpenses() async{
  //fetch all expesnes from db
List<Expense> fetchedExpenses = await isar.expenses.where().findAll();
 //give expenses to local 
_allExpenses.clear();
_allExpenses.addAll(fetchedExpenses);

 //update the ui
notifyListeners();

  //
}
//update -edit an expense
Future<void> updateExpense(int id,Expense updateExpense) async {
  updateExpense.id =id;

  await isar.writeTxn(() => isar.expenses.put(updateExpense));
  await readExpenses();
}



//delete -an expense
Future<void> deleteExpense(int id) async {
  await isar.writeTxn(() => isar.expenses.delete(id));
  await readExpenses();
}



//help
Future<Map<int,double>> calculateMonthlyTotals() async {
  await readExpenses();

  Map <int,double> monthlyTotals ={
  };

  for  (var expense in _allExpenses){
  int month=expense.date.month;
  if(!monthlyTotals.containsKey(month)){
    monthlyTotals[month]=0;
  }
  monthlyTotals[month]=monthlyTotals[month]! +expense.amount;
  }
  return monthlyTotals;
  
}

int getStartMonth(){
  if(_allExpenses.isEmpty){
    return DateTime.now().month;
  }
  _allExpenses.sort((a,b)=>a.date.compareTo(b.date),);
  return _allExpenses.first.date.month;
}
int getStartYear(){
   if(_allExpenses.isEmpty){
    return DateTime.now().year;
  }
  _allExpenses.sort((a,b)=>a.date.compareTo(b.date),);
  return _allExpenses.first.date.year;
}

}
