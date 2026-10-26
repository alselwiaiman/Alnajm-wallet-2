import 'package:flutter/material.dart';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isCredit;
  final String type; // 'send', 'receive', 'deposit', 'withdraw'

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.isCredit,
    required this.type,
  });
}

class DemoData extends ChangeNotifier {
  static final DemoData instance = DemoData._internal();
  DemoData._internal();

  double _balance = 15420.50;
  final List<Transaction> _transactions = [
    Transaction(id: '1', title: 'إيداع نقدي', amount: 10000, date: DateTime.now().subtract(const Duration(days: 3)), isCredit: true, type: 'deposit'),
    Transaction(id: '2', title: 'تحويل إلى أحمد', amount: 3000, date: DateTime.now().subtract(const Duration(days: 2)), isCredit: false, type: 'send'),
    Transaction(id: '3', title: 'استلام من محمد', amount: 5000, date: DateTime.now().subtract(const Duration(days: 1)), isCredit: true, type: 'receive'),
    Transaction(id: '4', title: 'سداد فاتورة كهرباء', amount: 1500, date: DateTime.now().subtract(const Duration(hours: 12)), isCredit: false, type: 'send'),
    Transaction(id: '5', title: 'شحن رصيد', amount: 4920.50, date: DateTime.now().subtract(const Duration(hours: 5)), isCredit: true, type: 'deposit'),
  ];

  double get balance => _balance;
  List<Transaction> get transactions => _transactions.toList()..sort((a, b) => b.date.compareTo(a.date));

  void deposit(double amount) {
    if (amount <= 0) throw Exception('مبلغ غير صالح');
    _balance += amount;
    _addTransaction('إيداع نقدي', amount, true, 'deposit');
  }

  void withdraw(double amount) {
    if (amount <= 0) throw Exception('مبلغ غير صالح');
    if (_balance < amount) throw Exception('الرصيد غير كافٍ');
    _balance -= amount;
    _addTransaction('سحب نقدي', amount, false, 'withdraw');
  }

  void send(double amount, String recipient) {
    if (amount <= 0) throw Exception('مبلغ غير صالح');
    if (_balance < amount) throw Exception('الرصيد غير كافٍ');
    _balance -= amount;
    _addTransaction('تحويل إلى $recipient', amount, false, 'send');
  }

  void receive(double amount, String sender) {
    if (amount <= 0) throw Exception('مبلغ غير صالح');
    _balance += amount;
    _addTransaction('استلام من $sender', amount, true, 'receive');
  }

  void _addTransaction(String title, double amount, bool isCredit, String type) {
    _transactions.add(Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      date: DateTime.now(),
      isCredit: isCredit,
      type: type,
    ));
    notifyListeners();
  }
}

