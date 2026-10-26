import 'package:flutter_test/flutter_test.dart';
import 'package:al_najm_wallet/core/config/app_config.dart';
import 'package:al_najm_wallet/features/wallet/data/repositories/mock_wallet_repository_impl.dart';
import 'package:al_najm_wallet/features/transactions/data/repositories/mock_transaction_repository_impl.dart';
import 'package:al_najm_wallet/features/transactions/domain/entities/transaction_entity.dart';

void main() {
  group('White-Label AppConfig Tests', () {
    test('Al-Najm Configuration has correct official branding', () {
      final config = AppConfig.alNajm();
      expect(config.companyName, 'النجم بلس');
      expect(config.defaultCurrency, 'YER');
      expect(config.primaryColor.value, 0xFF9E1B21);
    });

    test('Generic Configuration is brand neutral', () {
      final config = AppConfig.generic();
      expect(config.companyName, 'Open Wallet');
      expect(config.defaultCurrency, 'USD');
    });
  });

  group('Wallet Clean Architecture Repository Tests', () {
    late MockWalletRepositoryImpl walletRepo;

    setUp(() {
      walletRepo = MockWalletRepositoryImpl();
    });

    test('getWalletBalance returns valid initial balance', () async {
      final wallet = await walletRepo.getWalletBalance('user_1');
      expect(wallet.balance, 15420.50);
      expect(wallet.currency, 'YER');
    });

    test('deposit increases balance correctly', () async {
      final wallet = await walletRepo.deposit(500.0);
      expect(wallet.balance, 15920.50);
    });

    test('withdraw deducts balance correctly', () async {
      final wallet = await walletRepo.withdraw(420.50);
      expect(wallet.balance, 15000.00);
    });

    test('withdraw with insufficient balance throws failure', () async {
      expect(
        () => walletRepo.withdraw(99999999.0),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('Transactions Repository Tests', () {
    late MockTransactionRepositoryImpl txRepo;

    setUp(() {
      txRepo = MockTransactionRepositoryImpl();
    });

    test('getTransactions returns transactions list', () async {
      final list = await txRepo.getTransactions('user_1');
      expect(list.isNotEmpty, true);
    });

    test('createTransfer prepends new transaction', () async {
      final initialCount = (await txRepo.getTransactions('user_1')).length;
      await txRepo.createTransfer('صالح', 1000.0, 'YER');
      final updatedList = await txRepo.getTransactions('user_1');
      expect(updatedList.length, initialCount + 1);
      expect(updatedList.first.title, contains('صالح'));
      expect(updatedList.first.type, TransactionType.transfer);
    });
  });
}
