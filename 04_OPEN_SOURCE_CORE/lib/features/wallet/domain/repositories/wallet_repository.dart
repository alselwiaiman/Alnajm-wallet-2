import '../entities/wallet_entity.dart';

abstract class WalletRepository {
  Future<WalletEntity> getWalletBalance(String userId);
  Future<WalletEntity> deposit(double amount);
  Future<WalletEntity> withdraw(double amount);
  Future<WalletEntity> sendMoney(double amount, String recipient);
  Future<WalletEntity> receiveMoney(double amount, String sender);
}
