enum TransactionType { deposit, withdrawal, transfer, receive }
enum TransactionStatus { pending, completed, failed }

class TransactionEntity {
  final String id;
  final String title;
  final double amount;
  final String currency;
  final DateTime date;
  final TransactionType type;
  final TransactionStatus status;

  TransactionEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.currency,
    required this.date,
    required this.type,
    required this.status,
  });
}
