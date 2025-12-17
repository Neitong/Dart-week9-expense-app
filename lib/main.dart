import 'package:flutter/material.dart';
import 'dart:async';
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
  // ScaffoldMessenger key to manage SnackBars 
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  void onCloseModal(BuildContext context) {
    Navigator.pop(context);
  }

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
      ), // Displays the Inputexpense widget
    );
  }

  void onRemoveExpense(int index) {
    final removedExpense = _registeredExpenses[index];
    setState(() {
      _registeredExpenses.removeAt(index);
    });

    // Delay to allow Dismissible animation to complete
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;

      // First clear the snack bar if needed
      _scaffoldMessengerKey.currentState?.clearSnackBars();

      // Then display a snack bar with Undo option
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: const Text('Expense deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Insert again the Expense you have just removed
              if (mounted) {
                setState(() {
                  _registeredExpenses.insert(index, removedExpense);
                });
              }
              // Hide the snackbar after undo
              _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
            },
          ),
          duration: const Duration(seconds: 3),
        ),
      );

      // Auto-dismiss after 3 seconds
      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          _scaffoldMessengerKey.currentState?.removeCurrentSnackBar();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _scaffoldMessengerKey,
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
                            _registeredExpenses[index],
                            onRemove: () => onRemoveExpense(index),
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

