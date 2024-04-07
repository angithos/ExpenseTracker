import 'package:expensetracker/database/expense_db.dart';
import 'package:expensetracker/helper/helper_fun.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //text controllers
  TextEditingController nameController=TextEditingController();
  TextEditingController amountController=TextEditingController();


  @override
  void initState() {
    Provider.of<ExpenseDatabase>(context,listen:false).readExpenses();
    // TODO: implement initState
    super.initState();
  }

void openNewExpenseBox(){
  showDialog(context: context,
  builder:(context)=>AlertDialog(
    title: Text("New expense"),
    content:Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //user input
      TextField(
        controller: nameController,
        decoration: InputDecoration(hintText:"Name" ),
      ),
       TextField(
        controller: amountController,
        decoration: InputDecoration(hintText:"Amount" ),
      )  //erxpense amoubnt
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


  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(builder: (context,value,child)=>Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
        openNewExpenseBox();
      },
      child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount:value.allExpense.length ,
        itemBuilder:(context,index){
        //get individual expenses
         Expense individualExpense =value.allExpense[index];
        
        //return  list tile ui

          return ListTile(
            title: Text(individualExpense.name),
            trailing: Text(individualExpense.amount.toString()),
          );
        }),
    ),
    );
  }
  //cancel btn
Widget _cancelButton(){
  return MaterialButton(onPressed: (){
    Navigator.pop(context);
    nameController.clear();
    amountController.clear();
  },
  //pop box

  child: const Text("cancel"),
  );
}
Widget _createNewExpense(){
  return MaterialButton(onPressed: ()async {
    if (nameController.text.isNotEmpty && amountController.text.isNotEmpty){
      //pop box

Navigator.pop(context);

      //create new expense 
    Expense newExpense =Expense(name: nameController.text, amount: convertStringToDouble(amountController.text), date: DateTime.now());

    //save to db 

   await context.read<ExpenseDatabase>().createNewExpense(newExpense);

    //clear controllers
  nameController.clear();
  amountController.clear();

    }
  },
    child:Text("Save") ,
  );
}


  //save btn
}