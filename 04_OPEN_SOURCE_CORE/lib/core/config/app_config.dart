import 'package:flutter/material.dart';

enum WalletTier {
  demo,
  essential,
  professional,
  enterprise,
}

/// Configuration class representing the white-label and tiered settings of the wallet platform.
class AppConfig {
  final WalletTier tier;
  final String companyName;
  final String companyLegalName;
  final String logoAsset;
  final String iconAsset;
  final Color primaryColor;
  final Color primaryDarkColor;
  final Color primaryLightColor;
  final Color secondaryColor;
  final Color accentColor;
  final String defaultCurrency;
  final List<String> supportedCurrencies;
  final bool isDemoMode;
  final String supportPhone;
  final String supportEmail;
  final List<String> enabledFeatures;

  const AppConfig({
    required this.tier,
    required this.companyName,
    required this.companyLegalName,
    required this.logoAsset,
    required this.iconAsset,
    required this.primaryColor,
    required this.primaryDarkColor,
    required this.primaryLightColor,
    required this.secondaryColor,
    required this.accentColor,
    this.defaultCurrency = 'YER',
    this.supportedCurrencies = const ['YER', 'SAR', 'USD'],
    this.isDemoMode = true,
    this.supportPhone = '8000004',
    this.supportEmail = 'care@alnajm.com',
    required this.enabledFeatures,
  });

  bool hasFeature(String feature) => enabledFeatures.contains(feature);

  /// Official Al-Najm Plus Configuration
  factory AppConfig.alNajm() {
    return const AppConfig(
      tier: WalletTier.demo,
      companyName: 'النجم بلس',
      companyLegalName: 'شركة النجم للحوالات والصرافة',
      logoAsset: 'assets/images/alnajm_plus_logo.png',
      iconAsset: 'assets/images/app_icon_luxury.png',
      primaryColor: Color(0xFF9E1B21),
      primaryDarkColor: Color(0xFF7A1015),
      primaryLightColor: Color(0xFFB8282E),
      secondaryColor: Color(0xFFF59E0B),
      accentColor: Color(0xFFFBBF24),
      defaultCurrency: 'YER',
      isDemoMode: true,
      enabledFeatures: [
        'wallet',
        'transactions',
        'send_demo',
        'receive_demo',
        'qr_scan_demo',
        'profile',
      ],
    );
  }

  /// Generic White-Label Configuration for Open Source Core
  factory AppConfig.generic() {
    return const AppConfig(
      tier: WalletTier.essential,
      companyName: 'Open Wallet',
      companyLegalName: 'Open Source Digital Wallet Platform',
      logoAsset: 'assets/images/alnajm_plus_logo.png',
      iconAsset: 'assets/images/app_icon_luxury.png',
      primaryColor: Color(0xFF1E3A8A),
      primaryDarkColor: Color(0xFF172554),
      primaryLightColor: Color(0xFF2563EB),
      secondaryColor: Color(0xFF0D9488),
      accentColor: Color(0xFF14B8A6),
      defaultCurrency: 'USD',
      supportedCurrencies: ['USD', 'EUR', 'GBP'],
      isDemoMode: false,
      enabledFeatures: [
        'wallet',
        'transactions',
        'deposit',
        'withdraw',
        'send_money',
        'receive_money',
        'profile',
      ],
    );
  }

  /// 1. Demo Tier (نسخة العرض للشركة - مميزات أساسية استعراضية)
  factory AppConfig.demo() => AppConfig.alNajm();


  /// 2. Essential Tier (الباقة الأساسية $10K - المميزات الأساسية فقط)
  factory AppConfig.essential() {
    return const AppConfig(
      tier: WalletTier.essential,
      companyName: 'النجم الأساسية',
      companyLegalName: 'شركة النجم للحوالات المالية (الباقة الأساسية)',
      logoAsset: 'assets/images/alnajm_plus_logo.png',
      iconAsset: 'assets/images/app_icon_luxury.png',
      primaryColor: Color(0xFF9E1B21),
      primaryDarkColor: Color(0xFF7A1015),
      primaryLightColor: Color(0xFFB8282E),
      secondaryColor: Color(0xFFF59E0B),
      accentColor: Color(0xFFFBBF24),
      isDemoMode: false,
      enabledFeatures: [
        'wallet',
        'transactions',
        'deposit',
        'withdraw',
        'send_money',
        'receive_money',
        'basic_kyc',
        'basic_security',
        'profile',
        'notifications',
      ],
    );
  }

