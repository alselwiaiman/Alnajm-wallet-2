import 'package:flutter/material.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../data/repositories/mock_transaction_repository_impl.dart';

class TransactionController extends ChangeNotifier {
  static final TransactionController instance = TransactionController(MockTransactionRepositoryImpl());

  final TransactionRepository _repository;
  List<TransactionEntity> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  TransactionController(this._repository) {
    loadTransactions();
  }

  List<TransactionEntity> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadTransactions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transactions = await _repository.getTransactions('user_1');
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createTransfer(String recipient, double amount, [String currency = 'YER']) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.createTransfer(recipient, amount, currency);
      await loadTransactions();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> recordCustom({
    required String title,
    required double amount,
    required TransactionType type,
    String currency = 'YER',
  }) async {
    if (_repository is MockTransactionRepositoryImpl) {
      await (_repository as MockTransactionRepositoryImpl).recordTransaction(
        title: title,
        amount: amount,
        type: type,
        currency: currency,
      );
      await loadTransactions();
    }
  }
}
