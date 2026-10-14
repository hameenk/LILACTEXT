import 'package:flutter/material.dart';
import 'package:textproject/screen/app_theme.dart';
import 'package:textproject/widget/app_bottom_nav.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';

import 'transaction_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ExpenseTransaction> transactions = [];
  Map<String, double> totals = {'income': 0, 'expense': 0, 'balance': 0};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedTransactions = await DatabaseHelper.instance.getTransactions();
    if (!mounted) return;

    final computedTotals = {'income': 0.0, 'expense': 0.0, 'balance': 0.0};
    for (final transaction in loadedTransactions) {
      if (transaction.type == 'Income') {
        computedTotals['income'] =
            (computedTotals['income'] ?? 0.0) + transaction.amount;
      } else {
        computedTotals['expense'] =
            (computedTotals['expense'] ?? 0.0) + transaction.amount;
      }
    }
    computedTotals['balance'] =
        (computedTotals['income'] ?? 0.0) - (computedTotals['expense'] ?? 0.0);

    setState(() {
      transactions = loadedTransactions;
      totals = computedTotals;
      loading = false;
    });
  }

  String _money(double value) => '₹${value.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) => MainScaffold(
    title: 'Homepage',
    selectedIndex: 0,
    body: loading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Good afternoon,',
                style: TextStyle(fontSize: 13, color: AppTheme.muted),
              ),
              const Text(
                'Sahal Muhammed',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.ink,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppTheme.teal,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Balance',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _money(totals['balance'] ?? 0),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _balanceInfo(
                            Icons.south_west,
                            'Income',
                            _money(totals['income'] ?? 0),
                          ),
                        ),
                        Expanded(
                          child: _balanceInfo(
                            Icons.north_east,
                            'Expense',
                            _money(totals['expense'] ?? 0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transaction History',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  TextButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TransactionPage(),
                        ),
                      );
                      _loadData();
                    },
                    child: const Text(
                      'See all',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
              if (transactions.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 28),
                  child: Center(
                    child: Text(
                      'No transactions yet. Tap + to add one.',
                      style: TextStyle(color: AppTheme.muted),
                    ),
                  ),
                )
              else
                ...transactions.take(6).map((t) => _transactionRow(t)),
            ],
          ),
  );

  Widget _balanceInfo(IconData icon, String label, String amount) => Row(
    children: [
      CircleAvatar(
        radius: 15,
        backgroundColor: Colors.white24,
        child: Icon(icon, color: Colors.white, size: 16),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
            Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _transactionRow(ExpenseTransaction t) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      children: [
        CircleAvatar(
          radius: 19,
          backgroundColor: const Color(0xFFE7F2F1),
          child: Icon(
            t.type == 'Income' ? Icons.south_west : Icons.north_east,
            color: AppTheme.teal,
            size: 19,
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
              const SizedBox(height: 3),
              Text(
                '${t.category} · ${t.date}',
                style: const TextStyle(fontSize: 10, color: AppTheme.muted),
              ),
            ],
          ),
        ),
        Text(
          '${t.type == 'Income' ? '+' : '-'} ${_money(t.amount)}',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: t.type == 'Income' ? AppTheme.teal : Colors.redAccent,
          ),
        ),
      ],
    ),
  );
}
