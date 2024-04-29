import 'dart:math';

import 'package:expensetracker/bar_graph/bar_graph.dart';
import 'package:expensetracker/components/my_list_tile.dart';
import 'package:expensetracker/database/expense_db.dart';
import 'package:expensetracker/helper/helper_fun.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //text controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
//scaffold key

  var amountStyle = TextStyle(
    fontSize: 16,
  );

  //future to load bar graph and monthly total
  Future<Map<String, double>>? _monthlyTotalsFuture;
  Future<double>? _calculateCurrentMonthTotal;
  @override
  void initState() {
    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();
    refreshData();
    // TODO: implement initState
    super.initState();
  }

  void refreshData() {
    _monthlyTotalsFuture = Provider.of<ExpenseDatabase>(context, listen: false)
        .calculateMonthlyTotals();
    _calculateCurrentMonthTotal =
        Provider.of<ExpenseDatabase>(context, listen: false)
            .calculateCurrentMonthTotal();
  }

  void openEditBox(Expense expense) {
    //pre-load exisiting value

    String exisingName = expense.name;
    String exisingAmount = expense.amount.toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //user input
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: exisingName),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(hintText: exisingAmount),
            ) //erxpense amoubnt
          ],
        ),
        actions: [
          //cancel btn

          _cancelButton(),
          _editExpenseButton(expense)
          //save button
        ],
      ),
    );
  }

  void openNewExpenseBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("New expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //user input
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: "Name"),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(hintText: "Amount"),
            ) //erxpense amoubnt
          ],
        ),
        actions: [
          //cancel btn
          _createNewExpense(),
          _cancelButton(),

          //save button
        ],
      ),
    );
  }

  //delete box
  void openDeleteBox(Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Do you want to delete this expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          // children: [
          //   //user input
          //   TextField(
          //     controller: nameController,
          //     decoration: InputDecoration(hintText: "Name"),
          //   ),
          //   TextField(
          //     controller: amountController,
          //     decoration: InputDecoration(hintText: "Amount"),
          //   ) //erxpense amoubnt
          // ],
        ),
        actions: [
          //cancel btn

          _cancelButton(),
          _deleteExpenseButton(expense.id),
          //save button
        ],
      ),
    );
  }
//open edit box

//open delete box

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(builder: (context, value, child) {
      //get dates
      int startMonth = value.getStartMonth();
      int startYear = value.getStartYear();
      int currentMonth = DateTime.now().month;
      int currentYear = DateTime.now().year;

      //calcualte the number of months since the first month
      int monthCount =
          calculateMonthCount(startYear, startMonth, currentYear, currentMonth);
      //only display the expense for the current month
      List<Expense> currentMonthExpenses = value.allExpense.where((expense) {
        return expense.date.year == currentYear &&
            expense.date.month == currentMonth;
      }).toList();
      //return UI
      return Scaffold(
        
        backgroundColor: Colors.grey.shade300,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openNewExpenseBox();
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: FutureBuilder<double>(
            future: _calculateCurrentMonthTotal,
            builder: (context, snapshot) {
              //laoded
              if (snapshot.connectionState == ConnectionState.done) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\ BHD${snapshot.data!.toStringAsFixed(2)}'),
                    Text(getCurrentMonthName())
                  ],
                );
              } else {
                return Text("Loading..");
              }
              //loading
            },
          ),
        //changes made 
       
        ),
        //list tile drawer
       
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: FutureBuilder(
                    future: _monthlyTotalsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, double> monthlyTotals = snapshot.data ?? {};

                        //create the list of montly summary
                        List<double> monthlySummary =
                            List.generate(monthCount, (index) {
                          //calculate the year and the month
                          int year = startYear + (startMonth + index - 1) ~/ 12;
                          int month = (startMonth + index - 1) % 12 + 1;

                          //create the key in the format of year month
                          String yearMonthKey = '$year-$month';
                          return monthlyTotals[yearMonthKey] ?? 0.0;
                        });
                        return MyBarGraph(
                            monthlySummary: monthlySummary,
                            startMonth: startMonth);
                      } else {
                        return const Center(
                          child: Text("Loading.."),
                        );
                      }
                    }),
              ),
              const SizedBox(
                height: 25,
              ),
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 20, bottom: 10),
                    itemCount: currentMonthExpenses.length,
                    itemBuilder: (context, index) {
                      //reverse the list to show the latest item
                      int reversedIndex =
                          currentMonthExpenses.length - 1 - index;
                      //get individual expenses
                      Expense individualExpense =
                          currentMonthExpenses[reversedIndex];

                      //return  list tile ui

                      return MylistTile(
                        title: individualExpense.name,
                        trailing: FormatAmount(individualExpense.amount),
                        onEditPressed: (context) =>
                            openEditBox(individualExpense),
                        onDeletePressed: (context) =>
                            openDeleteBox(individualExpense),
                      );
                    }),
              ),
            ],
          ),
        ),
      );
    });
  }

  //cancel btn
  Widget _cancelButton() {
    return MaterialButton(
      
      onPressed: () {
        Navigator.pop(context);
        nameController.clear();
        amountController.clear();
      },
      //pop box
      child: const Text("cancel"),
    );
  }

  Widget _createNewExpense() {
    return MaterialButton(
      onPressed: () async {
        if (nameController.text.isNotEmpty &&
            amountController.text.isNotEmpty) {
          //pop box

          Navigator.pop(context);

          //create new expense
          Expense newExpense = Expense(
              name: nameController.text,
              amount: convertStringToDouble(amountController.text),
              date: DateTime.now());

          //save to db

          await context.read<ExpenseDatabase>().createNewExpense(newExpense);
          //refresh graph
          refreshData();
          //clear controllers
          nameController.clear();
          amountController.clear();
        }
      },
      child: Text("Save"),
    );
  }

  Widget _editExpenseButton(Expense expense) {
    return MaterialButton(
      onPressed: () async {
        if (nameController.text.isNotEmpty ||
            amountController.text.isNotEmpty) {
          //pop the box
          Navigator.pop(context);

          //create a updated expense
          Expense updatedExpense = Expense(
              name: nameController.text.isNotEmpty
                  ? nameController.text
                  : expense.name,
              amount: amountController.text.isNotEmpty
                  ? convertStringToDouble(amountController.text)
                  : expense.amount,
              date: DateTime.now());

          //old expense id
          int existingId = expense.id;
          //save it to database
          await context
              .read<ExpenseDatabase>()
              .updateExpense(existingId, updatedExpense);
          refreshData();
          //
        }
      },
      child: Text("Edit"),
    );
  }

  //save btn

  //delet btn

  Widget _deleteExpenseButton(int id) {
    return MaterialButton(
      onPressed: () async {
        //pop box
        Navigator.pop(context);

        //delete expense from db

        await context.read<ExpenseDatabase>().deleteExpense(id);
        refreshData();
      },
      child: const Text("Delete"),
    );
  }
}
