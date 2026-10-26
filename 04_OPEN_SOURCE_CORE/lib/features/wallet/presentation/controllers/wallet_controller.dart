import 'package:flutter/material.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../../data/repositories/mock_wallet_repository_impl.dart';

class WalletController extends ChangeNotifier {
  static final WalletController instance = WalletController(MockWalletRepositoryImpl());

  final WalletRepository _repository;
  WalletEntity? _wallet;
  bool _isLoading = false;
  String? _errorMessage;

  WalletController(this._repository) {
    loadBalance();
  }

  WalletEntity? get wallet => _wallet;
  double get balance => _wallet?.balance ?? 15420.50;
  String get currency => _wallet?.currency ?? 'YER';
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadBalance() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _wallet = await _repository.getWalletBalance('user_1');
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deposit(double amount) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _wallet = await _repository.deposit(amount);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> withdraw(double amount) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _wallet = await _repository.withdraw(amount);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendMoney(double amount, String recipient) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _wallet = await _repository.sendMoney(amount, recipient);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> receiveMoney(double amount, String sender) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _wallet = await _repository.receiveMoney(amount, sender);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
