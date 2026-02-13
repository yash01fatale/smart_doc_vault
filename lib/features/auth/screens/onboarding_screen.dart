import 'package:flutter/material.dart';
import '../../../core/storage/local_storage.dart';
import 'role_selection_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends State<OnboardingScreen> {

  final PageController _pageController =
      PageController();

  int _currentIndex = 0;

  final List<_OnboardData> _pages = const [

    _OnboardData(
      icon: Icons.folder_open_outlined,
      title: "All Documents in One Place",
      subtitle:
          "Store personal, family or business documents securely and access them anytime.",
    ),

    _OnboardData(
      icon: Icons.notifications_active_outlined,
      title: "Never Miss an Expiry",
      subtitle:
          "Get smart reminders before documents expire and avoid penalties.",
    ),

    _OnboardData(
      icon: Icons.smart_toy_outlined,
      title: "AI-Powered Guidance",
      subtitle:
          "Our AI assistant helps you understand renewals and next steps easily.",
    ),
  ];

  Future<void> _completeOnboarding() async {

    await LocalStorage.setOnboardingSeen();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const RoleSelectionScreen(),
      ),
    );
  }

  void _next() {

    if (_currentIndex < _pages.length - 1) {

      _pageController.nextPage(
        duration:
            const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A00E0),
              Color(0xFF8E2DE2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              /// SKIP BUTTON
              Align(
                alignment:
                    Alignment.centerRight,
                child: TextButton(
                  onPressed:
                      _completeOnboarding,
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              /// PAGE VIEW
              Expanded(
                child: PageView.builder(
                  controller:
                      _pageController,
                  itemCount:
                      _pages.length,
                  onPageChanged:
                      (index) {
                    setState(() {
                      _currentIndex =
                          index;
                    });
                  },
                  itemBuilder:
                      (context, index) {

                    final page =
                        _pages[index];

                    return Padding(
                      padding:
                          const EdgeInsets.all(
                              32),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: [

                          /// ICON WITH ANIMATION
                          AnimatedScale(
                            duration:
                                const Duration(
                                    milliseconds:
                                        400),
                            scale:
                                _currentIndex ==
                                        index
                                    ? 1.0
                                    : 0.8,
                            child:
                                Container(
                              padding:
                                  const EdgeInsets
                                      .all(30),
                              decoration:
                                  BoxDecoration(
                                shape:
                                    BoxShape
                                        .circle,
                                color: Colors
                                    .white
                                    .withOpacity(
                                        0.15),
                                border:
                                    Border.all(
                                  color: Colors
                                      .white
                                      .withOpacity(
                                          0.3),
                                ),
                              ),
                              child: Icon(
                                page.icon,
                                size: 90,
                                color: Colors
                                    .white,
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: 40),

                          Text(
                            page.title,
                            style:
                                const TextStyle(
                              fontSize: 26,
                              fontWeight:
                                  FontWeight
                                      .bold,
                              color:
                                  Colors.white,
                            ),
                            textAlign:
                                TextAlign.center,
                          ),

                          const SizedBox(
                              height: 16),

                          Text(
                            page.subtitle,
                            style:
                                const TextStyle(
                              fontSize: 15,
                              color:
                                  Colors.white70,
                              height: 1.5,
                            ),
                            textAlign:
                                TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// DOT INDICATOR
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                children: List.generate(
                  _pages.length,
                  (index) =>
                      AnimatedContainer(
                    duration:
                        const Duration(
                            milliseconds:
                                300),
                    margin:
                        const EdgeInsets
                            .symmetric(
                                horizontal:
                                    4),
                    height: 8,
                    width:
                        _currentIndex ==
                                index
                            ? 24
                            : 8,
                    decoration:
                        BoxDecoration(
                      color:
                          _currentIndex ==
                                  index
                              ? Colors
                                  .white
                              : Colors
                                  .white54,
                      borderRadius:
                          BorderRadius
                              .circular(
                                  10),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                  height: 40),

              /// CTA BUTTON
              Padding(
                padding:
                    const EdgeInsets
                        .symmetric(
                            horizontal:
                                24),
                child: SizedBox(
                  width:
                      double.infinity,
                  height: 50,
                  child:
                      ElevatedButton(
                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          Colors.white,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                16),
                      ),
                    ),
                    onPressed:
                        _next,
                    child: Text(
                      _currentIndex ==
                              _pages.length - 1
                          ? "Get Started"
                          : "Next",
                      style:
                          const TextStyle(
                        color: Color(
                            0xFF4A00E0),
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                  height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardData {
  final IconData icon;
  final String title;
  final String subtitle;

  const _OnboardData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
