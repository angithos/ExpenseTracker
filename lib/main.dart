import 'package:expensetracker/database/expense_db.dart';
import 'package:expensetracker/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ExpenseDatabase.initalize();
  runApp(
    ChangeNotifierProvider(
      create: (context) =>ExpenseDatabase() ,
      child:const MyApp() ,
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: HomePage()
    );
  }
}


