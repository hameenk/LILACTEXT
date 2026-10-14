class ExpenseTransaction {
  final int? id;
  final String type;
  final String name;
  final String category;
  final double amount;
  final String date;
  final String note;

  const ExpenseTransaction({
    this.id,
    required this.type,
    required this.name,
    required this.category,
    required this.amount,
    required this.date,
    this.note = '',
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'type': type,
    'name': name,
    'category': category,
    'amount': amount,
    'date': date,
    'note': note,
  };

  factory ExpenseTransaction.fromMap(Map<String, Object?> map) =>
      ExpenseTransaction(
        id: map['id'] as int?,
        type: map['type'] as String,
        name: map['name'] as String,
        category: map['category'] as String,
        amount: (map['amount'] as num).toDouble(),
        date: map['date'] as String,
        note: (map['note'] as String?) ?? '',
      );
}
