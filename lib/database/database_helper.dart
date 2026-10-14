import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:textproject/models/transaction_model.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _db;
  Future<Database> get database async => _db ??= await _open();

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'expenzia.db'),
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE transactions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type TEXT NOT NULL,
          name TEXT NOT NULL,
          category TEXT NOT NULL,
          amount REAL NOT NULL,
          date TEXT NOT NULL
        )''');
        await _createCreditsTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) await _createCreditsTable(db);
      },
    );
  }

  Future<void> _createCreditsTable(DatabaseExecutor db) async {
    await db.execute('''CREATE TABLE credits (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      creditType TEXT NOT NULL,
      person TEXT NOT NULL,
      dueDate TEXT NOT NULL,
      planType TEXT NOT NULL,
      amount REAL NOT NULL
    )''');
  }

  Future<int> insert(ExpenseTransaction item) async =>
      (await database).insert('transactions', item.toMap());

  Future<List<ExpenseTransaction>> getAll() async {
    final rows = await (await database).query(
      'transactions',
      orderBy: 'date DESC, id DESC',
    );
    return rows.map(ExpenseTransaction.fromMap).toList();
  }

  Future<int> update(ExpenseTransaction item) async => (await database).update(
    'transactions',
    item.toMap()..remove('id'),
    where: 'id = ?',
    whereArgs: [item.id],
  );

  Future<int> delete(int id) async =>
      (await database).delete('transactions', where: 'id = ?', whereArgs: [id]);

  Future<Map<String, double>> totals() async {
    final db = await database;
    final i = await db.rawQuery(
      "SELECT COALESCE(SUM(amount), 0) total FROM transactions WHERE type = 'Income'",
    );
    final e = await db.rawQuery(
      "SELECT COALESCE(SUM(amount), 0) total FROM transactions WHERE type = 'Expense'",
    );
    final income = (i.first['total'] as num).toDouble();
    final expense = (e.first['total'] as num).toDouble();
    return {'income': income, 'expense': expense, 'balance': income - expense};
  }

  Future<int> insertCredit(Map<String, Object?> credit) async =>
      (await database).insert('credits', credit);

  Future<List<Map<String, Object?>>> getCredits() async =>
      (await database).query('credits', orderBy: 'id DESC');

  Future<int> deleteCredit(int id) async =>
      (await database).delete('credits', where: 'id = ?', whereArgs: [id]);

  Future<void> insertTransaction(ExpenseTransaction expenseTransaction) async {}

  Future<void> updateTransaction(ExpenseTransaction expenseTransaction) async {}

  getTransactions() {}

  Future<void> deleteTransaction(int i) async {}
}
