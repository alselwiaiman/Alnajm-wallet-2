import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';

/// Device model representing a logged-in device
class DeviceSession {
  final String deviceId;
  final String deviceName;
  final String model;
  final DateTime lastActive;
  final bool isCurrent;

  DeviceSession({
    required this.deviceId,
    required this.deviceName,
    required this.model,
    required this.lastActive,
    this.isCurrent = false,
  });
}

/// Category of merchant for contextual post-payment messages
enum MerchantCategory {
  medical,   // صيدلية، مستشفى، مركز طبي
  restaurant, // مطعم، كافيه، بوفيه
  grocery,   // سوبرماركت، بقالة، تموينات
  tech,      // إلكترونيات، تقنية
  services,  // خدمات عامة، صرافة
}

class UserPrivacyProfile {
  final String fullName; // e.g. "محمد علي صالح أحمد الوصابي"
  final bool hideRealName;
  final String randomAliasCode; // 6 random digits e.g. "849201"

  UserPrivacyProfile({
    required this.fullName,
    this.hideRealName = false,
    required this.randomAliasCode,
  });

  /// Displays masked name: e.g. "م. ع. ص. أ. الوصابي" or the full name
  String get displayName {
    if (!hideRealName) return fullName;
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length <= 1) return fullName;

    final initials = parts.sublist(0, parts.length - 1).map((p) => p.isNotEmpty ? '${p[0]}.' : '').join(' ');
    final lastName = parts.last;
    return '$initials $lastName ($randomAliasCode)';
  }
}

/// Controller managing Devices, Privacy, Multi-platform Authentication limits, and Smart Notifications
class UserSecurityController extends ChangeNotifier {
  static final UserSecurityController instance = UserSecurityController._();
  UserSecurityController._() {
    _initializeMockSessions();
  }

  // --- 1. Privacy Profile ---
  UserPrivacyProfile _profile = UserPrivacyProfile(
    fullName: 'محمد علي عبدالكريم أحمد النهمي',
    hideRealName: false,
    randomAliasCode: _generateRandomCode(),
  );

  UserPrivacyProfile get profile => _profile;

  void toggleHideName() {
    _profile = UserPrivacyProfile(
      fullName: _profile.fullName,
      hideRealName: !_profile.hideRealName,
      randomAliasCode: _profile.randomAliasCode,
    );
    notifyListeners();
  }

  static String _generateRandomCode() {
    final rand = Random();
    return (100000 + rand.nextInt(900000)).toString();
  }

  // --- 2. Device Management & Rules ---
  // Maximum active devices allowed simultaneously = 3
  // Maximum total registered devices in history = 10
  static const int maxConcurrentDevices = 3;
  static const int maxHistoricalDevices = 10;

  final List<DeviceSession> _activeDevices = [];
  int _totalHistoricalDeviceCount = 4; // Simulated count

  List<DeviceSession> get activeDevices => List.unmodifiable(_activeDevices);
  int get totalHistoricalDeviceCount => _totalHistoricalDeviceCount;

  void _initializeMockSessions() {
    _activeDevices.addAll([
      DeviceSession(
        deviceId: 'dev_curr_01',
        deviceName: 'Samsung Galaxy S24 Ultra',
        model: 'SM-S928B (Android 14)',
        lastActive: DateTime.now(),
        isCurrent: true,
      ),
      DeviceSession(
        deviceId: 'dev_02',
        deviceName: 'iPhone 15 Pro Max',
        model: 'iOS 17.5',
        lastActive: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      DeviceSession(
        deviceId: 'dev_03',
        deviceName: 'iPad Air 5th Gen',
        model: 'iPadOS 17',
        lastActive: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ]);
  }

  /// Remove/Logout device by ID
  bool terminateDeviceSession(String deviceId) {
    final initialLen = _activeDevices.length;
    _activeDevices.removeWhere((d) => d.deviceId == deviceId && !d.isCurrent);
    if (_activeDevices.length < initialLen) {
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Check if user can register another device
  Map<String, dynamic> verifyDeviceRegistrationEligibility() {
    if (_totalHistoricalDeviceCount >= maxHistoricalDevices) {
      return {
        'allowed': false,
        'message': 'لقد بلغت الحد الأقصى للأجهزة المرتبطة (10 أجهزة). يرجى التواصل بخدمة العملاء لإعادة تعيين أجهزتك.',
      };
    }
    if (_activeDevices.length >= maxConcurrentDevices) {
      return {
        'allowed': false,
        'message': 'لا يمكن تسجيل الدخول في أكثر من 3 أجهزة بنفس الوقت. يرجى تسجيل الخروج من أحد أجهزتك الحالية.',
      };
    }
    return {'allowed': true};
  }

  // --- 3. Smart Merchant Pay Greeting Message Engine ---
  static String getContextualGreeting(String merchantName, MerchantCategory category) {
    switch (category) {
      case MerchantCategory.medical:
        return 'محفظة الصيفي كاش تتمنى لك ولعائلتك دوام الصحة والشفاء العاجل! 💙🩺';
      case MerchantCategory.restaurant:
        return 'بالهناء والشفاء! محفظة الصيفي كاش خيارك الألذ والأسرع دائماً 🍽️✨';
      case MerchantCategory.grocery:
        return 'مشتريات مباركة وتسوّق سعيد مع الصيفي كاش 🛒💙';
      case MerchantCategory.tech:
        return 'مبارك ما اشتريت! الصيفي كاش يدعم أحدث التقنيات ويوفر عليك الوقت 💻📱';
      case MerchantCategory.services:
        return 'سعداء بخدمتك! شركة الصيفي للصرافة خيارك المالي الأضمن دائماً 🏦✨';
    }
  }

  static MerchantCategory detectCategory(String merchantName) {
    final lower = merchantName.toLowerCase();
    if (lower.contains('صيدلية') || lower.contains('مستشفى') || lower.contains('مختبر') || lower.contains('طبي') || lower.contains('عيادة') || lower.contains('مركز')) {
      return MerchantCategory.medical;
    }
    if (lower.contains('مطعم') || lower.contains('كافيه') || lower.contains('شاورما') || lower.contains('بوفية') || lower.contains('عصائر')) {
      return MerchantCategory.restaurant;
    }
    if (lower.contains('سوبر') || lower.contains('هايبر') || lower.contains('ماركت') || lower.contains('بقالة') || lower.contains('تموينات')) {
      return MerchantCategory.grocery;
    }
    return MerchantCategory.services;
  }
}
