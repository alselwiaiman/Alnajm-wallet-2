import '../../../../core/errors/failures.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../models/transaction_model.dart';

class MockTransactionRepositoryImpl implements TransactionRepository {
  final List<TransactionEntity> _transactions = [
    TransactionModel(
      id: 'tx_1',
      title: 'إيداع نقدي',
      amount: 10000.00,
      currency: 'YER',
      date: DateTime.now().subtract(const Duration(days: 3)),
      type: TransactionType.deposit,
      status: TransactionStatus.completed,
    ),
    TransactionModel(
      id: 'tx_2',
      title: 'تحويل إلى أحمد',
      amount: 3000.00,
      currency: 'YER',
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: TransactionType.transfer,
      status: TransactionStatus.completed,
    ),
    TransactionModel(
      id: 'tx_3',
      title: 'استلام من محمد',
      amount: 5000.00,
      currency: 'YER',
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: TransactionType.receive,
      status: TransactionStatus.completed,
    ),
    TransactionModel(
      id: 'tx_4',
      title: 'سداد فاتورة كهرباء',
      amount: 1500.00,
      currency: 'YER',
      date: DateTime.now().subtract(const Duration(hours: 12)),
      type: TransactionType.withdrawal,
      status: TransactionStatus.completed,
    ),
    TransactionModel(
      id: 'tx_5',
      title: 'شحن رصيد باقة',
      amount: 4920.50,
      currency: 'YER',
      date: DateTime.now().subtract(const Duration(hours: 5)),
      type: TransactionType.deposit,
      status: TransactionStatus.completed,
    ),
  ];

  @override
  Future<List<TransactionEntity>> getTransactions(String userId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.from(_transactions)..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<TransactionEntity> getTransactionDetails(String transactionId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final item = _transactions.firstWhere(
      (element) => element.id == transactionId,
      orElse: () => throw const ServerFailure('العملية غير موجودة'),
    );
    return item;
  }

  @override
  Future<void> createTransfer(String recipientId, double amount, String currency) async {
    if (amount <= 0) {
      throw const InvalidAmountFailure('المبلغ المدخل غير صالح');
    }
    await Future.delayed(const Duration(milliseconds: 400));
    _transactions.insert(
      0,
      TransactionModel(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        title: 'تحويل إلى $recipientId',
        amount: amount,
        currency: currency,
        date: DateTime.now(),
        type: TransactionType.transfer,
        status: TransactionStatus.completed,
      ),
    );
  }

  Future<void> recordTransaction({
    required String title,
    required double amount,
    required TransactionType type,
    String currency = 'YER',
  }) async {
    _transactions.insert(
      0,
      TransactionModel(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        amount: amount,
        currency: currency,
        date: DateTime.now(),
        type: type,
        status: TransactionStatus.completed,
      ),
    );
  }
}
