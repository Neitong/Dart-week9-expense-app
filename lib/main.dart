import 'package:flutter/material.dart';
import 'expense.dart';
import 'expenseItem.dart';
import 'expensesStatistics.dart';
import "inputExpense.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Expense> _registeredExpenses = [];

  void onAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Inputexpense(
        onAddExpense: (expense) {
          setState(() {
            _registeredExpenses.add(expense);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expenses App',
      theme: ThemeData(
        // Defining a primary color for the AppBar
        primaryColor: Colors.blue,
        useMaterial3: true,
      ),
      home: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Colors.blue[50],
          appBar: AppBar(
            title: const Text('Expenses App'),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => onAdd(context),
              ),
            ],
          ),
          body: Column(
            children: [
              const SizedBox(height: 10),
              ExpensesStatistics(_registeredExpenses),
              Expanded(
                child: _registeredExpenses.isEmpty
                    ? const Center(
                        child: Text(
                          'No expenses found. Start adding some!',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _registeredExpenses.length,
                        itemBuilder: (ctx, index) => ExpenseItem(
                          expense: _registeredExpenses[index],
                          onDismiss: (id) {
                            setState(() {
                              _registeredExpenses.removeAt(index);
                            });
                          },
                          onUndo: (expenseItem) {
                            setState(() {
                              _registeredExpenses.insert(index, expenseItem);
                            });
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
