import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<List<TransactionEntity>> getTransactions(String userId);
  Future<TransactionEntity> getTransactionDetails(String transactionId);
  Future<void> createTransfer(String recipientId, double amount, String currency);
}
