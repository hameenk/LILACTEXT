import 'package:flutter/material.dart';
import 'package:textproject/screen/app_theme.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});
  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  String type = 'Expense';
  String category = 'Food';
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  DateTime date = DateTime.now();
  bool saving = false;

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => date = picked);
  }

  Future<void> _save() async {
    final name = nameController.text.trim();
    final amount = double.tryParse(amountController.text.trim());
    if (name.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a name and a valid amount.')),
      );
      return;
    }

    setState(() => saving = true);
    try {
      await DatabaseHelper.instance.insertTransaction(
        ExpenseTransaction(
          type: type,
          name: name,
          category: category,
          amount: amount,
          date:
              '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
          note: noteController.text.trim(),
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction saved to SQLite.')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save transaction: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Add Expense')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _label('TRANSACTION TYPE'),
        DropdownButtonFormField<String>(
          value: type,
          items: [
            'Expense',
            'Income',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => type = v ?? 'Expense'),
        ),
        const SizedBox(height: 14),
        _label('NAME'),
        TextField(
          controller: nameController,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(hintText: 'e.g. Groceries'),
        ),
        const SizedBox(height: 14),
        _label('CATEGORY'),
        DropdownButtonFormField<String>(
          value: category,
          items: [
            'Food',
            'Transport',
            'Shopping',
            'Bills',
            'Health',
            'Other',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => category = v ?? 'Food'),
        ),
        const SizedBox(height: 14),
        _label('AMOUNT'),
        TextField(
          controller: amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(prefixText: '₹ '),
        ),
        const SizedBox(height: 14),
        _label('DATE'),
        InkWell(
          onTap: _pickDate,
          child: InputDecorator(
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.calendar_month, size: 17),
            ),
            child: Text(
              '${date.day.toString().padLeft(2, '0')}, ${date.month.toString().padLeft(2, '0')}, ${date.year}',
            ),
          ),
        ),
        const SizedBox(height: 14),
        _label('NOTE (OPTIONAL)'),
        TextField(
          controller: noteController,
          decoration: const InputDecoration(hintText: 'Add a note'),
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: 46,
          child: FilledButton(
            onPressed: saving ? null : _save,
            child: saving
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ),
      ],
    ),
  );

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 9,
        color: AppTheme.muted,
        fontWeight: FontWeight.w600,
        letterSpacing: .6,
      ),
    ),
  );
}
