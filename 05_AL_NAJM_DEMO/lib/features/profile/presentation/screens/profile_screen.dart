import 'package:flutter/material.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/localization/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final config = AppConfig.current;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(l10n.translate('profile'), style: const TextStyle(color: Color(0xFF212529), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: config.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person_rounded, size: 40, color: config.primaryColor),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.translate('demo_account'),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF212529)),
                ),
                const SizedBox(height: 4),
                Text(
                  config.companyLegalName,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  icon: Icons.support_agent_rounded,
                  title: l10n.translate('customer_service'),
                  trailing: config.supportPhone,
                  color: config.primaryColor,
                  onTap: () {},
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.language_rounded,
                  title: l10n.translate('language'),
                  trailing: l10n.translate('current_language'),
                  color: const Color(0xFFF57C00),
                  onTap: () {
                    LocaleController.instance.toggleLocale();
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.verified_user_rounded,
                  title: l10n.translate('kyc_title'),
                  color: const Color(0xFF2E7D32),
                  onTap: () {
                    Navigator.pushNamed(context, '/kyc');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  icon: Icons.security_rounded,
                  title: l10n.translate('security_settings'),
                  color: const Color(0xFF2E7D32),
                  onTap: () {},
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.help_outline_rounded,
                  title: l10n.translate('help_support'),
                  color: const Color(0xFF7B1FA2),
                  onTap: () {},
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.info_outline_rounded,
                  title: l10n.translate('about_app'),
                  trailing: 'v1.0.0',
                  color: Colors.grey,
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: config.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.logout_rounded, color: config.primaryColor, size: 20),
              ),
              title: Text(l10n.translate('logout'), style: TextStyle(color: config.primaryColor, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.chevron_left, color: Colors.grey),
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRouter.loginRoute);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? trailing,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: trailing != null
          ? Text(trailing, style: const TextStyle(color: Colors.grey, fontSize: 13))
          : const Icon(Icons.chevron_left, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 56, color: Colors.grey[200]);
  }
}
