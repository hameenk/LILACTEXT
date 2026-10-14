import 'package:flutter/material.dart';
import 'package:textproject/screen/app_theme.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';

class EditTransactionPage extends StatefulWidget {
  final ExpenseTransaction transaction;
  const EditTransactionPage({super.key, required this.transaction});

  @override
  State<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  late String type;
  late String category;
  late DateTime date;
  late TextEditingController nameController;
  late TextEditingController amountController;
  late TextEditingController noteController;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    final t = widget.transaction;
    type = t.type;
    category = t.category;
    date = DateTime.tryParse(t.date) ?? DateTime.now();
    nameController = TextEditingController(text: t.name);
    amountController = TextEditingController(text: t.amount.toString());
    noteController = TextEditingController(text: t.note);
  }

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
      await DatabaseHelper.instance.updateTransaction(
        ExpenseTransaction(
          id: widget.transaction.id,
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Transaction updated.')));
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not update transaction: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete transaction?'),
        content: const Text('This record will be removed from this device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true || widget.transaction.id == null) return;
    await DatabaseHelper.instance.deleteTransaction(widget.transaction.id!);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Edit Transaction'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 17),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          tooltip: 'Delete transaction',
          onPressed: _delete,
          icon: const Icon(Icons.delete_outline),
        ),
      ],
    ),
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
        TextField(controller: nameController),
        const SizedBox(height: 14),
        _label('CATEGORY'),
        DropdownButtonFormField<String>(
          value: category,
          items: [
            'Food',
            'Transport',
            'Utilities',
            'Shopping',
            'Health',
            'Other',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => category = v ?? 'Other'),
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
            child: Text('${date.day}, ${date.month}, ${date.year}'),
          ),
        ),
        const SizedBox(height: 14),
        _label('NOTE (OPTIONAL)'),
        TextField(controller: noteController),
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
                : const Text('Save Changes'),
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
