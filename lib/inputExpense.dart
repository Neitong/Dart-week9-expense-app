import 'package:flutter/material.dart';
import 'expense.dart';

class Inputexpense extends StatefulWidget {
  const Inputexpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<Inputexpense> createState() => _InputexpenseState();
}

class _InputexpenseState extends State<Inputexpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  Category _selectedCategory = Category.leisure;
  DateTime? _selectedDate;

  void _showDialog(String message){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Invalid Input'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: firstDate,
      lastDate: now,
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Function to handle validation and submission
  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    // 1. Validate Title
    if (_titleController.text.trim().isEmpty || _titleController.text.trim() == '') {
      _showDialog('The title cannot be empty');
      _amountController.clear();
      return;
    }

    // 2. Validate Amount
    if (amountIsInvalid) {
      _showDialog('The amount shall be a positive number');
      _amountController.clear();
      return;
    }

    // 3. Validate Date
    if (_selectedDate == null) {
      _showDialog('Please select a date');
      return;
    }

    final newExpense = Expense(
      title: _titleController.text.trim(),
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
    );

    widget.onAddExpense(newExpense);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
            onSubmitted: (_) => _submitExpenseData(),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              label: Text('Amount'),
              prefixText: '\$',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Category:'),
              const SizedBox(width: 8),
              DropdownButton<Category>(
                value: _selectedCategory,
                items: Category.values
                    .map(
                      (cattegories) => DropdownMenuItem(
                        value: cattegories,
                        child: Row(
                          children: [
                            Text(cattegories.name.toUpperCase()),
                            const SizedBox(width: 8),
                            Icon(categoryIcons[cattegories]),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const Spacer(),
              Text(
                _selectedDate == null
                    ? 'No date selected'
                    : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _presentDatePicker,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _submitExpenseData,
                child: const Text('Save Expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}