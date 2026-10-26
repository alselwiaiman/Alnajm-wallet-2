import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../config/app_config.dart';
import '../localization/app_localizations.dart';
import '../routing/app_router.dart';
import 'responsive_layout.dart';

class AdaptiveScaffold extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onNavigationIndexChanged;
  final List<Widget> screens;
  final Widget? floatingActionButton;

  const AdaptiveScaffold({
    super.key,
    required this.currentIndex,
    required this.onNavigationIndexChanged,
    required this.screens,
    this.floatingActionButton,
  });

  @override
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  bool _isMobileSimulatorActive = false;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final config = AppConfig.current;
    final isDesktop = ResponsiveLayout.isDesktop(context);

    if (isDesktop && !_isMobileSimulatorActive) {
      return _buildDesktopLayout(context, l10n, config);
    } else if (isDesktop && _isMobileSimulatorActive) {
      return _buildDesktopWithSimulator(context, l10n, config);
    } else {
      return _buildMobileLayout(context, l10n, config);
    }
  }

  /// 1. Mobile Layout with Bottom Navigation Bar
  Widget _buildMobileLayout(
    BuildContext context,
    AppLocalizations l10n,
    AppConfig config,
  ) {
    return Scaffold(
      body: widget.screens[widget.currentIndex],
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: widget.currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: config.primaryColor,
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 11),
          elevation: 0,
          onTap: widget.onNavigationIndexChanged,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              activeIcon: Icon(Icons.home_rounded, color: config.primaryColor),
              label: l10n.translate('home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_balance_wallet_rounded),
              activeIcon: Icon(Icons.account_balance_wallet_rounded, color: config.primaryColor),
              label: l10n.translate('wallet'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.history_rounded),
              activeIcon: Icon(Icons.history_rounded, color: config.primaryColor),
              label: l10n.translate('transactions'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_rounded),
              activeIcon: Icon(Icons.person_rounded, color: config.primaryColor),
              label: l10n.translate('profile'),
            ),
          ],
        ),
      ),
    );
  }

  /// 2. Desktop Layout with Sidebar, Top Header, and Workstation Canvas
  Widget _buildDesktopLayout(
    BuildContext context,
    AppLocalizations l10n,
    AppConfig config,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Row(
        children: [
          // Desktop Professional Sidebar
          _buildDesktopSidebar(context, l10n, config),

          // Main Desktop Content Area
          Expanded(
            child: Column(
              children: [
                // Desktop Header Bar
                _buildDesktopHeader(context, l10n, config),

                // Active Screen Viewport
                Expanded(
                  child: Container(
                    color: const Color(0xFFF8FAFC),
                    child: widget.screens[widget.currentIndex],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 3. Desktop Layout with Mobile Simulator Frame
  Widget _buildDesktopWithSimulator(
    BuildContext context,
    AppLocalizations l10n,
    AppConfig config,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Row(
        children: [
          _buildDesktopSidebar(context, l10n, config),
          Expanded(
            child: Column(
              children: [
                _buildDesktopHeader(context, l10n, config),
                Expanded(
                  child: Center(
                    child: Container(
                      width: 410,
                      height: 820,
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(44),
                        border: Border.all(color: const Color(0xFF334155), width: 10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 40,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(34),
                        child: _buildMobileLayout(context, l10n, config),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Sidebar Component
  Widget _buildDesktopSidebar(
    BuildContext context,
    AppLocalizations l10n,
    AppConfig config,
  ) {
    return Container(
      width: 270,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        border: Border(
          left: l10n.isArabic
              ? const BorderSide(color: Color(0xFF334155), width: 1)
              : BorderSide.none,
          right: !l10n.isArabic
              ? const BorderSide(color: Color(0xFF334155), width: 1)
              : BorderSide.none,
        ),
      ),
      child: Column(
        children: [
          // Branding Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF334155))),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [config.primaryColor, config.primaryDarkColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: config.primaryColor.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 28),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        config.companyName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD700).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.4), width: 0.8),
                            ),
                            child: const Text(
                              'DESKTOP PRO',
                              style: TextStyle(
                                color: Color(0xFFFFD700),
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'v1.0',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // User Profile Card
          Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: config.primaryColor,
                  child: const Text('أ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'أحمد محمد العباسي',
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 12),
                          SizedBox(width: 4),
                          Text('موثق المستوى 2', style: TextStyle(color: Color(0xFF10B981), fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Nav Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              children: [
                _buildSidebarNavItem(
                  icon: Icons.dashboard_rounded,
                  title: l10n.translate('home'),
                  index: 0,
                  isSelected: widget.currentIndex == 0,
                  config: config,
                ),
                _buildSidebarNavItem(
                  icon: Icons.account_balance_wallet_rounded,
                  title: l10n.translate('wallet'),
                  index: 1,
                  isSelected: widget.currentIndex == 1,
                  badgeText: '4 عملات',
                  config: config,
                ),
                _buildSidebarNavItem(
                  icon: Icons.history_rounded,
                  title: l10n.translate('transactions'),
                  index: 2,
                  isSelected: widget.currentIndex == 2,
                  config: config,
                ),
                _buildSidebarNavItem(
                  icon: Icons.person_rounded,
                  title: l10n.translate('profile'),
                  index: 3,
                  isSelected: widget.currentIndex == 3,
                  config: config,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(color: Color(0xFF334155), height: 1),
                ),
                _buildSidebarActionItem(
                  icon: Icons.verified_user_rounded,
                  title: 'توثيق الهوية (KYC)',
                  onTap: () => Navigator.pushNamed(context, AppRouter.kycRoute),
                  badgeColor: const Color(0xFF10B981),
                  badgeText: 'مكتمل',
                ),
                _buildSidebarActionItem(
                  icon: Icons.security_rounded,
                  title: 'إدارة الأجهزة والجلسات',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('جلسة الويندوز الحالية مشفرة ومؤمنة بالكامل')),
                    );
                  },
                ),
              ],
            ),
          ),

          // Sidebar Bottom Utilities (Simulator mode, language, logout)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF334155))),
            ),
            child: Column(
              children: [
                // Mobile Simulator toggle
                InkWell(
                  onTap: () => setState(() => _isMobileSimulatorActive = !_isMobileSimulatorActive),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _isMobileSimulatorActive
                          ? const Color(0xFFFFD700).withOpacity(0.2)
                          : const Color(0xFF334155).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _isMobileSimulatorActive ? const Color(0xFFFFD700) : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isMobileSimulatorActive ? Icons.phone_android_rounded : Icons.desktop_windows_rounded,
                          color: _isMobileSimulatorActive ? const Color(0xFFFFD700) : const Color(0xFF94A3B8),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _isMobileSimulatorActive ? 'محاكي الهاتف نشط' : 'محاكي شاشة الهاتف',
                            style: TextStyle(
                              color: _isMobileSimulatorActive ? const Color(0xFFFFD700) : const Color(0xFFE2E8F0),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Switch.adaptive(
                          value: _isMobileSimulatorActive,
                          activeColor: const Color(0xFFFFD700),
                          onChanged: (val) => setState(() => _isMobileSimulatorActive = val),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Language Switcher
                    Expanded(
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF94A3B8),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        icon: const Icon(Icons.language_rounded, size: 16),
                        label: Text(
                          LocaleController.instance.isArabic ? 'English' : 'العربية',
                          style: const TextStyle(fontSize: 12),
                        ),
                        onPressed: () => LocaleController.instance.toggleLocale(),
                      ),
                    ),
                    // Logout
                    IconButton(
                      icon: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 18),
                      tooltip: 'تسجيل الخروج',
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRouter.loginRoute);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarNavItem({
    required IconData icon,
    required String title,
    required int index,
    required bool isSelected,
    required AppConfig config,
    String? badgeText,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: isSelected ? config.primaryColor : Colors.transparent,
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : const Color(0xFF94A3B8),
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFFE2E8F0),
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        trailing: badgeText != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withOpacity(0.2) : const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                    fontSize: 10,
                  ),
                ),
              )
            : null,
        onTap: () => widget.onNavigationIndexChanged(index),
      ),
    );
  }

  Widget _buildSidebarActionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? badgeText,
    Color? badgeColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: Icon(icon, color: const Color(0xFF94A3B8), size: 18),
        title: Text(
          title,
          style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12.5),
        ),
        trailing: badgeText != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (badgeColor ?? const Color(0xFF334155)).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(color: badgeColor ?? const Color(0xFF94A3B8), fontSize: 10),
                ),
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  /// Top Desktop Navigation & Search Bar
  Widget _buildDesktopHeader(
    BuildContext context,
    AppLocalizations l10n,
    AppConfig config,
  ) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Global Search Bar
          Expanded(
            flex: 2,
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: const InputDecoration(
                  hintText: 'بحث سريع في الحوالات، المستفيدين، الفواتير... (Ctrl + F)',
                  hintStyle: TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
                  prefixIcon: Icon(Icons.search_rounded, size: 20, color: Color(0xFF64748B)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),

          // Live Exchange Rates Ticker Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Row(
              children: [
                Icon(Icons.trending_up_rounded, color: Color(0xFF10B981), size: 16),
                SizedBox(width: 8),
                Text('SAR: 432 YER', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                SizedBox(width: 10),
                Text('|', style: TextStyle(color: Color(0xFFCBD5E1))),
                SizedBox(width: 10),
                Text('USD: 1,620 YER', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Security Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: const Row(
              children: [
                Icon(Icons.lock_rounded, color: Color(0xFF059669), size: 14),
                SizedBox(width: 6),
                Text(
                  'اتصال بنكي مشفر 256-bit',
                  style: TextStyle(color: Color(0xFF065F46), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Notification Bell
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, color: Color(0xFF475569), size: 22),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                    child: const Text('2', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            tooltip: 'الإشعارات',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