  /// 3. Professional Tier (الباقة المتوسطة $15K - الأساسية + كل مميزات محفظة جيب)
  factory AppConfig.professional() {
    return const AppConfig(
      tier: WalletTier.professional,
      companyName: 'النجم الاحترافية',
      companyLegalName: 'شركة النجم للحوالات والصرافة (الباقة الاحترافية)',
      logoAsset: 'assets/images/alnajm_plus_logo.png',
      iconAsset: 'assets/images/app_icon_luxury.png',
      primaryColor: Color(0xFF9E1B21),
      primaryDarkColor: Color(0xFF7A1015),
      primaryLightColor: Color(0xFFB8282E),
      secondaryColor: Color(0xFFF59E0B),
      accentColor: Color(0xFFFBBF24),
      isDemoMode: false,
      enabledFeatures: [
        // المميزات الأساسية
        'wallet',
        'transactions',
        'deposit',
        'withdraw',
        'send_money',
        'receive_money',
        'basic_kyc',
        'basic_security',
        'profile',
        'notifications',
        // مميزات محفظة جيب الإضافية
        'jeeb_bill_payments',          // سداد فواتير الكهرباء، الماء، الإنترنت والهواتف
        'jeeb_mobile_recharge',        // شحن رصيد وباقات الهاتف يمن موبايل، سبأفون، يو، واي
        'jeeb_qr_merchant_pay',        // الدفع للمتاجر ونقاط البيع برمز QR
        'jeeb_multi_currency',         // صرف وتحويل العملات (ريال يمني، ريال سعودي، دولار)
        'jeeb_bank_transfers',         // تحويل إلى الحسابات البنكية والمحافظ الأخرى
        'jeeb_beneficiaries',          // إدارة جهات الاتصال والمستفيدين المفضلين
        'jeeb_virtual_cards',          // بطاقات الدفع الافتراضية للتسوق الإلكتروني
        'jeeb_detailed_statements',    // كشوفات حساب مفصلة مع تصدير PDF/Excel
      ],
    );
  }

  /// 4. Enterprise Tier (أعلى باقة $20K - كل مميزات جيب + 15 ميزة نوعية جديدة)
  factory AppConfig.enterprise() {
    return const AppConfig(
      tier: WalletTier.enterprise,
      companyName: 'النجم إنتربرايز الفاخرة',
      companyLegalName: 'شركة النجم للحوالات والصرافة (المنظومة المصرفية المتكاملة)',
      logoAsset: 'assets/images/alnajm_plus_logo.png',
      iconAsset: 'assets/images/app_icon_luxury.png',
      primaryColor: Color(0xFF9E1B21),
      primaryDarkColor: Color(0xFF7A1015),
      primaryLightColor: Color(0xFFB8282E),
      secondaryColor: Color(0xFFF59E0B),
      accentColor: Color(0xFFFBBF24),
      isDemoMode: false,
      enabledFeatures: [
        // كل المميزات الأساسية والاحترافية ومحفظة جيب
        'wallet',
        'transactions',
        'deposit',
        'withdraw',
        'send_money',
        'receive_money',
        'basic_kyc',
        'basic_security',
        'profile',
        'notifications',
        'jeeb_bill_payments',
        'jeeb_mobile_recharge',
        'jeeb_qr_merchant_pay',
        'jeeb_multi_currency',
        'jeeb_bank_transfers',
        'jeeb_beneficiaries',
        'jeeb_virtual_cards',
        'jeeb_detailed_statements',
        // + 15 ميزة نوعية جديدة ومبتكرة حصرياً لأعلى باقة:
        'ent_01_ai_financial_advisor',      // 1. المستشار المالي الذكي وتحليل المصروفات بالذكاء الاصطناعي
        'ent_02_offline_ble_transfers',     // 2. التحويل السريع بدون إنترنت عبر تقنية التقارب Bluetooth Low Energy
        'ent_03_multi_sig_family_wallets',  // 3. المحافظ المشتركة والعائلية متعددة التواقيع والصلاحيات
        'ent_04_instant_payment_links',     // 4. روابط الدفع الفورية السريعة والروابط العميقة (Deep Links)
        'ent_05_automated_recurring_bills', // 5. الجدولة التلقائية للفواتير والمدفوعات المتكررة الذكية
        'ent_06_nfc_contactless_tap_pay',   // 6. الدفع التلامسي السريع عبر شريحة NFC
        'ent_07_bulk_payroll_disbursement', // 7. صرف الحوالات والرواتب الجماعية للشركات بضغطة زر
        'ent_08_smart_savings_vaults',      // 8. حصالة النجم الذكية والادخار التلقائي من فكة المشتريات
        'ent_09_merchant_audio_speaker',    // 9. الإشعارات الصوتية الفورية للتجار عند استلام الدفعات (Smart Audio Box)
        'ent_10_advanced_3d_liveness_kyc',  // 10. التحقق الحيوي ثلاثي الأبعاد وكشف التزييف العميق المتقدم
        'ent_11_geofencing_fraud_lock',     // 11. الحماية الجغرافية الذكية والتجميد الفوري للأمان ومكافحة الاحتيال
        'ent_12_gamified_loyalty_cashback', // 12. محرك الكاش باك التفاعلي ونقاط المكافآت المصرفية
        'ent_13_merchant_open_api_gateway', // 13. بوابة API المفتوحة والربط مع المتاجر الإلكترونية (Webhooks & SDK)
        'ent_14_multi_branch_teller_sync',  // 14. نظام الصناديق الافتراضية ومزامنة فروع ووكلاء الصرافة المباشرة
        'ent_15_automated_aml_tax_reports', // 15. التقارير الرقابية والضريبية الذاتية ومكافحة غسل الأموال (AML/CFT)
      ],
    );
  }

  /// Global current configuration holder
  static AppConfig _current = AppConfig.demo();
  static AppConfig get current => _current;

  static void initialize(AppConfig config) {
    _current = config;
  }
}
