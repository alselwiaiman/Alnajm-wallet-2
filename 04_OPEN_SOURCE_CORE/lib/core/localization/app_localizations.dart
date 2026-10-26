import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('ar'));
  }

  bool get isArabic => locale.languageCode == 'ar';

  static const _localizedValues = <String, Map<String, String>>{
    'ar': {
      'app_title': 'محفظة النجم الرقمية',
      'welcome': 'مرحباً بك',
      'demo_account': 'حساب تجريبي',
      'available_balance': 'الرصيد المتاح',
      'currency': 'ريال يمني',
      'scan_qr': 'مسح رمز QR',
      'quick_services': 'الخدمات السريعة',
      'transfer': 'تحويل',
      'pay': 'سداد',
      'deposit': 'إيداع',
      'withdraw': 'سحب',
      'receive': 'استلام',
      'recent_transactions': 'أحدث العمليات',
      'view_all': 'عرض الكل',
      'no_transactions': 'لا توجد حركات مالية حديثة',
      'home': 'الرئيسية',
      'wallet': 'المحفظة',
      'transactions': 'العمليات',
      'profile': 'حسابي',
      'login': 'تسجيل الدخول',
      'phone_number': 'رقم الهاتف',
      'enter_phone': 'يرجى إدخال رقم الهاتف',
      'password': 'كلمة المرور',
      'enter_password': 'يرجى إدخال كلمة المرور',
      'confirm': 'تأكيد',
      'no_account': 'ليس لديك حساب؟ إنشاء حساب جديد',
      'already_account': 'لديك حساب بالفعل؟ تسجيل الدخول',
      'create_account': 'إنشاء حساب جديد',
      'full_name': 'الاسم الكامل',
      'cancel': 'إلغاء',
      'execute': 'تنفيذ',
      'amount': 'المبلغ',
      'recipient_name': 'اسم المستلم',
      'quick_amount': 'أو اختر مبلغاً سريعاً:',
      'fee': 'العمولة',
      'free_fee': '0 ريال يمني',
      'operation_success': 'تمت العملية بنجاح!',
      'insufficient_balance': 'الرصيد غير كافٍ',
      'invalid_amount': 'يرجى إدخال مبلغ صحيح',
      'customer_service': 'خدمة العملاء',
      'language': 'اللغة',
      'current_language': 'العربية',
      'theme': 'المظهر',
      'security_settings': 'إعدادات الأمان',
      'help_support': 'المساعدة والدعم',
      'about_app': 'عن التطبيق',
      'logout': 'تسجيل الخروج',
      'search_transactions': 'بحث في العمليات...',
      'kyc_title': 'التحقق من الهوية (KYC)',
      'kyc_desc': 'يرجى إكمال خطوات التحقق لترقية حدود حسابك',
      'scan_id': 'مسح وثيقة الهوية',
      'liveness_check': 'فحص الوجه الحيوي',
      'selfie_id': 'صورة سيلفي مع الهوية',
    },
    'en': {
      'app_title': 'Al Najm Digital Wallet',
      'welcome': 'Welcome',
      'demo_account': 'Demo Account',
      'available_balance': 'Available Balance',
      'currency': 'YER',
      'scan_qr': 'Scan QR',
      'quick_services': 'Quick Services',
      'transfer': 'Transfer',
      'pay': 'Pay',
      'deposit': 'Deposit',
      'withdraw': 'Withdraw',
      'receive': 'Receive',
      'recent_transactions': 'Recent Transactions',
      'view_all': 'View All',
      'no_transactions': 'No recent transactions',
      'home': 'Home',
      'wallet': 'Wallet',
      'transactions': 'Transactions',
      'profile': 'Profile',
      'login': 'Login',
      'phone_number': 'Phone Number',
      'enter_phone': 'Please enter phone number',
      'password': 'Password',
      'enter_password': 'Please enter password',
      'confirm': 'Confirm',
      'no_account': 'Don\'t have an account? Sign up',
      'already_account': 'Already have an account? Sign in',
      'create_account': 'Create New Account',
      'full_name': 'Full Name',
      'cancel': 'Cancel',
      'execute': 'Execute',
      'amount': 'Amount',
      'recipient_name': 'Recipient Name',
      'quick_amount': 'Or select quick amount:',
      'fee': 'Fee',
      'free_fee': '0 YER',
      'operation_success': 'Transaction completed successfully!',
      'insufficient_balance': 'Insufficient balance',
      'invalid_amount': 'Please enter a valid amount',
      'customer_service': 'Customer Service',
      'language': 'Language',
      'current_language': 'English',
      'theme': 'Appearance',
      'security_settings': 'Security Settings',
      'help_support': 'Help & Support',
      'about_app': 'About App',
      'logout': 'Log Out',
      'search_transactions': 'Search transactions...',
      'kyc_title': 'Identity Verification (KYC)',
      'kyc_desc': 'Please complete the verification steps to increase account limits',
      'scan_id': 'ID Document Scan',
      'liveness_check': 'Face Liveness Scan',
      'selfie_id': 'Selfie with ID',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['ar']?[key] ??
        key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ar', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

/// Global notifier for app locale switching
class LocaleController extends ChangeNotifier {
  static final LocaleController instance = LocaleController._();
  LocaleController._();

  Locale _locale = const Locale('ar');
  Locale get locale => _locale;

  void toggleLocale() {
    _locale = _locale.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
    notifyListeners();
  }

  void setLocale(Locale newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      notifyListeners();
    }
  }
}
