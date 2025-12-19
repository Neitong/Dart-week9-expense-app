import 'package:flutter/material.dart';
import 'expense.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;
  final void Function(int) onDismiss;
  final void Function(Expense) onUndo;

  const ExpenseItem({
    super.key,
    required this.expense,
    required this.onDismiss,
    required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(expense.title),
      background: Container(
        padding: EdgeInsets.only(right: 20, left: 20),
        margin: EdgeInsets.only(right: 20, left: 20),
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Icon(Icons.delete, color: Colors.white)],
        ),
      ),
      onDismissed: (direction) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${expense.title} dismissed'),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                onUndo(expense);
              },
            ),
          ),
        );
        onDismiss(expense.id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColorDark.withOpacity(0.1),
            child: Icon(
                categoryIcons[expense.category],
                color: Colors.black87,
            ),
          ),
          title: Text(
            expense.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            expense.category.name[0].toUpperCase() +
                expense.category.name.substring(1),
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          trailing: Text(
            '\$ ${expense.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}