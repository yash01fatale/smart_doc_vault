import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/role_controller.dart';
import '../../documents/screens/dashboard_screen.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen>
    with SingleTickerProviderStateMixin {

  final _formKey =
      GlobalKey<FormState>();

  final emailController =
      TextEditingController();
  final passwordController =
      TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;
  bool rememberMe = false;

  late AnimationController
      _controller;
  late Animation<double>
      _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(
      vsync: this,
      duration:
          const Duration(seconds: 1),
    );

    _fadeAnimation =
        CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  Future<void> _login() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => isLoading = true);

  try {
    final data = await AuthService.login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    // ✅ CASE 1: 2FA REQUIRED
    if (data["require2FA"] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpScreen(
            userId: data["userId"],
          ),
        ),
      );
      return;
    }

    // ✅ CASE 2: NORMAL LOGIN
    await LocalStorage.saveAuthData(
      data["token"],
      data["role"],
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardScreen(
          userRole: data["role"] == "business"
              ? UserRole.business
              : UserRole.personal,
        ),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ),
    );
  } finally {
    setState(() => isLoading = false);
  }
}


  @override
  Widget build(
      BuildContext context) {

    return Scaffold(
      body: Container(
        decoration:
            const BoxDecoration(
          gradient:
              LinearGradient(
            colors: [
              Color(0xFF4A00E0),
              Color(0xFF8E2DE2),
            ],
            begin:
                Alignment.topLeft,
            end:
                Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child:
              FadeTransition(
            opacity:
                _fadeAnimation,
            child:
                SingleChildScrollView(
              padding:
                  const EdgeInsets
                      .all(24),
              child: Column(
                children: [

                  const SizedBox(
                      height: 30),

                  /// 🔐 ICON
                  const CircleAvatar(
                    radius: 42,
                    backgroundColor:
                        Colors.white,
                    child: Icon(
                      Icons.lock_outline,
                      size: 42,
                      color:
                          Color(
                              0xFF4A00E0),
                    ),
                  ),

                  const SizedBox(
                      height: 20),

                  const Text(
                    "Welcome Back 👋",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          Colors.white,
                    ),
                  ),

                  const SizedBox(
                      height: 6),

                  const Text(
                    "Secure • Smart • Reliable",
                    style: TextStyle(
                      color:
                          Colors.white70,
                    ),
                  ),

                  const SizedBox(
                      height: 40),

                  /// 🔥 FORM CARD
                  Container(
                    padding:
                        const EdgeInsets
                            .all(24),
                    decoration:
                        BoxDecoration(
                      color:
                          Colors.white,
                      borderRadius:
                          BorderRadius
                              .circular(
                                  24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors
                              .black
                              .withOpacity(
                                  0.15),
                          blurRadius:
                              20,
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [

                          /// EMAIL
                          TextFormField(
                            controller:
                                emailController,
                            decoration:
                                InputDecoration(
                              labelText:
                                  "Email",
                              prefixIcon:
                                  const Icon(
                                Icons
                                    .email_outlined,
                              ),
                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        16),
                              ),
                            ),
                            validator:
                                (v) {
                              if (v ==
                                      null ||
                                  v
                                      .isEmpty) {
                                return "Email required";
                              }
                              if (!v
                                  .contains(
                                      "@")) {
                                return "Invalid email";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(
                              height: 16),

                          /// PASSWORD
                          TextFormField(
                            controller:
                                passwordController,
                            obscureText:
                                obscurePassword,
                            decoration:
                                InputDecoration(
                              labelText:
                                  "Password",
                              prefixIcon:
                                  const Icon(
                                Icons
                                    .lock_outline,
                              ),
                              suffixIcon:
                                  IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons
                                          .visibility_off_outlined
                                      : Icons
                                          .visibility,
                                ),
                                onPressed:
                                    () {
                                  setState(() {
                                    obscurePassword =
                                        !obscurePassword;
                                  });
                                },
                              ),
                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        16),
                              ),
                            ),
                            validator:
                                (v) {
                              if (v ==
                                      null ||
                                  v
                                          .length <
                                      6) {
                                return "Minimum 6 characters";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(
                              height: 10),

                          /// REMEMBER ME
                          Row(
                            children: [
                              Checkbox(
                                value:
                                    rememberMe,
                                onChanged:
                                    (v) {
                                  setState(() {
                                    rememberMe =
                                        v!;
                                  });
                                },
                              ),
                              const Text(
                                  "Remember Me"),
                              const Spacer(),
                              TextButton(
                                onPressed:
                                    () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                    "Forgot?"),
                              ),
                            ],
                          ),

                          const SizedBox(
                              height: 10),

                          /// LOGIN BUTTON
                          SizedBox(
                            width:
                                double.infinity,
                            height: 50,
                            child:
                                ElevatedButton(
                              style:
                                  ElevatedButton
                                      .styleFrom(
                                backgroundColor:
                                    const Color(
                                        0xFF4A00E0),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          16),
                                ),
                              ),
                              onPressed:
                                  isLoading
                                      ? null
                                      : _login,
                              child:
                                  isLoading
                                      ? const CircularProgressIndicator(
                                          color:
                                              Colors.white,
                                        )
                                      : const Text(
                                          "Login"),
                            ),
                          ),

                          const SizedBox(
                              height: 20),

                          /// GOOGLE SIGN IN (UI ONLY)
                          OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Add Google Sign In
                            },
                            icon: const Icon(
                                Icons.g_mobiledata),
                            label: const Text(
                                "Continue with Google"),
                          ),

                          const SizedBox(
                              height: 10),

                          /// BIOMETRIC BUTTON (UI ONLY)
                          TextButton.icon(
                            onPressed: () {
                              // TODO: Add biometric logic
                            },
                            icon: const Icon(
                                Icons.fingerprint),
                            label: const Text(
                                "Login with Fingerprint"),
                          ),

                          const SizedBox(
                              height: 10),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                            children: [
                              const Text(
                                  "New here? "),
                              TextButton(
                                onPressed:
                                    () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const SignupScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                    "Create Account"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
