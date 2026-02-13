import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import 'login_screen.dart';

enum SignupRole { personal, business }

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() =>
      _SignupScreenState();
}

class _SignupScreenState
    extends State<SignupScreen> {

  final _formKey =
      GlobalKey<FormState>();

  final nameController =
      TextEditingController();
  final emailController =
      TextEditingController();
  final mobileController =
      TextEditingController();
  final passwordController =
      TextEditingController();

  final businessNameController =
      TextEditingController();
  final businessTypeController =
      TextEditingController();
  final gstController =
      TextEditingController();

  SignupRole role =
      SignupRole.personal;

  bool isLoading = false;
  bool obscurePassword = true;

  Future<void> _signup() async {

    if (!_formKey
        .currentState!
        .validate()) return;

    setState(() =>
        isLoading = true);

    try {

      await AuthService.signup(
        fullName:
            nameController.text
                .trim(),
        email:
            emailController.text
                .trim(),
        mobile:
            mobileController.text
                .trim(),
        password:
            passwordController
                .text,
        role:
            role ==
                    SignupRole
                        .business
                ? "business"
                : "personal",
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
              "Account created successfully 🎉"),
          backgroundColor:
              Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const LoginScreen(),
        ),
      );

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
          /// 🌈 GRADIENT HEADER
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
                  Icons
                      .person_add_alt_1,
                  size: 60,
                  color:
                      Colors.white,
                ),

                SizedBox(
                    height: 12),

                Text(
                  "Create Account",
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
                  "Manage documents smartly & securely",
                  style: TextStyle(
                      color:
                          Colors.white70),
                ),
              ],
            ),
          ),

          /// =============================
          /// FORM
          /// =============================
          Expanded(
            child:
                SingleChildScrollView(
              padding:
                  const EdgeInsets
                      .all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [

                    /// BASIC INFO
                    _sectionTitle(
                        "Basic Information"),

                    const SizedBox(
                        height: 16),

                    _inputField(
                      controller:
                          nameController,
                      label:
                          "Full Name",
                      icon: Icons
                          .person_outline,
                      validator: (v) =>
                          v!.isEmpty
                              ? "Required"
                              : null,
                    ),

                    const SizedBox(
                        height: 14),

                    _inputField(
                      controller:
                          emailController,
                      label:
                          "Email",
                      icon: Icons
                          .email_outlined,
                      validator: (v) {
                        if (v ==
                                null ||
                            v.isEmpty)
                          return "Required";
                        if (!v
                            .contains("@"))
                          return "Invalid email";
                        return null;
                      },
                    ),

                    const SizedBox(
                        height: 14),

                    _inputField(
                      controller:
                          mobileController,
                      label:
                          "Mobile",
                      icon: Icons
                          .phone_outlined,
                      validator: (v) =>
                          v!.length <
                                  10
                              ? "Invalid number"
                              : null,
                    ),

                    const SizedBox(
                        height: 14),

                    _passwordField(),

                    const SizedBox(
                        height: 30),

                    /// ACCOUNT TYPE
                    _sectionTitle(
                        "Account Type"),

                    const SizedBox(
                        height: 12),

                    Row(
                      children: [

                        _roleToggle(
                          title:
                              "Personal",
                          selected:
                              role ==
                                  SignupRole
                                      .personal,
                          onTap: () {
                            setState(() {
                              role =
                                  SignupRole
                                      .personal;
                            });
                          },
                        ),

                        const SizedBox(
                            width: 10),

                        _roleToggle(
                          title:
                              "Business",
                          selected:
                              role ==
                                  SignupRole
                                      .business,
                          onTap: () {
                            setState(() {
                              role =
                                  SignupRole
                                      .business;
                            });
                          },
                        ),
                      ],
                    ),

                    /// BUSINESS FIELDS
                    AnimatedSwitcher(
                      duration:
                          const Duration(
                              milliseconds:
                                  400),
                      child: role ==
                              SignupRole
                                  .business
                          ? Column(
                              key:
                                  const ValueKey(
                                      1),
                              children: [

                                const SizedBox(
                                    height:
                                        20),

                                _sectionTitle(
                                    "Business Information"),

                                const SizedBox(
                                    height:
                                        12),

                                _inputField(
                                  controller:
                                      businessNameController,
                                  label:
                                      "Business Name",
                                  icon: Icons
                                      .business_outlined,
                                  validator: (v) =>
                                      v!
                                              .isEmpty
                                          ? "Required"
                                          : null,
                                ),

                                const SizedBox(
                                    height:
                                        12),

                                _inputField(
                                  controller:
                                      businessTypeController,
                                  label:
                                      "Business Type",
                                  icon: Icons
                                      .category_outlined,
                                  validator: (v) =>
                                      v!
                                              .isEmpty
                                          ? "Required"
                                          : null,
                                ),

                                const SizedBox(
                                    height:
                                        12),

                                _inputField(
                                  controller:
                                      gstController,
                                  label:
                                      "GST (Optional)",
                                  icon: Icons
                                      .confirmation_number_outlined,
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ),

                    const SizedBox(
                        height: 30),

                    /// CREATE BUTTON
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
                                : _signup,
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color:
                                    Colors.white,
                              )
                            : const Text(
                                "Create Account",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),

                    const SizedBox(
                        height: 16),

                    Center(
                      child:
                          TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const LoginScreen(),
                            ),
                          );
                        },
                        child:
                            const Text(
                                "Already have an account? Login"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================
  // COMPONENTS
  // =============================

  Widget _sectionTitle(
      String text) {
    return Text(
      text,
      style:
          const TextStyle(
        fontSize: 18,
        fontWeight:
            FontWeight.bold,
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration:
          InputDecoration(
        labelText: label,
        prefixIcon:
            Icon(icon),
        filled: true,
        fillColor:
            Colors.grey.shade100,
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
                  14),
          borderSide:
              BorderSide.none,
        ),
      ),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller:
          passwordController,
      obscureText:
          obscurePassword,
      validator: (v) =>
          v!.length < 6
              ? "Min 6 characters"
              : null,
      decoration:
          InputDecoration(
        labelText:
            "Password",
        prefixIcon:
            const Icon(
                Icons.lock_outline),
        suffixIcon:
            IconButton(
          icon: Icon(
            obscurePassword
                ? Icons
                    .visibility_off
                : Icons
                    .visibility,
          ),
          onPressed: () {
            setState(() {
              obscurePassword =
                  !obscurePassword;
            });
          },
        ),
        filled: true,
        fillColor:
            Colors.grey.shade100,
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
                  14),
          borderSide:
              BorderSide.none,
        ),
      ),
    );
  }

  Widget _roleToggle({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets
                  .all(14),
          decoration:
              BoxDecoration(
            color: selected
                ? const Color(
                    0xFFEDE9FE)
                : Colors.white,
            borderRadius:
                BorderRadius.circular(
                    14),
            border:
                Border.all(
              color:
                  selected
                      ? const Color(
                          0xFF4A00E0)
                      : Colors
                          .grey
                          .shade300,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style:
                  TextStyle(
                fontWeight:
                    FontWeight
                        .w600,
                color:
                    selected
                        ? const Color(
                            0xFF4A00E0)
                        : Colors
                            .black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
