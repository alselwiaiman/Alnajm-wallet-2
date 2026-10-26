import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class KycVerificationScreen extends StatefulWidget {
  const KycVerificationScreen({super.key});

  @override
  State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen> {
  int _currentStep = 0;

  List<Step> get _steps => [
        Step(
          title: const Text('ID Document Scan'),
          content: _buildStepContent(
            Icons.credit_card,
            'Scan your National ID or Passport. Our system will extract your data automatically.',
            'Scan ID',
            _simulateIdScan,
          ),
          isActive: _currentStep >= 0,
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const Text('360° Face Liveness'),
          content: _buildStepContent(
            Icons.face,
            'Please look into the camera and move your head slowly in a circle to verify you are a real person.',
            'Start 360° Scan',
            _simulateLiveness,
          ),
          isActive: _currentStep >= 1,
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const Text('Selfie with ID'),
          content: _buildStepContent(
            Icons.camera_front,
            'Take a clear selfie while holding your ID document next to your face.',
            'Take Selfie',
            _simulateSelfie,
          ),
          isActive: _currentStep >= 2,
          state: _currentStep > 2 ? StepState.complete : StepState.indexed,
        ),
      ];

  Widget _buildStepContent(IconData icon, String description, String buttonText, VoidCallback onAction) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 80, color: AppColors.primary),
        ),
        const SizedBox(height: 24),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: onAction,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(buttonText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _simulateProcess(String title, String message, {String? successMessage}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.pop(context); // close loading

    if (successMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage), backgroundColor: Colors.green),
      );
    }
    
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep += 1);
    } else {
      _submitKyc();
    }
  }

  void _simulateIdScan() {
    _simulateProcess('AI Scanning', 'Extracting OCR Data from ID...', successMessage: 'Data extracted successfully! (Demo)');
  }

  void _simulateLiveness() {
    _simulateProcess('Face Liveness', 'Analyzing 360° facial vectors...', successMessage: 'Liveness check passed! (Demo)');
  }

  void _simulateSelfie() {
    _simulateProcess('Verification', 'Matching selfie with ID photo...', successMessage: 'Identity Verified! (Demo)');
  }

  void _submitKyc() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('KYC Approved'),
        content: const Text('Your identity has been verified successfully using Advanced AI Simulation.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context); // Go back to profile
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Identity Verification (KYC)')),
      body: Stepper(
        currentStep: _currentStep,
        type: StepperType.vertical,
        steps: _steps,
        controlsBuilder: (context, details) {
          return const SizedBox.shrink(); // Hide default continue/cancel buttons to use custom ones
        },
      ),
    );
  }
}

