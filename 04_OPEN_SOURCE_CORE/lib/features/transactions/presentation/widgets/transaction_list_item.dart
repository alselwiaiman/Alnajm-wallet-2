import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionEntity transaction;
  final VoidCallback onTap;

  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.type == TransactionType.deposit || transaction.type == TransactionType.receive;
    final amountColor = isPositive ? Colors.green : Colors.black87;
    final prefix = isPositive ? '+' : '-';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withOpacity(0.08),
        child: Icon(
          _getIconForType(transaction.type),
          color: AppColors.primary,
        ),
      ),
      title: Text(transaction.title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(_formatDate(transaction.date)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$prefix${transaction.amount.toStringAsFixed(2)} ${transaction.currency}',
            style: TextStyle(color: amountColor, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          if (transaction.status == TransactionStatus.pending)
            const Text('قيد الانتظار', style: TextStyle(color: Colors.orange, fontSize: 12)),
        ],
      ),
      onTap: onTap,
    );
  }

  IconData _getIconForType(TransactionType type) {
    switch (type) {
      case TransactionType.deposit:
        return Icons.account_balance;
      case TransactionType.withdrawal:
        return Icons.shopping_cart;
      case TransactionType.transfer:
        return Icons.arrow_outward;
      case TransactionType.receive:
        return Icons.call_received;
    }
  }

  String _formatDate(DateTime date) {
    // Simple format for demo purposes
    return '${date.day}/${date.month}/${date.year}';
  }
}
