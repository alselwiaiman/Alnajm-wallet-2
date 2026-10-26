import 'package:flutter/material.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/config/app_config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(text: '777000111');
  final _passwordController = TextEditingController(text: '123456');
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate authentication
      await Future.delayed(const Duration(milliseconds: 700));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacementNamed(context, AppRouter.dashboardRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: BrandController.instance,
      builder: (context, _) {
        final config = AppConfig.current;
        final brandController = BrandController.instance;

        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // === محول الهوية الذكي (Brand Switcher Chip) ===
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => brandController.switchToNajm(),
                                borderRadius: BorderRadius.circular(26),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: config.isAlNajm ? const Color(0xFF9E1B21) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(26),
                                    boxShadow: config.isAlNajm
                                        ? [
                                            BoxShadow(
                                              color: const Color(0xFF9E1B21).withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            )
                                          ]
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        size: 18,
                                        color: config.isAlNajm ? const Color(0xFFFBBF24) : Colors.grey.shade700,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'شركة النجم بلس',
                                        style: TextStyle(
                                          color: config.isAlNajm ? Colors.white : Colors.grey.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => brandController.switchToSaifi(),
                                borderRadius: BorderRadius.circular(26),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: config.isAlSaifi ? const Color(0xFF183883) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(26),
                                    boxShadow: config.isAlSaifi
                                        ? [
                                            BoxShadow(
                                              color: const Color(0xFF183883).withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            )
                                          ]
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.shield_rounded,
                                        size: 18,
                                        color: config.isAlSaifi ? const Color(0xFFF59E0B) : Colors.grey.shade700,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'شركة الصيفي كاش',
                                        style: TextStyle(
                                          color: config.isAlSaifi ? Colors.white : Colors.grey.shade700,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // === شعار الشركة المعتمد ===
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: config.primaryColor.withOpacity(0.12),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              config.logoAsset,
                              height: 95,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 95,
                                  height: 95,
                                  color: config.primaryColor.withOpacity(0.1),
                                  child: Icon(
                                    config.isAlNajm ? Icons.star_rounded : Icons.account_balance_wallet_rounded,
                                    size: 55,
                                    color: config.primaryColor,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      Text(
                        config.companyLegalName,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: config.primaryColor,
                              fontSize: 20,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${config.companyName} • الرقم المجاني: ${config.supportPhone}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),

                      // === حقول تسجيل الدخول ===
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'رقم الهاتف / الحساب',
                          prefixIcon: Icon(Icons.phone_iphone_rounded, color: config.primaryColor),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: config.primaryColor, width: 2),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال رقم الهاتف';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'كلمة المرور',
                          prefixIcon: Icon(Icons.lock_outline_rounded, color: config.primaryColor),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: config.primaryColor, width: 2),
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال كلمة المرور';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 22),

                      ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: config.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 3,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.login_rounded, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'تسجيل الدخول إلى ${config.companyName}',
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 14),

                      // زر تسجيل دخول تجريبي سريع
                      OutlinedButton.icon(
                        onPressed: () {
                          _phoneController.text = '777000111';
                          _passwordController.text = '123456';
                          _login();
                        },
                        icon: Icon(Icons.bolt_rounded, color: config.secondaryColor),
                        label: Text(
                          'دخول سريع بالحساب التجريبي المعتمد',
                          style: TextStyle(color: config.primaryColor, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: config.primaryColor.withOpacity(0.4)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRouter.registerRoute);
                        },
                        child: Text(
                          'ليس لديك حساب؟ إنشاء حساب جديد في ${config.companyLegalName}',
                          style: TextStyle(color: config.primaryColor, fontWeight: FontWeight.w600, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
