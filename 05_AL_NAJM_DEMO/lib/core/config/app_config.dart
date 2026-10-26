import 'package:flutter/material.dart';

enum WalletTier {
  demo,
  essential,
  professional,
  enterprise,
}

enum BrandType {
  alNajm,
  alSaifi,
}

/// Configuration class representing the white-label and tiered settings of the wallet platform.
class AppConfig {
  final BrandType brandType;
  final WalletTier tier;
  final String companyName;
  final String companyLegalName;
  final String logoAsset;
  final String iconAsset;
  final String mascotAsset;
  final String mascotYemeniAsset;
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
  final String apiBaseUrl;
  final String transferNetworkName;
  final String expressService;
  final List<String> mascotSlogans;
  final List<String> enabledFeatures;

  const AppConfig({
    required this.brandType,
    required this.tier,
    required this.companyName,
    required this.companyLegalName,
    required this.logoAsset,
    required this.iconAsset,
    required this.mascotAsset,
    required this.mascotYemeniAsset,
    required this.primaryColor,
    required this.primaryDarkColor,
    required this.primaryLightColor,
    required this.secondaryColor,
    required this.accentColor,
    this.defaultCurrency = 'YER',
    this.supportedCurrencies = const ['YER', 'SAR', 'USD'],
    this.isDemoMode = true,
    this.supportPhone = '8000002',
    this.supportEmail = 'care@alsaifiexchange.com',
    this.apiBaseUrl = 'http://localhost:8000/api',
    required this.transferNetworkName,
    required this.expressService,
    required this.mascotSlogans,
    required this.enabledFeatures,
  });

  bool hasFeature(String feature) => enabledFeatures.contains(feature);

  bool get isAlNajm => brandType == BrandType.alNajm;
  bool get isAlSaifi => brandType == BrandType.alSaifi;

