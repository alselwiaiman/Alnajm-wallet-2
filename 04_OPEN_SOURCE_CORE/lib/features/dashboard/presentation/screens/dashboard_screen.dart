import 'package:flutter/material.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/user_security_controller.dart';
import '../../../wallet/presentation/controllers/wallet_controller.dart';
import '../../../transactions/presentation/controllers/transaction_controller.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentSloganIndex = 0;
  final List<String> _mascotSlogans = [
    'النجم خيارك الأمثل والأسرع دائماً ⭐',
    'أموالك بأمان واطمئنان مع النجم بلس 🛡️',
    'أسرع شبكة تحويلات مصرفية في اليمن 🚀',
    'النجم بلس.. تميّز في كل خطوة وحوالة ✨',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final config = AppConfig.current;

    return AnimatedBuilder(
      animation: Listenable.merge([
        WalletController.instance,
        TransactionController.instance,
        UserSecurityController.instance,
      ]),
      builder: (context, _) {
        final wallet = WalletController.instance;
        final txController = TransactionController.instance;
        final secController = UserSecurityController.instance;
        final transactions = txController.transactions.take(5).toList();

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    config.logoAsset,
                    height: 42,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: config.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.star, color: config.secondaryColor, size: 24),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              secController.profile.displayName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => secController.toggleHideName(),
                            child: Icon(
                              secController.profile.hideRealName ? Icons.visibility_off : Icons.visibility,
                              size: 16,
                              color: AppColors.brandGray,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        config.companyLegalName,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.devices_rounded, color: AppColors.primary),
                tooltip: 'إدارة الأجهزة',
                onPressed: () => _showDeviceManagementDialog(context, secController),
              ),
              IconButton(
                icon: const Icon(Icons.language_rounded, color: AppColors.brandGray),
                onPressed: () => LocaleController.instance.toggleLocale(),
              ),
            ],
          ),
          body: RefreshIndicator(
            color: config.primaryColor,
            onRefresh: () async {
              await wallet.loadBalance();
              await txController.loadTransactions();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // === 1. بطاقة الرصيد الفاخرة المستوحاة من فلوسك و جيب ===
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [config.primaryLightColor, config.primaryColor, config.primaryDarkColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: config.primaryColor.withOpacity(0.32),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.translate('available_balance'),
                              style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                l10n.translate('currency'),
                                style: TextStyle(
                                  color: config.secondaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          NumberFormat('#,##0.00', 'en').format(wallet.balance),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _openMerchantPayDialog(context),
                                icon: const Icon(Icons.storefront_rounded, color: Colors.white, size: 20),
                                label: const Text(
                                  'دفع مشتريات',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(0.25),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(vertical: 11),
                                  elevation: 0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(l10n.translate('scan_qr'))),
                                  );
                                },
                                icon: Icon(Icons.qr_code_scanner_rounded, color: config.primaryColor, size: 20),
                                label: Text(
                                  l10n.translate('scan_qr'),
                                  style: TextStyle(
                                    color: config.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: config.secondaryColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(vertical: 11),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // === 2. المربع المخصص لشخصية النجم الفاخرة مع الشعارات التفاعلية ===
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentSloganIndex = (_currentSloganIndex + 1) % _mascotSlogans.length;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: config.secondaryColor.withOpacity(0.35), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // صورة شخصية النجم الرسمية
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/alnajm_mascot.png',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: config.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.star, color: config.secondaryColor, size: 36),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.auto_awesome, color: config.secondaryColor, size: 16),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'رفيقك المالي الذكي',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.brandGray),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _mascotSlogans[_currentSloganIndex],
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.touch_app_rounded, color: Colors.grey[400], size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // === 3. شبكة الخدمات السريعة بنمط واجهة فلوسك وجيب ===
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      l10n.translate('quick_services'),
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                  ),
                  Row(
                    children: [
                      _buildQuickActionItem(context, Icons.send_rounded, l10n.translate('transfer'), config.primaryColor),
                      const SizedBox(width: 10),
                      _buildQuickActionItem(context, Icons.receipt_long_rounded, l10n.translate('pay'), const Color(0xFFF57C00)),
                      const SizedBox(width: 10),
                      _buildQuickActionItem(context, Icons.account_balance_wallet_rounded, l10n.translate('deposit'), const Color(0xFF2E7D32)),
                      const SizedBox(width: 10),
                      _buildQuickActionItem(context, Icons.money_off_rounded, l10n.translate('withdraw'), const Color(0xFF1565C0)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // === 4. أحدث العمليات مع خاصية كشف الحساب وتصدير PDF ===
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.translate('recent_transactions'),
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      TextButton.icon(
                        onPressed: () => _showExportPdfStatementDialog(context),
                        icon: const Icon(Icons.picture_as_pdf_rounded, size: 16),
                        label: const Text('كشف PDF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        style: TextButton.styleFrom(foregroundColor: config.primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (transactions.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(l10n.translate('no_transactions'), style: const TextStyle(color: Colors.grey)),
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: transactions.length,
                        separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[200]),
                        itemBuilder: (context, index) {
                          final t = transactions[index];
                          final isCredit = t.type == TransactionType.deposit || t.type == TransactionType.receive;

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isCredit
                                  ? const Color(0xFF2E7D32).withOpacity(0.1)
                                  : config.primaryColor.withOpacity(0.1),
                              child: Icon(
                                isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                                color: isCredit ? const Color(0xFF2E7D32) : config.primaryColor,
                                size: 18,
                              ),
                            ),
                            title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            subtitle: Text(
                              DateFormat('yyyy/MM/dd - HH:mm').format(t.date),
                              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                            ),
                            trailing: Text(
                              '${isCredit ? '+' : '-'}${NumberFormat('#,##0', 'en').format(t.amount)} ${l10n.translate('currency')}',
                              style: TextStyle(
                                color: isCredit ? const Color(0xFF2E7D32) : config.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionItem(BuildContext context, IconData icon, String label, Color color) {
    return Expanded(
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label - تجريبي')),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // === نافذة دفع المشتريات الذكية مع التعرف على نوع النشاط ===
  void _openMerchantPayDialog(BuildContext context) {
    final merchantNameController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.storefront_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text('دفع مشتريات للمتاجر', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: merchantNameController,
              decoration: const InputDecoration(
                labelText: 'اسم المتجر / الصيدلية / المطعم',
                hintText: 'مثال: صيدلية الأمل، مطعم الشيباني',
                prefixIcon: Icon(Icons.business_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'مبلغ الفاتورة',
                suffixText: 'ر.ي',
                prefixIcon: Icon(Icons.monetization_on_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              final merchantName = merchantNameController.text.trim();
              final amount = double.tryParse(amountController.text) ?? 0;
              if (merchantName.isEmpty || amount <= 0) return;

              Navigator.pop(ctx);
              final success = await WalletController.instance.withdraw(amount);
              if (success) {
                await TransactionController.instance.recordCustom(
                  title: 'دفع مشتريات - $merchantName',
                  amount: amount,
                  type: TransactionType.withdrawal,
                );

                // كشف فئة المتجر وإرسال الإشعار الذكي
                final category = UserSecurityController.detectCategory(merchantName);
                final greeting = UserSecurityController.getContextualGreeting(merchantName, category);

                if (!mounted) return;
                showDialog(
                  context: context,
                  builder: (alertCtx) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    icon: Icon(
                      category == MerchantCategory.medical ? Icons.health_and_safety_rounded : Icons.check_circle_rounded,
                      color: category == MerchantCategory.medical ? Colors.red : Colors.green,
                      size: 48,
                    ),
                    title: const Text('تم الدفع بنجاح!'),
                    content: Text(
                      greeting,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(alertCtx),
                        child: const Text('حفظ الإشعار'),
                      ),
                    ],
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('تأكيد الدفع', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // === نافذة تصدير كشف الحساب الشهري PDF ===
  void _showExportPdfStatementDialog(BuildContext context) {
    int selectedYear = 2026;
    int selectedMonth = 10;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('تصدير كشف حساب PDF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('اختر السنة والشهر لتحميل الكشف المالي المفصل:'),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: selectedYear,
              decoration: const InputDecoration(labelText: 'السنة'),
              items: [2024, 2025, 2026].map((y) => DropdownMenuItem(value: y, child: Text('$y'))).toList(),
              onChanged: (v) => selectedYear = v ?? 2026,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: selectedMonth,
              decoration: const InputDecoration(labelText: 'الشهر'),
              items: List.generate(12, (i) => i + 1)
                  .map((m) => DropdownMenuItem(value: m, child: Text('شهر $m')))
                  .toList(),
              onChanged: (v) => selectedMonth = v ?? 10,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم توليد كشف الحساب لشهر $selectedMonth / $selectedYear وتنزيله بصيغة PDF بنجاح! 📄'),
                  backgroundColor: const Color(0xFF2E7D32),
                ),
              );
            },
            icon: const Icon(Icons.download_rounded, color: Colors.white),
            label: const Text('تنزيل الملف', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          ),
        ],
      ),
    );
  }

  // === نافذة إدارة الأجهزة المتصلة ===
  void _showDeviceManagementDialog(BuildContext context, UserSecurityController sec) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('الأجهزة المسجلة بالحساب', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'الأجهزة النشطة: ${sec.activeDevices.length}/${UserSecurityController.maxConcurrentDevices} (الحد الأقصى التراكمي: ${sec.totalHistoricalDeviceCount}/${UserSecurityController.maxHistoricalDevices})',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ...sec.activeDevices.map((dev) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: dev.isCurrent ? Colors.green.withOpacity(0.15) : Colors.grey.withOpacity(0.15),
                      child: Icon(
                        Icons.smartphone_rounded,
                        color: dev.isCurrent ? Colors.green : Colors.grey[700],
                      ),
                    ),
                    title: Text(dev.deviceName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text('${dev.model} • ${dev.isCurrent ? "الجهاز الحالي" : "نشط"}', style: const TextStyle(fontSize: 12)),
                    trailing: dev.isCurrent
                        ? const Chip(label: Text('الحالي', style: TextStyle(fontSize: 11, color: Colors.green)))
                        : IconButton(
                            icon: const Icon(Icons.logout_rounded, color: Colors.red),
                            tooltip: 'إخراج الجهاز',
                            onPressed: () {
                              sec.terminateDeviceSession(dev.deviceId);
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('تم إخراج ${dev.deviceName} من الحساب بنجاح')),
                              );
                            },
                          ),
                  )),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
