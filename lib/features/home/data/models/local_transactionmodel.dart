class LocalTransactionmodel {
  final String id;
  final double amount;
  final String note;
  final String type;
  final String categoryName;
  final DateTime timestamp;

  LocalTransactionmodel({
    required this.id,
    required this.amount,
    required this.note,
    required this.type,
    required this.categoryName,
    required this.timestamp,
  });

  factory LocalTransactionmodel.fromMap(Map<String, dynamic> map) {
    return LocalTransactionmodel(
      id: map['id'] as String,
      amount: (map['amount'] as num).toDouble(),
      note: map['note'] as String,
      type: map['type'] as String,
      categoryName: map['category_name'] as String? ?? 'Uncategorized',
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
}
