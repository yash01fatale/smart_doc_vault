import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/role_controller.dart';
import '../../documents/screens/dashboard_screen.dart';

class OtpScreen extends StatefulWidget {
  final String userId;

  const OtpScreen({super.key, required this.userId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>
    with SingleTickerProviderStateMixin {

  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
      List.generate(6, (_) => FocusNode());

  bool isLoading = false;

  int countdown = 30;
  Timer? timer;

  late AnimationController shakeController;
  late Animation<double> shakeAnimation;

  @override
  void initState() {
    super.initState();
    _initShakeAnimation();
    startTimer();
  }

  void _initShakeAnimation() {
    shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    shakeAnimation = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(shakeController);
  }

  void startTimer() {
    countdown = 30;
    timer?.cancel();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (countdown == 0) {
          timer.cancel();
        } else {
          setState(() => countdown--);
        }
      },
    );
  }

  String get otp =>
      controllers.map((c) => c.text).join();

  Future<void> _verifyOtp() async {
    if (otp.length != 6) return;

    setState(() => isLoading = true);

    try {
      final data = await AuthService.verify2FA(
        userId: widget.userId,
        token: otp,
      );

      await LocalStorage.saveAuthData(
        data["token"],
        data["role"],
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(
            userRole: data["role"] == "business"
                ? UserRole.business
                : UserRole.personal,
          ),
        ),
        (route) => false,
      );

    } catch (e) {

      shakeController.forward(from: 0);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid or expired code"),
          backgroundColor: Colors.red,
        ),
      );

    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    shakeController.dispose();
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Column(
          children: [

            /// HEADER
            Container(
              height: 220,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF4A00E0),
                    Color(0xFF8E2DE2),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_user,
                      size: 60, color: Colors.white),
                  SizedBox(height: 12),
                  Text(
                    "Two-Factor Authentication",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Enter 6-digit code from Authenticator App",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [

                    const SizedBox(height: 40),

                    /// OTP BOXES
                    AnimatedBuilder(
                      animation: shakeAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(shakeAnimation.value, 0),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              6,
                              (index) => _otpBox(index),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    /// VERIFY BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF4A00E0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                        ),
                        onPressed:
                            isLoading ? null : _verifyOtp,
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Verify & Continue",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      countdown > 0
                          ? "Code expires in $countdown sec"
                          : "You can request a new code",
                      style:
                          const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpBox(int index) {
    return SizedBox(
      width: 45,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 5) {
              focusNodes[index + 1].requestFocus();
            }
          } else {
            if (index > 0) {
              focusNodes[index - 1].requestFocus();
            }
          }

          if (otp.length == 6) {
            _verifyOtp();
          }
        },
      ),
    );
  }
}
