import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/localization/app_localizations.dart';
import '../controllers/wallet_controller.dart';
import '../../../transactions/presentation/controllers/transaction_controller.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';
import 'package:intl/intl.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _amountController = TextEditingController();
  final _recipientController = TextEditingController();

  void _performAction(String actionType, String actionLabel, bool isDeduction) {
    final l10n = AppLocalizations.of(context);
    final config = AppConfig.current;
    final List<int> quickAmounts = [2000, 3000, 5000, 10000];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    actionLabel,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (actionType == 'send')
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextField(
                    controller: _recipientController,
                    decoration: InputDecoration(
                      labelText: l10n.translate('recipient_name'),
                      prefixIcon: const Icon(Icons.person_outline),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: l10n.translate('amount'),
                  suffixText: l10n.translate('currency'),
                  prefixIcon: const Icon(Icons.monetization_on_outlined),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Text(l10n.translate('quick_amount'), style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              Row(
                children: quickAmounts.map((amount) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: OutlinedButton(
                        onPressed: () {
                          _amountController.text = amount.toString();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: config.primaryColor),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          NumberFormat('#,##0', 'en').format(amount),
                          style: TextStyle(color: config.primaryColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('العملية', style: TextStyle(color: Colors.grey)),
                        Text(actionLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.translate('fee'), style: const TextStyle(color: Colors.grey)),
                        Text(l10n.translate('free_fee'), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(l10n.translate('cancel')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final amount = double.tryParse(_amountController.text) ?? 0;
                        final person = _recipientController.text.trim();
                        final wallet = WalletController.instance;
                        final txController = TransactionController.instance;

                        bool success = false;
                        if (actionType == 'deposit') {
                          success = await wallet.deposit(amount);
                          if (success) {
                            await txController.recordCustom(
                              title: 'إيداع نقدي',
                              amount: amount,
                              type: TransactionType.deposit,
                            );
                          }
                        } else if (actionType == 'withdraw') {
                          success = await wallet.withdraw(amount);
                          if (success) {
                            await txController.recordCustom(
                              title: 'سحب نقدي',
                              amount: amount,
                              type: TransactionType.withdrawal,
                            );
                          }
                        } else if (actionType == 'send') {
                          final recipientName = person.isEmpty ? 'مستلم' : person;
                          success = await wallet.sendMoney(amount, recipientName);
                          if (success) {
                            await txController.recordCustom(
                              title: 'تحويل إلى $recipientName',
                              amount: amount,
                              type: TransactionType.transfer,
                            );
                          }
                        } else if (actionType == 'receive') {
                          final senderName = person.isEmpty ? 'مرسل' : person;
                          success = await wallet.receiveMoney(amount, senderName);
                          if (success) {
                            await txController.recordCustom(
                              title: 'استلام من $senderName',
                              amount: amount,
                              type: TransactionType.receive,
                            );
                          }
                        }

                        if (!mounted) return;
                        Navigator.pop(context);

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.translate('operation_success')),
                              backgroundColor: const Color(0xFF2E7D32),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(wallet.errorMessage ?? l10n.translate('invalid_amount')),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }

                        _amountController.clear();
                        _recipientController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: config.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        l10n.translate('execute'),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final config = AppConfig.current;

    return AnimatedBuilder(
      animation: WalletController.instance,
      builder: (context, _) {
        final wallet = WalletController.instance;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(l10n.translate('wallet'), style: const TextStyle(color: Color(0xFF212529), fontWeight: FontWeight.bold)),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [config.primaryLightColor, config.primaryDarkColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: config.primaryColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(l10n.translate('available_balance'), style: const TextStyle(color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 8),
                      Text(
                        '${NumberFormat('#,##0.00', 'en').format(wallet.balance)} ${l10n.translate('currency')}',
                        style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _buildActionCard(Icons.send_rounded, l10n.translate('transfer'), config.primaryColor, () {
                        _performAction('send', l10n.translate('transfer'), true);
                      }),
                      _buildActionCard(Icons.call_received_rounded, l10n.translate('receive'), const Color(0xFF2E7D32), () {
                        _performAction('receive', l10n.translate('receive'), false);
                      }),
                      _buildActionCard(Icons.add_circle_rounded, l10n.translate('deposit'), const Color(0xFFF57C00), () {
                        _performAction('deposit', l10n.translate('deposit'), false);
                      }),
                      _buildActionCard(Icons.money_off_rounded, l10n.translate('withdraw'), const Color(0xFF1565C0), () {
                        _performAction('withdraw', l10n.translate('withdraw'), true);
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionCard(IconData icon, String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF212529))),
          ],
        ),
      ),
    );
  }
}
