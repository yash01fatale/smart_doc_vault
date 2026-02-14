import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {

  final _formKey =
      GlobalKey<FormState>();

  final emailController =
      TextEditingController();

  bool isLoading = false;
  bool emailSent = false;

  Future<void> _resetPassword() async {

    if (!_formKey
        .currentState!
        .validate()) {
      return;
    }

    setState(() =>
        isLoading = true);

    try {

      await AuthService
          .forgotPassword(
        email: emailController
            .text
            .trim(),
      );

      setState(() {
        emailSent = true;
      });

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
              Text(e.toString()),
          backgroundColor:
              Colors.redAccent,
        ),
      );

    } finally {

      setState(() =>
          isLoading = false);
    }
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FB),

      body: Column(
        children: [

          /// =============================
          /// 🌈 HEADER
          /// =============================
          Container(
            height: 260,
            width:
                double.infinity,
            padding:
                const EdgeInsets
                    .all(24),
            decoration:
                const BoxDecoration(
              gradient:
                  LinearGradient(
                colors: [
                  Color(
                      0xFF4A00E0),
                  Color(
                      0xFF8E2DE2),
                ],
              ),
              borderRadius:
                  BorderRadius.only(
                bottomLeft:
                    Radius.circular(
                        32),
                bottomRight:
                    Radius.circular(
                        32),
              ),
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment
                      .center,
              children: const [

                Icon(
                  Icons.lock_reset,
                  size: 64,
                  color:
                      Colors.white,
                ),

                SizedBox(
                    height: 12),

                Text(
                  "Reset Password",
                  style: TextStyle(
                    color:
                        Colors.white,
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                SizedBox(
                    height: 6),

                Text(
                  "We’ll send you a reset link",
                  style: TextStyle(
                      color:
                          Colors.white70),
                ),
              ],
            ),
          ),

          /// =============================
          /// BODY
          /// =============================
          Expanded(
            child:
                SingleChildScrollView(
              padding:
                  const EdgeInsets
                      .all(24),
              child: emailSent
                  ? _successView()
                  : _resetForm(),
            ),
          ),
        ],
      ),
    );
  }

  /// =============================
  /// RESET FORM
  /// =============================
  Widget _resetForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [

          const Text(
            "Enter your email",
            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
              height: 20),

          TextFormField(
            controller:
                emailController,
            validator: (v) {
              if (v ==
                      null ||
                  v.isEmpty) {
                return "Email required";
              }
              if (!v
                  .contains("@")) {
                return "Invalid email";
              }
              return null;
            },
            decoration:
                InputDecoration(
              labelText:
                  "Email",
              prefixIcon:
                  const Icon(
                      Icons.email_outlined),
              filled: true,
              fillColor:
                  Colors.grey
                      .shade100,
              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                        14),
                borderSide:
                    BorderSide.none,
              ),
            ),
          ),

          const SizedBox(
              height: 30),

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
                      : _resetPassword,
              child: isLoading
                  ? const CircularProgressIndicator(
                      color:
                          Colors.white,
                    )
                  : const Text(
                      "Send Reset Link",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /// =============================
  /// SUCCESS VIEW
  /// =============================
  Widget _successView() {
    return Column(
      children: [

        const Icon(
          Icons.check_circle,
          size: 80,
          color: Colors.green,
        ),

        const SizedBox(
            height: 20),

        const Text(
          "Reset link sent!",
          style: TextStyle(
            fontSize: 20,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(
            height: 10),

        const Text(
          "Check your email and follow the instructions to reset your password.",
          textAlign:
              TextAlign.center,
          style: TextStyle(
              color:
                  Colors.grey),
        ),

        const SizedBox(
            height: 30),

        ElevatedButton(
          style:
              ElevatedButton
                  .styleFrom(
            backgroundColor:
                const Color(
                    0xFF4A00E0),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const LoginScreen(),
              ),
            );
          },
          child: const Text(
            "Back to Login",
            style: TextStyle(
                color:
                    Colors.white),
          ),
        ),
      ],
    );
  }
}
