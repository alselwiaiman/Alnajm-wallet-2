import 'package:flutter/material.dart';
import '../../../../core/responsive/adaptive_scaffold.dart';
import 'dashboard_screen.dart';
import '../../wallet/presentation/screens/wallet_screen.dart';
import '../../transactions/presentation/screens/transactions_screen.dart';
import '../../profile/presentation/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const WalletScreen(),
    const TransactionsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      currentIndex: _currentIndex,
      onNavigationIndexChanged: (index) => setState(() => _currentIndex = index),
      screens: _screens,
    );
  }
}
