import 'package:flutter/material.dart';
import 'expense.dart';

class CategoryBalance extends StatelessWidget {
  const CategoryBalance({
    super.key,
    required this.category,
    required this.total,
  });

  final Category category;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //Amount
        Text(
          '\$${total.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        //Spacing
        const SizedBox(height: 12),
        // Icon for category
        Icon(
          categoryIcons[category],
          size: 32,
          color: Colors.black87,
        ),
      ],
    );
  }
}

