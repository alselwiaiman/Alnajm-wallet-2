import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.currency,
    required super.date,
    required super.type,
    required super.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'USD',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      type: TransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => TransactionType.transfer,
      ),
      status: TransactionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => TransactionStatus.completed,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'currency': currency,
      'date': date.toIso8601String(),
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
    };
  }
}
