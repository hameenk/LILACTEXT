import 'package:flutter/material.dart';
import 'package:textproject/screen/app_theme.dart';
import 'package:textproject/widget/app_bottom_nav.dart';
import '../database/database_helper.dart';

class CreditPage extends StatefulWidget {
  const CreditPage({super.key});
  @override
  State<CreditPage> createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
  String creditType = 'Subscriptions';
  String planType = 'Monthly';
  final toController = TextEditingController();
  final amountController = TextEditingController();
  DateTime dueDate = DateTime(2026, 2, 22);
  List<Map<String, Object?>> savedCredits = [];
  bool saving = false;

  @override
  void initState() {
    super.initState();
    _loadCredits();
  }

  @override
  void dispose() {
    toController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> _loadCredits() async {
    final rows = await DatabaseHelper.instance.getCredits();
    if (mounted) setState(() => savedCredits = rows);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => dueDate = picked);
  }

  String _dateText(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  Future<void> _saveCredit() async {
    final person = toController.text.trim();
    final amount = double.tryParse(amountController.text.trim());
    if (person.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a name and a valid amount.')),
      );
      return;
    }

    setState(() => saving = true);
    try {
      await DatabaseHelper.instance.insertCredit({
        'creditType': creditType,
        'person': person,
        'dueDate':
            '${dueDate.year.toString().padLeft(4, '0')}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}',
        'planType': planType,
        'amount': amount,
      });
      toController.clear();
      amountController.clear();
      await _loadCredits();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Credit saved to SQLite')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not save credit: $e')));
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  Future<void> _deleteCredit(int id) async {
    await DatabaseHelper.instance.deleteCredit(id);
    await _loadCredits();
  }

  @override
  Widget build(BuildContext context) => MainScaffold(
    title: 'Credit',
    selectedIndex: 2,
    body: Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
        children: [
          _label('CREDIT TYPE'),
          DropdownButtonFormField<String>(
            value: creditType,
            isExpanded: true,
            decoration: _fieldDecoration(),
            items: [
              'Subscriptions',
              'Personal',
              'Business',
              'Other',
            ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
            onChanged: (v) => setState(() => creditType = v ?? 'Subscriptions'),
          ),
          const SizedBox(height: 9),
          _label('TO'),
          TextField(
            controller: toController,
            decoration: _fieldDecoration(hint: 'Netflix'),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 9),
          _label('DATE'),
          InkWell(
            onTap: _pickDate,
            child: InputDecorator(
              decoration: _fieldDecoration(
                suffix: const Icon(
                  Icons.calendar_month,
                  size: 17,
                  color: Colors.grey,
                ),
              ),
              child: Text(
                '${['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][dueDate.weekday - 1]}, ${dueDate.day.toString().padLeft(2, '0')} ${_month(dueDate.month)} ${dueDate.year}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF777777)),
              ),
            ),
          ),
          const SizedBox(height: 9),
          _label('PLAN TYPE'),
          DropdownButtonFormField<String>(
            value: planType,
            isExpanded: true,
            decoration: _fieldDecoration(),
            items: [
              'Monthly',
              'One-Time',
              'Weekly',
              'Yearly',
            ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
            onChanged: (v) => setState(() => planType = v ?? 'Monthly'),
          ),
          const SizedBox(height: 9),
          _label('AMOUNT'),
          TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: _fieldDecoration(hint: '850.00', prefix: '₹ '),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 43,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.teal,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              onPressed: saving ? null : _saveCredit,
              child: saving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Your Saved Lists',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.ink,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          if (savedCredits.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Text(
                'No saved credits yet.',
                style: TextStyle(fontSize: 11, color: AppTheme.muted),
              ),
            )
          else
            ...savedCredits.map(_creditRow),
        ],
      ),
    ),
  );

  Widget _creditRow(Map<String, Object?> credit) {
    final id = credit['id'] as int;
    final due = DateTime.tryParse(credit['dueDate'] as String? ?? '');
    final dueText = due == null
        ? (credit['dueDate'] as String? ?? '')
        : 'Due ${_dateText(due)}';
    return Dismissible(
      key: ValueKey('credit_$id'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 18),
        color: Colors.redAccent,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => _deleteCredit(id),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    credit['person'] as String? ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    dueText,
                    style: TextStyle(
                      fontSize: 10,
                      color: due != null && due.isBefore(DateTime.now())
                          ? Colors.redAccent
                          : AppTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  credit['planType'] as String? ?? '',
                  style: const TextStyle(fontSize: 9, color: AppTheme.muted),
                ),
                const SizedBox(height: 2),
                Text(
                  '₹ ${(credit['amount'] as num).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({
    String? hint,
    Widget? suffix,
    String? prefix,
  }) => InputDecoration(
    hintText: hint,
    prefixText: prefix,
    suffixIcon: suffix,
    isDense: true,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE6E6E6)),
    ),
  );

  Widget _label(String value) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Text(
      value,
      style: const TextStyle(
        fontSize: 9,
        color: Color(0xFF858585),
        fontWeight: FontWeight.w600,
        letterSpacing: .45,
      ),
    ),
  );

  String _month(int month) => const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][month - 1];
}
