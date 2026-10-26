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

  // Multi-Currency Balances for Yemen Market
  double _balanceYer = 154200.00;
  double _balanceSar = 3850.00;
  double _balanceUsd = 1200.00;

  String _selectedCurrency = 'YER'; // 'YER', 'SAR', 'USD'

  // Market Exchange Rates (Sana'a & Aden averages for demo)
  final Map<String, double> buyRates = {
    'SAR_YER': 140.50,
    'USD_YER': 535.00,
  };
  final Map<String, double> sellRates = {
    'SAR_YER': 141.20,
    'USD_YER': 537.00,
  };

  WalletController(this._repository) {
    loadBalance();
  }

  WalletEntity? get wallet => _wallet;
  String get selectedCurrency => _selectedCurrency;

  double get balanceYer => _balanceYer;
  double get balanceSar => _balanceSar;
  double get balanceUsd => _balanceUsd;

  double get balance {
    switch (_selectedCurrency) {
      case 'SAR':
        return _balanceSar;
      case 'USD':
        return _balanceUsd;
      default:
        return _balanceYer;
    }
  }

  String get currency => _selectedCurrency;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void selectCurrency(String code) {
    if (_selectedCurrency != code) {
      _selectedCurrency = code;
      notifyListeners();
    }
  }

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

  Future<bool> deposit(double amount, [String curr = 'YER']) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (curr == 'SAR') {
        _balanceSar += amount;
      } else if (curr == 'USD') {
        _balanceUsd += amount;
      } else {
        _balanceYer += amount;
        await _repository.deposit(amount);
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> withdraw(double amount, [String curr = 'YER']) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (curr == 'SAR') {
        if (_balanceSar < amount) throw Exception('الرصيد بالريال السعودي غير كافٍ');
        _balanceSar -= amount;
      } else if (curr == 'USD') {
        if (_balanceUsd < amount) throw Exception('الرصيد بالدولار غير كافٍ');
        _balanceUsd -= amount;
      } else {
        if (_balanceYer < amount) throw Exception('الرصيد بالريال اليمني غير كافٍ');
        _balanceYer -= amount;
        await _repository.withdraw(amount);
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendMoney(double amount, String recipient, [String curr = 'YER']) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (curr == 'SAR') {
        if (_balanceSar < amount) throw Exception('الرصيد بالريال السعودي غير كافٍ');
        _balanceSar -= amount;
      } else if (curr == 'USD') {
        if (_balanceUsd < amount) throw Exception('الرصيد بالدولار غير كافٍ');
        _balanceUsd -= amount;
      } else {
        if (_balanceYer < amount) throw Exception('الرصيد بالريال اليمني غير كافٍ');
        _balanceYer -= amount;
        await _repository.sendMoney(amount, recipient);
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> exchangeCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double fromAmount,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      double rate = 1.0;
      if (fromCurrency == 'USD' && toCurrency == 'YER') {
        rate = buyRates['USD_YER'] ?? 535.0;
        if (_balanceUsd < fromAmount) throw Exception('رصيد الدولار غير كافٍ');
        _balanceUsd -= fromAmount;
        _balanceYer += fromAmount * rate;
      } else if (fromCurrency == 'SAR' && toCurrency == 'YER') {
        rate = buyRates['SAR_YER'] ?? 140.5;
        if (_balanceSar < fromAmount) throw Exception('رصيد الريال السعودي غير كافٍ');
        _balanceSar -= fromAmount;
        _balanceYer += fromAmount * rate;
      } else if (fromCurrency == 'YER' && toCurrency == 'SAR') {
        rate = sellRates['SAR_YER'] ?? 141.2;
        final cost = fromAmount * rate;
        if (_balanceYer < cost) throw Exception('رصيد الريال اليمني غير كافٍ');
        _balanceYer -= cost;
        _balanceSar += fromAmount;
      } else if (fromCurrency == 'YER' && toCurrency == 'USD') {
        rate = sellRates['USD_YER'] ?? 537.0;
        final cost = fromAmount * rate;
        if (_balanceYer < cost) throw Exception('رصيد الريال اليمني غير كافٍ');
        _balanceYer -= cost;
        _balanceUsd += fromAmount;
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void injectDemoFunds(double yer, double sar, double usd) {
    _balanceYer += yer;
    _balanceSar += sar;
    _balanceUsd += usd;
    notifyListeners();
  }
}
