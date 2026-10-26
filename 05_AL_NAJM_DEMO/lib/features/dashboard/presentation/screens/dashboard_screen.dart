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
  bool _isBalanceHidden = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: Listenable.merge([
        BrandController.instance,
        WalletController.instance,
        TransactionController.instance,
        UserSecurityController.instance,
      ]),
      builder: (context, _) {
        final config = AppConfig.current;
        final brandController = BrandController.instance;
        final wallet = WalletController.instance;
        final txController = TransactionController.instance;
        final secController = UserSecurityController.instance;
        final transactions = txController.transactions.take(6).toList();

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    config.logoAsset,
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: config.primaryColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          config.isAlNajm ? Icons.star_rounded : Icons.account_balance_wallet_rounded,
                          color: config.primaryColor,
                          size: 24,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
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
                                fontSize: 13,
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
                              size: 15,
                              color: AppColors.brandGray,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        config.companyLegalName,
                        style: TextStyle(fontSize: 10.5, color: Colors.grey[600], fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              // زر التبديل الفوري بين النجم بلس والصيفي كاش
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: ElevatedButton.icon(
                  onPressed: () {
                    brandController.toggleBrand();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم التحويل إلى ${AppConfig.current.companyName} بنجاح!'),
                        duration: const Duration(milliseconds: 1400),
                        backgroundColor: AppConfig.current.primaryColor,
                      ),
                    );
                  },
                  icon: Icon(
                    config.isAlNajm ? Icons.swap_horiz_rounded : Icons.star_rate_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text(
                    config.isAlNajm ? 'الصيفي' : 'النجم',
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: config.isAlNajm ? const Color(0xFF183883) : const Color(0xFF9E1B21),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 1,
                  ),
                ),
              ),

              IconButton(
                icon: Icon(Icons.devices_rounded, color: config.primaryColor, size: 22),
                tooltip: 'إدارة الأجهزة',
                onPressed: () => _showDeviceManagementDialog(context, secController),
              ),
              IconButton(
                icon: const Icon(Icons.language_rounded, color: AppColors.brandGray, size: 22),
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
                  // === 1. بطاقة الرصيد متعددة العملات الفاخرة ===
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [config.primaryLightColor, config.primaryColor, config.primaryDarkColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: config.primaryColor.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // عملات المحفظة (YER / SAR / USD)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                _buildCurrencyChip('YER', 'ر.ي', wallet, config),
                                const SizedBox(width: 6),
                                _buildCurrencyChip('SAR', 'ر.س', wallet, config),
                                const SizedBox(width: 6),
                                _buildCurrencyChip('USD', '\$', wallet, config),
                              ],
                            ),
                            IconButton(
                              icon: Icon(
                                _isBalanceHidden ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                color: Colors.white70,
                                size: 20,
                              ),
                              onPressed: () => setState(() => _isBalanceHidden = !_isBalanceHidden),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        Text(
                          '${l10n.translate('available_balance')} (${_getCurrencyName(wallet.selectedCurrency)})',
                          style: const TextStyle(color: Colors.white70, fontSize: 12.5, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              _isBalanceHidden
                                  ? '••••••••'
                                  : NumberFormat('#,##0.00', 'en').format(wallet.balance),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              wallet.selectedCurrency,
                              style: TextStyle(
                                color: config.secondaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // أزرار العمليات الرئيسية السريعة داخل البطاقة
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _openSendTransferDialog(context),
                                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                                label: Text(
                                  config.expressService,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(0.24),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  elevation: 0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _openReceiveTransferDialog(context),
                                icon: const Icon(Icons.download_rounded, color: Colors.white, size: 18),
                                label: const Text(
                                  'استلام حوالة',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(0.24),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  elevation: 0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _openMerchantPayDialog(context),
                                icon: Icon(Icons.qr_code_scanner_rounded, color: config.primaryColor, size: 18),
                                label: Text(
                                  'دفع QR',
                                  style: TextStyle(color: config.primaryColor, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: config.secondaryColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // === 2. شريط أسعار الصرف اللحظية (اليمن) ===
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: config.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.currency_exchange_rounded, color: config.primaryColor, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildRateItem('🇸🇦 1 ريال سعودي', '140.5 شراء', '141.2 بيع', config),
                                const SizedBox(width: 14),
                                Container(width: 1, height: 20, color: Colors.grey[300]),
                                const SizedBox(width: 14),
                                _buildRateItem('🇺🇸 1 دولار أمريكي', '535.0 شراء', '537.0 بيع', config),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.swap_calls_rounded, size: 20),
                          tooltip: 'صرف عملات',
                          color: config.primaryColor,
                          onPressed: () => _openCurrencyExchangeDialog(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // === 3. بطاقة تميمة وهوية الشركة التفاعلية مع الشعارات ===
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentSloganIndex = (_currentSloganIndex + 1) % config.mascotSlogans.length;
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              config.mascotAsset,
                              width: 58,
                              height: 58,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 58,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    color: config.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    config.isAlNajm ? Icons.star_rounded : Icons.shield_rounded,
                                    color: config.secondaryColor,
                                    size: 32,
                                  ),
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
                                    Icon(Icons.auto_awesome, color: config.secondaryColor, size: 15),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${config.companyName} • رفيقك المالي',
                                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.brandGray),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  config.mascotSlogans[_currentSloganIndex % config.mascotSlogans.length],
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                    height: 1.3,
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
                  const SizedBox(height: 20),

                  // === 4. شبكة الخدمات والمصرفية المتكاملة ===
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      l10n.translate('quick_services'),
                      style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                  ),
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                    children: [
                      _buildServiceItem(
                        icon: Icons.send_rounded,
                        label: 'إرسال حوالة',
                        color: config.primaryColor,
                        onTap: () => _openSendTransferDialog(context),
                      ),
                      _buildServiceItem(
                        icon: Icons.download_rounded,
                        label: 'استلام حوالة',
                        color: const Color(0xFF2E7D32),
                        onTap: () => _openReceiveTransferDialog(context),
                      ),
                      _buildServiceItem(
                        icon: Icons.phone_android_rounded,
                        label: 'شحن باقات',
                        color: const Color(0xFFE65100),
                        onTap: () => _openMobileRechargeDialog(context),
                      ),
                      _buildServiceItem(
                        icon: Icons.receipt_long_rounded,
                        label: 'سداد فواتير',
                        color: const Color(0xFF00897B),
                        onTap: () => _openBillPaymentDialog(context),
                      ),
                      _buildServiceItem(
                        icon: Icons.qr_code_scanner_rounded,
                        label: 'دفع مشتريات',
                        color: const Color(0xFF7B1FA2),
                        onTap: () => _openMerchantPayDialog(context),
                      ),
                      _buildServiceItem(
                        icon: Icons.currency_exchange_rounded,
                        label: 'صرف عملات',
                        color: const Color(0xFF1565C0),
                        onTap: () => _openCurrencyExchangeDialog(context),
                      ),
                      _buildServiceItem(
                        icon: Icons.credit_card_rounded,
                        label: 'بطاقة المحفظة',
                        color: const Color(0xFFC2185B),
                        onTap: () => _showVirtualCardDialog(context),
                      ),
                      _buildServiceItem(
                        icon: Icons.location_on_rounded,
                        label: 'فروع وشبكة',
                        color: const Color(0xFF455A64),
                        onTap: () => _showBranchesDialog(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // === 5. أحدث العمليات مع خاصية كشف الحساب وتصدير PDF والسند الإلكتروني ===
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.translate('recent_transactions'),
                        style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
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
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: transactions.length,
                        separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[100]),
                        itemBuilder: (context, index) {
                          final t = transactions[index];
                          final isCredit = t.type == TransactionType.deposit || t.type == TransactionType.receive;

                          return ListTile(
                            onTap: () => _showTransactionReceipt(context, t),
                            leading: CircleAvatar(
                              backgroundColor: isCredit
                                  ? const Color(0xFF2E7D32).withOpacity(0.12)
                                  : config.primaryColor.withOpacity(0.12),
                              child: Icon(
                                isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                                color: isCredit ? const Color(0xFF2E7D32) : config.primaryColor,
                                size: 18,
                              ),
                            ),
                            title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                            subtitle: Row(
                              children: [
                                Text(
                                  DateFormat('yyyy/MM/dd - HH:mm').format(t.date),
                                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text('ناجحة', style: TextStyle(fontSize: 9.5, color: Colors.green, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${isCredit ? '+' : '-'}${NumberFormat('#,##0', 'en').format(t.amount)} ${t.currency}',
                                  style: TextStyle(
                                    color: isCredit ? const Color(0xFF2E7D32) : config.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'عرض السند 📄',
                                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                ),
                              ],
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

  // --- Widgets مساعدة ---
  Widget _buildCurrencyChip(String code, String symbol, WalletController wallet, AppConfig config) {
    final isSelected = wallet.selectedCurrency == code;
    return GestureDetector(
      onTap: () => wallet.selectCurrency(code),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '$symbol $code',
          style: TextStyle(
            color: isSelected ? config.primaryColor : Colors.white,
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getCurrencyName(String code) {
    switch (code) {
      case 'SAR':
        return 'ريال سعودي';
      case 'USD':
        return 'دولار أمريكي';
      default:
        return 'ريال يمني';
    }
  }

  Widget _buildRateItem(String title, String buy, String sell, AppConfig config) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: Colors.green.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
          child: Text(buy, style: const TextStyle(fontSize: 10.5, color: Colors.green, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: Colors.blue.withOpacity(0.12), borderRadius: BorderRadius.circular(4)),
          child: Text(sell, style: const TextStyle(fontSize: 10.5, color: Colors.blue, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildServiceItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // === 1. نافذة إرسال حوالة (نجم إكسبرس / صيفي إكسبرس) ===
  void _openSendTransferDialog(BuildContext context) {
    final config = AppConfig.current;
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final amountController = TextEditingController();
    String transferType = 'person'; // 'person' or 'wallet'

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: Row(
            children: [
              Icon(Icons.send_rounded, color: config.primaryColor),
              const SizedBox(width: 8),
              Text('${config.expressService} - إرسال حوالة', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('حوالة بالاسم والهاتف'),
                        selected: transferType == 'person',
                        onSelected: (val) => setDlgState(() => transferType = 'person'),
                        selectedColor: config.primaryColor.withOpacity(0.15),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('إلى محفظة'),
                        selected: transferType == 'wallet',
                        onSelected: (val) => setDlgState(() => transferType = 'wallet'),
                        selectedColor: config.primaryColor.withOpacity(0.15),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: transferType == 'person' ? 'اسم المستلم الرباعي' : 'رقم حساب المحفظة',
                    prefixIcon: const Icon(Icons.person_rounded),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'رقم هاتف المستلم (لإرسال SMS)',
                    prefixIcon: Icon(Icons.phone_iphone_rounded),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'مبلغ الحوالة',
                    suffixText: WalletController.instance.selectedCurrency,
                    prefixIcon: const Icon(Icons.monetization_on_rounded),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'الشبكة المنفذة: ${config.transferNetworkName} • عمولة التحويل 0 (عرض تجريبي)',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () async {
                final amount = double.tryParse(amountController.text) ?? 0;
                final name = nameController.text.trim();
                if (amount <= 0 || name.isEmpty) return;

                Navigator.pop(ctx);
                final curr = WalletController.instance.selectedCurrency;
                final success = await WalletController.instance.withdraw(amount, curr);
                if (success) {
                  final txNum = 'TX${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
                  final pinCode = (1000 + (DateTime.now().millisecond * 9)).toString().padLeft(4, '0');

                  await TransactionController.instance.recordCustom(
                    title: '${config.expressService} إلى $name',
                    amount: amount,
                    type: TransactionType.transfer,
                    currency: curr,
                  );

                  if (!mounted) return;
                  _showTransferSuccessDialog(context, name, phoneController.text, amount, curr, txNum, pinCode);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: config.primaryColor),
              child: const Text('إرسال الحوالة الآن', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showTransferSuccessDialog(
    BuildContext context,
    String name,
    String phone,
    double amount,
    String curr,
    String txNum,
    String pinCode,
  ) {
    final config = AppConfig.current;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        icon: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 54),
        title: const Text('تم إرسال الحوالة بنجاح!', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _receiptRow('الشبكة:', config.transferNetworkName),
                  _receiptRow('المستلم:', name),
                  _receiptRow('المبلغ:', '${NumberFormat('#,##0').format(amount)} $curr'),
                  _receiptRow('رقم الحوالة:', txNum, isBold: true),
                  _receiptRow('الرمز السري (PIN):', pinCode, isBold: true, color: Colors.red),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'تم إرسال رسالة SMS برقم الحوالة والكود السري إلى $phone لاستلامها فوراً من أي فرع.',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم نسخ بيانات الحوالة بنجاح! 📋')),
              );
            },
            icon: const Icon(Icons.copy_rounded, size: 18),
            label: const Text('نسخ البيانات'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: config.primaryColor),
            child: const Text('تم', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // === 2. نافذة استلام حوالة ===
  void _openReceiveTransferDialog(BuildContext context) {
    final config = AppConfig.current;
    final txNumController = TextEditingController();
    final pinController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Row(
          children: [
            Icon(Icons.download_rounded, color: config.primaryColor),
            const SizedBox(width: 8),
            const Text('استلام حوالة إلى المحفظة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: txNumController,
              decoration: const InputDecoration(
                labelText: 'رقم الحوالة (من 8 إلى 12 رقماً)',
                prefixIcon: Icon(Icons.tag_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'الرمز السري للحوالة (PIN)',
                prefixIcon: Icon(Icons.key_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              if (txNumController.text.isEmpty || pinController.text.isEmpty) return;
              Navigator.pop(ctx);

              // إيداع مبلغ تجريبي 25000 ر.ي
              const amount = 25000.0;
              await WalletController.instance.deposit(amount, 'YER');
              await TransactionController.instance.recordCustom(
                title: 'استلام حوالة رقم ${txNumController.text}',
                amount: amount,
                type: TransactionType.receive,
                currency: 'YER',
              );

              if (!mounted) return;
              showDialog(
                context: context,
                builder: (alertCtx) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  icon: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 50),
                  title: const Text('تم استلام الحوالة وإيداعها!'),
                  content: Text(
                    'تم إيداع مبلغ ${NumberFormat('#,##0').format(amount)} ريال يمني بنجاح في رصيدك عبر ${config.companyName}.',
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(alertCtx), child: const Text('حسناً')),
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: config.primaryColor),
            child: const Text('استلام وإيداع', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // === 3. نافذة شحن رصيد وباقات الاتصالات اليمنية ===
  void _openMobileRechargeDialog(BuildContext context) {
    final config = AppConfig.current;
    final phoneController = TextEditingController(text: '777123456');
    String selectedCarrier = 'يمن موبايل';
    String selectedPackage = 'باقة مزايا ماكس 4G (3500 ر.ي)';
    double price = 3500.0;

    final carriers = ['يمن موبايل', 'يو YOU', 'سبأفون', 'واي Y', 'يمن فورجي 4G'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: const Text('شحن رصيد وباقات اتصالات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedCarrier,
                  decoration: const InputDecoration(labelText: 'شركة الاتصالات'),
                  items: carriers.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setDlgState(() => selectedCarrier = v ?? selectedCarrier),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف المطلوب شحنه',
                    prefixIcon: Icon(Icons.phone_iphone_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedPackage,
                  decoration: const InputDecoration(labelText: 'الباقة المطلوبة'),
                  items: [
                    'باقة مزايا ماكس 4G (3500 ر.ي)',
                    'باقة سوبر نت 15GB (4000 ر.ي)',
                    'رصيد فوري مباشر (1000 ر.ي)',
                    'باقة هدايا دقائق ورسائل (2000 ر.ي)',
                  ].map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 12)))).toList(),
                  onChanged: (v) {
                    setDlgState(() {
                      selectedPackage = v ?? selectedPackage;
                      if (selectedPackage.contains('3500')) price = 3500;
                      if (selectedPackage.contains('4000')) price = 4000;
                      if (selectedPackage.contains('1000')) price = 1000;
                      if (selectedPackage.contains('2000')) price = 2000;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                final success = await WalletController.instance.withdraw(price, 'YER');
                if (success) {
                  await TransactionController.instance.recordCustom(
                    title: 'شحن $selectedCarrier (${phoneController.text})',
                    amount: price,
                    type: TransactionType.withdrawal,
                    currency: 'YER',
                  );
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم شحن $selectedPackage للرقم ${phoneController.text} بنجاح! ⚡'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: config.primaryColor),
              child: const Text('تأكيد السداد', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // === 4. نافذة سداد الفواتير (كهرباء، مياه، هاتف ثابت) ===
  void _openBillPaymentDialog(BuildContext context) {
    final config = AppConfig.current;
    final billType = 'فاتورة الكهرباء والماء';
    final accountController = TextEditingController(text: '882910');
    final amountController = TextEditingController(text: '4500');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('سداد الفواتير والخدمات العامة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: accountController,
              decoration: const InputDecoration(labelText: 'رقم المشترك / العداد', prefixIcon: Icon(Icons.numbers_rounded)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'مبلغ الفاتورة المستحق', suffixText: 'ر.ي', prefixIcon: Icon(Icons.receipt_rounded)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text) ?? 4500;
              Navigator.pop(ctx);
              final success = await WalletController.instance.withdraw(amount, 'YER');
              if (success) {
                await TransactionController.instance.recordCustom(
                  title: 'سداد $billType (حساب ${accountController.text})',
                  amount: amount,
                  type: TransactionType.withdrawal,
                  currency: 'YER',
                );
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم سداد الفاتورة بنجاح وتم توليد إيصال السداد! 💡'), backgroundColor: Colors.green),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: config.primaryColor),
            child: const Text('سداد الفاتورة', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // === 5. نافذة صرف وتداول العملات اللحظي ===
  void _openCurrencyExchangeDialog(BuildContext context) {
    final config = AppConfig.current;
    final wallet = WalletController.instance;
    String fromCurr = 'SAR';
    String toCurr = 'YER';
    final amountController = TextEditingController(text: '500');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) {
          final amt = double.tryParse(amountController.text) ?? 0;
          double rate = fromCurr == 'SAR' ? (wallet.buyRates['SAR_YER'] ?? 140.5) : (wallet.buyRates['USD_YER'] ?? 535.0);
          double result = amt * rate;

          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            title: const Text('صرف وتداول العملات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: fromCurr,
                      items: ['SAR', 'USD'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (v) => setDlgState(() => fromCurr = v ?? fromCurr),
                    ),
                    const Icon(Icons.arrow_forward_rounded),
                    const Text('YER (ريال يمني)', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'المبلغ المراد تحويله',
                    suffixText: fromCurr,
                    prefixIcon: const Icon(Icons.monetization_on_rounded),
                  ),
                  onChanged: (_) => setDlgState(() {}),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('سعر الصرف المعتمد:', style: TextStyle(fontSize: 12)),
                          Text('1 $fromCurr = $rate YER', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('المبلغ المستلم:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(
                            '${NumberFormat('#,##0.00').format(result)} YER',
                            style: TextStyle(fontWeight: FontWeight.bold, color: config.primaryColor, fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
              ElevatedButton(
                onPressed: () async {
                  if (amt <= 0) return;
                  Navigator.pop(ctx);
                  final success = await wallet.exchangeCurrency(fromCurrency: fromCurr, toCurrency: toCurr, fromAmount: amt);
                  if (success) {
                    await TransactionController.instance.recordCustom(
                      title: 'صرف عملة: $amt $fromCurr إلى YER',
                      amount: result,
                      type: TransactionType.deposit,
                      currency: 'YER',
                    );
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم صرف $amt $fromCurr وإيداع $result ر.ي بنجاح! 💱'), backgroundColor: Colors.green),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: config.primaryColor),
                child: const Text('تأكيد الصرف', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  // === 6. نافذة دفع المشتريات الذكية مع التعرف على نوع النشاط ===
  void _openMerchantPayDialog(BuildContext context) {
    final config = AppConfig.current;
    final merchantNameController = TextEditingController(text: 'صيدلية النور الحديثة');
    final amountController = TextEditingController(text: '3500');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.storefront_rounded, color: config.primaryColor),
            const SizedBox(width: 8),
            const Text('دفع مشتريات للمتاجر بنقاط البيع', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: merchantNameController,
              decoration: const InputDecoration(
                labelText: 'اسم المتجر / الصيدلية / المطعم',
                prefixIcon: Icon(Icons.business_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'مبلغ الفاتورة',
                suffixText: WalletController.instance.selectedCurrency,
                prefixIcon: const Icon(Icons.monetization_on_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              final merchantName = merchantNameController.text.trim();
              final amount = double.tryParse(amountController.text) ?? 0;
              if (merchantName.isEmpty || amount <= 0) return;

              Navigator.pop(ctx);
              final curr = WalletController.instance.selectedCurrency;
              final success = await WalletController.instance.withdraw(amount, curr);
              if (success) {
                await TransactionController.instance.recordCustom(
                  title: 'دفع مشتريات - $merchantName',
                  amount: amount,
                  type: TransactionType.withdrawal,
                  currency: curr,
                );

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
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(alertCtx), child: const Text('حفظ الإشعار')),
                    ],
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: config.primaryColor),
            child: const Text('تأكيد الدفع', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // === 7. نافذة عرض السند البنكي الإلكتروني التفصيلي ===
  void _showTransactionReceipt(BuildContext context, TransactionEntity t) {
    final config = AppConfig.current;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 16),
            Image.asset(config.logoAsset, height: 42, fit: BoxFit.contain),
            const SizedBox(height: 8),
            Text(config.companyLegalName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text('سند قيد وتحويل إلكتروني معتمد', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            const Divider(height: 24),
            _receiptRow('نوع العملية:', t.title),
            _receiptRow('المرجع البنكي:', t.id),
            _receiptRow('التاريخ والوقت:', DateFormat('yyyy/MM/dd HH:mm:ss').format(t.date)),
            _receiptRow('المبلغ:', '${NumberFormat('#,##0.00').format(t.amount)} ${t.currency}', isBold: true),
            _receiptRow('الشبكة:', config.transferNetworkName),
            _receiptRow('الحالة:', 'مكتملة ومقيدة بالدفاتر البنكية', color: Colors.green),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تصدير وحفظ السند بصيغة PDF 📄')));
                    },
                    icon: const Icon(Icons.picture_as_pdf_rounded),
                    label: const Text('حفظ PDF'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت مشاركة سند العملية بنجاح! 📤')));
                    },
                    icon: const Icon(Icons.share_rounded, color: Colors.white),
                    label: const Text('مشاركة السند', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: config.primaryColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _receiptRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12.5, color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color ?? const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  // === 8. نافذة البطاقة الافتراضية ===
  void _showVirtualCardDialog(BuildContext context) {
    final config = AppConfig.current;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text('${config.companyName} - بطاقة الدفع الرقمية', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        content: Container(
          width: 320,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [config.primaryDarkColor, config.primaryColor, config.secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(color: config.primaryColor.withOpacity(0.4), blurRadius: 14, offset: const Offset(0, 6)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(config.companyName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  const Icon(Icons.nfc_rounded, color: Colors.white, size: 24),
                ],
              ),
              const SizedBox(height: 20),
              const Text('4152  ••••  ••••  8910', style: TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 2, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('EXP: 10/28', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  Text('CVV: •••', style: TextStyle(color: Colors.white70, fontSize: 11)),
                  Text('VISA / MADA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إغلاق')),
        ],
      ),
    );
  }

  // === 9. نافذة الفروع والصرافات ===
  void _showBranchesDialog(BuildContext context) {
    final config = AppConfig.current;
    final branches = [
      'الفرع الرئيسي: صنعاء - شارع الزبيري',
      'فرع حدة: صنعاء - جولة الرويشان',
      'فرع عدن: كريتر - شارع أروى',
      'فرع تعز: شارع جمال عبدالناصر',
      'فرع المكلا: الشارع العام - خور المكلا',
      'فرع إب: الدائري الغربي',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('شبكة فروع ومراكز خدمة ${config.companyLegalName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),
            ...branches.map((b) => ListTile(
                  dense: true,
                  leading: Icon(Icons.location_on_rounded, color: config.primaryColor),
                  title: Text(b, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  trailing: const Text('مفتوح الآن', style: TextStyle(fontSize: 11, color: Colors.green)),
                )),
          ],
        ),
      ),
    );
  }

  // === 10. تصدير كشف الحساب الشهري PDF ===
  void _showExportPdfStatementDialog(BuildContext context) {
    final config = AppConfig.current;
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
            Text('تحميل كشف مالي مفصل ومختوم من ${config.companyLegalName}:'),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: selectedYear,
              decoration: const InputDecoration(labelText: 'السنة'),
              items: [2025, 2026].map((y) => DropdownMenuItem(value: y, child: Text('$y'))).toList(),
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
                  content: Text('تم إنشاء وتنزيل كشف حساب شهر $selectedMonth / $selectedYear بنجاح! 📄'),
                  backgroundColor: const Color(0xFF2E7D32),
                ),
              );
            },
            icon: const Icon(Icons.download_rounded, color: Colors.white),
            label: const Text('تنزيل الملف', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: config.primaryColor),
          ),
        ],
      ),
    );
  }

  // === 11. إدارة الأجهزة المتصلة ===
  void _showDeviceManagementDialog(BuildContext context, UserSecurityController sec) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('الأجهزة المسجلة بالحساب', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'الأجهزة النشطة: ${sec.activeDevices.length}/${UserSecurityController.maxConcurrentDevices} (الحد التراكمي: ${sec.totalHistoricalDeviceCount}/${UserSecurityController.maxHistoricalDevices})',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 14),
            ...sec.activeDevices.map((dev) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: dev.isCurrent ? Colors.green.withOpacity(0.15) : Colors.grey.withOpacity(0.15),
                    child: Icon(
                      Icons.smartphone_rounded,
                      color: dev.isCurrent ? Colors.green : Colors.grey[700],
                    ),
                  ),
                  title: Text(dev.deviceName, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                  subtitle: Text('${dev.model} • ${dev.isCurrent ? "الجهاز الحالي" : "نشط"}', style: const TextStyle(fontSize: 11)),
                  trailing: dev.isCurrent
                      ? const Chip(label: Text('الحالي', style: TextStyle(fontSize: 10.5, color: Colors.green)))
                      : IconButton(
                          icon: const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
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
          ],
        ),
      ),
    );
  }
}
