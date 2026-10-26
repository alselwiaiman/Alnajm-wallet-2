# White-Label Customization Guide — Al Najm Platform

The Al Najm Digital Wallet is engineered from the ground up to be completely white-labelable, allowing financial institutions and exchange companies to rebrand and reconfigure the platform without modifying core business logic.

---

## 1. The `AppConfig` Architecture

All branding, theming, and functional capability toggles are centralized in:
`lib/core/config/app_config.dart`

```dart
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
}
```

---

## 2. Rebranding for a New Client

To create a new branded edition:
1. **Define Brand Assets:**
   Place the client's vector logo and app icon in `assets/images/` (e.g. `client_logo.png`).
2. **Add a Factory Constructor or Configuration File:**
   ```dart
   factory AppConfig.customClient() {
     return const AppConfig(
       tier: WalletTier.professional,
       companyName: 'محفظة الصرافة الذكية',
       companyLegalName: 'شركة الصرافة المعتمدة المحدودة',
       logoAsset: 'assets/images/client_logo.png',
       iconAsset: 'assets/images/client_icon.png',
       primaryColor: Color(0xFF0F766E), // Teal brand
       primaryDarkColor: Color(0xFF115E59),
       primaryLightColor: Color(0xFF14B8A6),
       secondaryColor: Color(0xFFF59E0B),
       accentColor: Color(0xFF10B981),
       defaultCurrency: 'YER',
       supportedCurrencies: ['YER', 'SAR', 'USD'],
       isDemoMode: false,
       supportPhone: '8000000',
       supportEmail: 'support@client.com',
       enabledFeatures: [ ... ],
     );
   }
   ```
3. **Initialize in `main.dart`:**
   ```dart
   void main() {
     WidgetsFlutterBinding.ensureInitialized();
     AppConfig.initialize(AppConfig.customClient());
     runApp(const AlNajmWalletApp());
   }
   ```

---

## 3. Commercial Tiers ($10K, $15K, $20K)
Feature availability is conditionally controlled via `AppConfig.current.hasFeature('feature_name')`.
See `06_COMMERCIAL_EDITIONS/FEATURE_MATRIX.md` for the full breakdown of features enabled across Essential, Professional, and Enterprise editions.