  /// Official Al-Najm Plus Wallet Configuration
  factory AppConfig.alNajm() {
    return const AppConfig(
      brandType: BrandType.alNajm,
      tier: WalletTier.enterprise,
      companyName: 'محفظة النجم بلس',
      companyLegalName: 'شركة النجم للصرافة والتحويلات',
      logoAsset: 'assets/images/alnajm_plus_logo.png',
      iconAsset: 'assets/images/alnajm_logo.png',
      mascotAsset: 'assets/images/alnajm_mascot.png',
      mascotYemeniAsset: 'assets/images/alnajm_mascot_yemeni.jpg',
      primaryColor: Color(0xFF9E1B21),      // Official Al-Najm Crimson
      primaryDarkColor: Color(0xFF6B0E12),  // Deep Crimson Maroon
      primaryLightColor: Color(0xFFC72830), // Bright Crimson
      secondaryColor: Color(0xFFD97706),    // Al-Najm Gold / Star Amber
      accentColor: Color(0xFFFBBF24),       // Golden Star Glow
      defaultCurrency: 'YER',
      supportPhone: '8000008',
      supportEmail: 'care@alnajmplusexchange.com',
      apiBaseUrl: 'http://localhost:8000/api',
      transferNetworkName: 'شبكة النجم للحوالات المالية',
      expressService: 'نجم إكسبرس',
      mascotSlogans: [
        'شبكة النجم للحوالات المالية.. الأسرع والأوسع انتشاراً في اليمن 🇾🇪',
        'محفظة النجم بلس.. حول واستلم بضغطة زر وبأعلى درجات الأمان ⚡',
        'خدمة العملاء والرقم المجاني الموحد 8000008 📞',
        'أكثر من 3000 نقطة خدمة وفرع لخدمتكم أينما كنتم 🌟',
      ],
      isDemoMode: true,
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
        'express_transfer',
        'bill_payments',
        'mobile_recharge',
        'qr_merchant_pay',
        'currency_exchange',
        'bank_transfers',
        'branches_locator',
        'virtual_cards',
        'detailed_statements',
        'ent_01_ai_financial_advisor',
        'ent_04_instant_payment_links',
        'ent_06_nfc_contactless_tap_pay',
        'ent_08_smart_savings_vaults',
        'ent_12_gamified_loyalty_cashback',
        'ent_14_multi_branch_teller_sync',
      ],
    );
  }

  /// Official Al-Saifi Wallet Configuration
  factory AppConfig.alSaifi() {
    return const AppConfig(
      brandType: BrandType.alSaifi,
      tier: WalletTier.enterprise,
      companyName: 'محفظة الصيفي كاش',
      companyLegalName: 'شركة الصيفي للصرافة والتحويلات',
      logoAsset: 'assets/images/alsaifi_logo_hd.jpg',
      iconAsset: 'assets/images/alsaifi_app_icon.jpg',
      mascotAsset: 'assets/images/alsaifi_app_icon.jpg',
      mascotYemeniAsset: 'assets/images/alsaifi_logo_hd.jpg',
      primaryColor: Color(0xFF183883),      // Royal Navy Blue
      primaryDarkColor: Color(0xFF0F2458),  // Deep Navy
      primaryLightColor: Color(0xFF2855BC), // Vibrant Blue
      secondaryColor: Color(0xFFDC2626),    // Hotline Red
      accentColor: Color(0xFFF59E0B),       // Gold
      defaultCurrency: 'YER',
      supportPhone: '8000002',
      supportEmail: 'care@alsaifiexchange.com',
      apiBaseUrl: 'http://localhost:8000/api',
      transferNetworkName: 'شبكة الصيفي للصرافة والتحويلات',
      expressService: 'صيفي إكسبرس',
      mascotSlogans: [
        'شركة الصيفي للصرافة.. ثقة وأمان مصرفي عريق 🏦',
        'محفظة الصيفي كاش.. حوالتك إكسبرس فورية بلمح البصر ⚡',
        'خدمة العملاء والرقم المجاني الموحد 8000002 📞',
        'أوسع شبكة صرافة وفروع في عموم محافظات اليمن 🇾🇪',
      ],
      isDemoMode: true,
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
        'express_transfer',
        'bill_payments',
        'mobile_recharge',
        'qr_merchant_pay',
        'currency_exchange',
        'bank_transfers',
        'branches_locator',
        'virtual_cards',
        'detailed_statements',
        'ent_01_ai_financial_advisor',
        'ent_04_instant_payment_links',
        'ent_06_nfc_contactless_tap_pay',
        'ent_08_smart_savings_vaults',
        'ent_12_gamified_loyalty_cashback',
        'ent_14_multi_branch_teller_sync',
      ],
    );
  }

  /// Default demo configuration points to Al-Najm initially
  factory AppConfig.demo() => AppConfig.alNajm();

  /// Global current configuration holder
  static AppConfig _current = AppConfig.alNajm();
  static AppConfig get current => _current;

  static void initialize(AppConfig config) {
    _current = config;
  }
}

/// Global Brand Switcher Controller allowing instant live retheming
class BrandController extends ChangeNotifier {
  static final BrandController instance = BrandController._();
  BrandController._();

  AppConfig get currentConfig => AppConfig.current;
  BrandType get currentBrand => AppConfig.current.brandType;
  bool get isAlNajm => AppConfig.current.isAlNajm;
  bool get isAlSaifi => AppConfig.current.isAlSaifi;

  void switchToNajm() {
    if (AppConfig.current.brandType != BrandType.alNajm) {
      AppConfig.initialize(AppConfig.alNajm());
      notifyListeners();
    }
  }

  void switchToSaifi() {
    if (AppConfig.current.brandType != BrandType.alSaifi) {
      AppConfig.initialize(AppConfig.alSaifi());
      notifyListeners();
    }
  }

  void toggleBrand() {
    if (isAlNajm) {
      switchToSaifi();
    } else {
      switchToNajm();
    }
  }
}
