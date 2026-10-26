import 'dart:convert';
import 'package:http/http.dart' as http;

/// خدمة الربط المباشر مع سحابة سوبابيس (Supabase Cloud Service)
/// تربط تطبيق المحفظة الرقمية بلوحة التحكم الإدارية وقاعدة البيانات المركزية
class SupabaseService {
  static final SupabaseService instance = SupabaseService._internal();
  SupabaseService._internal();

  static const String supabaseUrl = 'https://dcedqkwnwahfcnqogypc.supabase.co';
  static const String publishableKey = 'sb_publishable_V2WZQ3ivDaJHTgG0YE84nw_QUkGRHGR';
  static const String storageBucket = 'wallet_system';

  bool isConnected = false;
  DateTime? lastSyncTime;

  Map<String, String> get _headers => {
    'apikey': publishableKey,
    'Authorization': 'Bearer $publishableKey',
    'Content-Type': 'application/json',
  };

  /// استعلام أسعار الصرف اللحظية والعمولات المحدثة من لوحة التحكم عبر Supabase
  Future<Map<String, dynamic>?> fetchLiveExchangeRates() async {
    try {
      final uri = Uri.parse('$supabaseUrl/storage/v1/object/public/$storageBucket/exchange_rates.json');
      final response = await http.get(uri).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        isConnected = true;
        lastSyncTime = DateTime.now();
        return data;
      }
    } catch (e) {
      // وضع العمل دون إنترنت مع البيانات المحلية
    }
    return null;
  }

  /// جلب الإعلانات والتنبيهات المحدثة من لوحة التحكم عبر Supabase
  Future<List<Map<String, dynamic>>> fetchBanners() async {
    try {
      final uri = Uri.parse('$supabaseUrl/storage/v1/object/public/$storageBucket/app_banners.json');
      final response = await http.get(uri).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['banners'] != null) {
          return List<Map<String, dynamic>>.from(data['banners']);
        }
      }
    } catch (_) {}
    return [];
  }

  /// التحقق من حالة أمان الحساب وإيقافه/تجميده من لوحة التحكم الإدارية
  Future<Map<String, dynamic>?> checkUserAccountStatus(String phone) async {
    try {
      final uri = Uri.parse('$supabaseUrl/storage/v1/object/public/$storageBucket/users_data.json');
      final response = await http.get(uri).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['users'] != null) {
          final users = List<Map<String, dynamic>>.from(data['users']);
          for (var u in users) {
            if (u['phone'] == phone) {
              return u;
            }
          }
        }
      }
    } catch (_) {}
    return null;
  }

  /// فحص حالة الجلسات وإدارة الأجهزة من السحابة
  Future<List<Map<String, dynamic>>> fetchActiveDeviceSessions() async {
    try {
      final uri = Uri.parse('$supabaseUrl/storage/v1/object/public/$storageBucket/devices.json');
      final response = await http.get(uri).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['activeSessions'] != null) {
          return List<Map<String, dynamic>>.from(data['activeSessions']);
        }
      }
    } catch (_) {}
    return [];
  }
}
