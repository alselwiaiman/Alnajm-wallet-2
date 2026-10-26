import 'package:flutter/material.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/dashboard/presentation/screens/main_screen.dart';
import '../../features/kyc/presentation/screens/kyc_verification_screen.dart';

class AppRouter {
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String dashboardRoute = '/dashboard';
  static const String kycRoute = '/kyc';
  static const String walletRoute = '/wallet';
  static const String transactionsRoute = '/transactions';
  static const String profileRoute = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case registerRoute:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case dashboardRoute:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case kycRoute:
        return MaterialPageRoute(builder: (_) => const KycVerificationScreen());
      case walletRoute:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case transactionsRoute:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case profileRoute:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
