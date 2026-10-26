import '../../../../core/errors/failures.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../models/wallet_model.dart';

class MockWalletRepositoryImpl implements WalletRepository {
  double _balance = 15420.50;
  final String _currency = 'YER';

  @override
  Future<WalletEntity> getWalletBalance(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return WalletModel(
      id: 'wallet_1',
      userId: userId,
      balance: _balance,
      currency: _currency,
    );
  }

  @override
  Future<WalletEntity> deposit(double amount) async {
    if (amount <= 0) {
      throw const InvalidAmountFailure('المبلغ المدخل غير صالح');
    }
    await Future.delayed(const Duration(milliseconds: 500));
    _balance += amount;
    return WalletModel(
      id: 'wallet_1',
      userId: 'user_1',
      balance: _balance,
      currency: _currency,
    );
  }

  @override
  Future<WalletEntity> withdraw(double amount) async {
    if (amount <= 0) {
      throw const InvalidAmountFailure('المبلغ المدخل غير صالح');
    }
    if (_balance < amount) {
      throw const InsufficientBalanceFailure('الرصيد غير كافٍ لإتمام العملية');
    }
    await Future.delayed(const Duration(milliseconds: 500));
    _balance -= amount;
    return WalletModel(
      id: 'wallet_1',
      userId: 'user_1',
      balance: _balance,
      currency: _currency,
    );
  }

  @override
  Future<WalletEntity> sendMoney(double amount, String recipient) async {
    if (amount <= 0) {
      throw const InvalidAmountFailure('المبلغ المدخل غير صالح');
    }
    if (_balance < amount) {
      throw const InsufficientBalanceFailure('الرصيد غير كافٍ لإتمام الحوالة');
    }
    await Future.delayed(const Duration(milliseconds: 500));
    _balance -= amount;
    return WalletModel(
      id: 'wallet_1',
      userId: 'user_1',
      balance: _balance,
      currency: _currency,
    );
  }

  @override
  Future<WalletEntity> receiveMoney(double amount, String sender) async {
    if (amount <= 0) {
      throw const InvalidAmountFailure('المبلغ المدخل غير صالح');
    }
    await Future.delayed(const Duration(milliseconds: 500));
    _balance += amount;
    return WalletModel(
      id: 'wallet_1',
      userId: 'user_1',
      balance: _balance,
      currency: _currency,
    );
  }
}
