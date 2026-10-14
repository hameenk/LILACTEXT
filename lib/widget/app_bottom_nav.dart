import 'package:flutter/material.dart';
import 'package:textproject/screen/add_expense_page.dart';
import 'package:textproject/screen/app_theme.dart';
import 'package:textproject/screen/credit_page.dart';
import 'package:textproject/screen/homepage.dart';
import 'package:textproject/screen/profile_page.dart';
import 'package:textproject/screen/transaction_page.dart';

class AppBottomNav extends StatelessWidget {
  final int selectedIndex;
  const AppBottomNav({super.key, required this.selectedIndex});

  void _open(BuildContext context, int index) {
    if (index == selectedIndex) return;
    final pages = <Widget>[
      const HomePage(),
      const TransactionPage(),
      const CreditPage(),
      const CreditPage(),
      const ProfilePage(),
    ];
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => pages[index]));
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppTheme.teal,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      height: 64,
      padding: EdgeInsets.zero,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        children: [
          Expanded(child: _item(context, 0, Icons.home_outlined)),
          Expanded(child: _item(context, 1, Icons.history)),
          const Expanded(child: SizedBox()), // space for the + button
          Expanded(
            child: _item(context, 2, Icons.account_balance_wallet_outlined),
          ),
          Expanded(child: _item(context, 4, Icons.person_outline)),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, int index, IconData icon) {
    final active = selectedIndex == index;
    return InkResponse(
      onTap: () => _open(context, index),
      radius: 28,
      child: SizedBox(
        height: 64,
        child: Icon(
          icon,
          size: 24,
          color: active ? Colors.white : Colors.white.withAlpha(140),
        ),
      ),
    );
  }
}

class MainScaffold extends StatelessWidget {
  final String title;
  final int selectedIndex;
  final Widget body;
  final bool showAdd;
  const MainScaffold({
    super.key,
    required this.title,
    required this.selectedIndex,
    required this.body,
    this.showAdd = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: title == 'Homepage'
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 17),
                onPressed: () => Navigator.maybePop(context),
              ),
      ),
      body: body,
      floatingActionButton: showAdd
          ? FloatingActionButton(
              backgroundColor: AppTheme.tealDark,
              foregroundColor: Colors.white,
              elevation: 4,
              shape: const CircleBorder(
                side: BorderSide(color: Colors.white, width: 3),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddExpensePage()),
              ),
              child: const Icon(Icons.add, size: 28),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AppBottomNav(selectedIndex: selectedIndex),
    );
  }
}
