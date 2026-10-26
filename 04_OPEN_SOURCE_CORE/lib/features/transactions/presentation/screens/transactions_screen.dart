import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/localization/app_localizations.dart';
import '../controllers/transaction_controller.dart';
import '../../domain/entities/transaction_entity.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final config = AppConfig.current;

    return AnimatedBuilder(
      animation: TransactionController.instance,
      builder: (context, _) {
        final txController = TransactionController.instance;
        final transactions = txController.transactions.where((t) {
          if (_searchQuery.isEmpty) return true;
          return t.title.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              l10n.translate('transactions'),
              style: const TextStyle(color: Color(0xFF212529), fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: l10n.translate('search_transactions'),
                    prefixIcon: Icon(Icons.search, color: config.primaryColor),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
              Expanded(
                child: transactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long_rounded, size: 64, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text(
                              l10n.translate('no_transactions'),
                              style: const TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        color: config.primaryColor,
                        onRefresh: () => txController.loadTransactions(),
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: transactions.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final t = transactions[index];
                            final isCredit = t.type == TransactionType.deposit || t.type == TransactionType.receive;

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: isCredit
                                      ? const Color(0xFF2E7D32).withOpacity(0.1)
                                      : config.primaryColor.withOpacity(0.1),
                                  child: Icon(
                                    isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                                    color: isCredit ? const Color(0xFF2E7D32) : config.primaryColor,
                                    size: 20,
                                  ),
                                ),
                                title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                                subtitle: Text(
                                  DateFormat('yyyy/MM/dd - HH:mm').format(t.date),
                                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                ),
                                trailing: Text(
                                  '${isCredit ? '+' : '-'}${NumberFormat('#,##0', 'en').format(t.amount)} ${l10n.translate('currency')}',
                                  style: TextStyle(
                                    color: isCredit ? const Color(0xFF2E7D32) : config.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
