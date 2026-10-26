import 'package:flutter/material.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionDetailsScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Details')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Icon(
            transaction.type == 'DEPOSIT' || transaction.type == 'RECEIVE'
                ? Icons.arrow_downward
                : Icons.arrow_upward,
            size: 64,
            color: transaction.type == 'DEPOSIT' || transaction.type == 'RECEIVE'
                ? Colors.green
                : Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            '${transaction.amount.toStringAsFixed(2)} ${transaction.currency}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          _buildDetailRow('Status', transaction.status),
          const Divider(),
          _buildDetailRow('Type', transaction.type),
          const Divider(),
          _buildDetailRow('Date', transaction.date.toString()),
          const Divider(),
          _buildDetailRow('Reference', transaction.id),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
