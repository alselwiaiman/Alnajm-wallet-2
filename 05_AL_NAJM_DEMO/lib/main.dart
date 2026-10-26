import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/localization/app_localizations.dart';
import 'core/config/app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Default to Al-Najm Plus configuration
  AppConfig.initialize(AppConfig.alNajm());
  runApp(const AlNajmWalletApp());
}

class AlNajmWalletApp extends StatelessWidget {
  const AlNajmWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        LocaleController.instance,
        BrandController.instance,
      ]),
      builder: (context, _) {
        final currentLocale = LocaleController.instance.locale;

        return MaterialApp(
          title: AppConfig.current.companyName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          locale: currentLocale,
          supportedLocales: const [
            Locale('ar', ''),
            Locale('en', ''),
          ],
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: AppRouter.loginRoute,
          builder: (context, child) {
            return Banner(
              message: 'DEMO / تجريبي',
              location: BannerLocation.topStart,
              color: AppConfig.current.primaryColor,
              textStyle: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: Colors.white,
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
