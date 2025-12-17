import 'package:flutter/material.dart';
import 'expense.dart';
import 'categoryBalance.dart';

class ExpensesStatistics extends StatelessWidget {
  const ExpensesStatistics(this.expenses, {super.key});

  final List<Expense> expenses;

  double _getTotalForCategory(Category category) {
    double total = 0;
    for (var expense in expenses) {
      if (expense.category == category) {
        total += expense.amount;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: Category.values
              .map((category) => CategoryBalance(
                    category: category,
                    total: _getTotalForCategory(category),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

