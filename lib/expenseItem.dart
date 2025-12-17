import 'package:flutter/material.dart';
import 'expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key, required this.onRemove});

  final Expense expense;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(expense.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onRemove();
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Title
              Text(
                expense.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              // 2. Row containing Amount, Spacer, and Icon+Date
              Row(
                children: [
                  // Amount
                  Text('\$${expense.amount.toStringAsFixed(2)}'),

                  // // INSTRUCTION: Use a spacer to handle space in the middle
                  const Spacer(),

                  // Icon + Date 
                  Row(
                    children: [
                      // INSTRUCTION: Display an icon depending on category
                      Icon(categoryIcons[expense.category]),
                      const SizedBox(width: 8),
                      // INSTRUCTION: Use intl package to format Date
                      Text(expense.formattedDate),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}