import 'package:flutter/material.dart';
import 'package:textproject/screen/app_theme.dart';
import 'package:textproject/screen/edite_transaction_page.dart';
import 'package:textproject/widget/app_bottom_nav.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});
  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<ExpenseTransaction> transactions = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final rows = await DatabaseHelper.instance.getTransactions();
    if (!mounted) return;
    setState(() {
      transactions = rows;
      loading = false;
    });
  }

  String _dateHeader(String date) {
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return date;
    const months = [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER',
    ];
    return '${months[parsed.month - 1]} ${parsed.year}';
  }

  @override
  Widget build(BuildContext context) => MainScaffold(
    title: 'Transaction History',
    selectedIndex: 1,
    body: loading
        ? const Center(child: CircularProgressIndicator())
        : transactions.isEmpty
        ? const Center(
            child: Text(
              'No transactions saved yet.',
              style: TextStyle(color: AppTheme.muted),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final t = transactions[index];
              final showHeader =
                  index == 0 ||
                  _dateHeader(transactions[index - 1].date) !=
                      _dateHeader(t.date);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showHeader)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 5),
                      child: Text(
                        _dateHeader(t.date),
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.muted,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditTransactionPage(transaction: t),
                        ),
                      );
                      _load();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: const Color(0xFFE7F2F1),
                            child: Icon(
                              t.type == 'Income'
                                  ? Icons.south_west
                                  : Icons.north_east,
                              color: AppTheme.teal,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${t.category} · ${t.date}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppTheme.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${t.type == 'Income' ? '+' : '-'} ₹${t.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 11,
                              color: t.type == 'Income'
                                  ? AppTheme.teal
                                  : Colors.redAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: AppTheme.muted,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
  );
}
