import 'package:flutter/material.dart';
import 'package:smart_doc_vault/features/notifications/screens/notifications_screen.dart';
import '../../../core/utils/role_controller.dart';
import '../screens/document_list_screen.dart';
import '../screens/add_document_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../screens/ai_assistant_screen.dart';
import '../screens/document_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  final UserRole userRole;

  const DashboardScreen({super.key, required this.userRole});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  /// 🔥 Documents moved inside state (correct structure)
  final List<Map<String, dynamic>> documents = [
    {
      "name": "GST Certificate",
      "category": "GST",
      "expiry": DateTime(2026, 5, 10),
    },
    {
      "name": "Passport",
      "category": "Passport",
      "expiry": DateTime(2025, 8, 1),
    },
    {"name": "PAN Card", "category": "PAN", "expiry": DateTime(2030, 12, 31)},
    {
      "name": "Trade License",
      "category": "License",
      "expiry": DateTime(2025, 3, 5),
    },
  ];

  @override
  Widget _animatedCounter(int value) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: const Duration(seconds: 1),
      builder: (context, val, _) {
        return Text(
          val.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    final pages = [
      _homePage(),
      DocumentListScreen(role: widget.userRole),
      const AIAssistantScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: pages[_selectedIndex],

      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFEDE9FE),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder),
            label: "Documents",
          ),
          NavigationDestination(
            icon: Icon(Icons.smart_toy_outlined),
            selectedIcon: Icon(Icons.smart_toy),
            label: "AI",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  // =================================================
  // 🔥 HOME PAGE
  // =================================================

  Widget _homePage() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerSection(),
            const SizedBox(height: 20),
            _expiryAlertBanner(),

            /// 📊 STATS
            Row(
              children: [
                Expanded(
                  child: _miniStatCard(
                    documents.length,
                    "Documents",
                    Icons.folder,
                  ),
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: _miniStatCard(
                    _expiringCount(),
                    "Expiring",
                    Icons.warning,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            const SizedBox(height: 25),
            _aiRecommendationCard(),

            /// 🚀 QUICK ACTIONS
            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                _squareQuickAction("Add", Icons.add, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddDocumentScreen(role: widget.userRole),
                    ),
                  );
                }),
                _squareQuickAction("Docs", Icons.folder, () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                }),
                _squareQuickAction("AI", Icons.smart_toy, () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                }),
                _squareQuickAction("Profile", Icons.person, () {
                  setState(() {
                    _selectedIndex = 3;
                  });
                }),
              ],
            ),

            const SizedBox(height: 30),

            /// 📄 RECENT DOCUMENTS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Documents",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: const Text("View All"),
                ),
              ],
            ),

            const SizedBox(height: 12),

            ...documents.take(4).map((doc) {
              final expiry = doc["expiry"] as DateTime;
              final daysLeft = expiry.difference(DateTime.now()).inDays;

              return _recentDocumentCard(doc, expiry, daysLeft);
            }).toList(),
          ],
        ),
      ),
    );
  }

  // =================================================
  // 🔥 HEADER
  // =================================================
  Widget _expiryAlertBanner() {
    final expiringDocs =
        documents.where((doc) {
          final days =
              (doc["expiry"] as DateTime).difference(DateTime.now()).inDays;
          return days <= 30 && days >= 0;
        }).toList();

    if (expiringDocs.isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "${expiringDocs.length} documents expiring soon. Take action now.",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedIndex = 1;
              });
            },
            child: const Text("View"),
          ),
        ],
      ),
    );
  }

  Widget _headerSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
        ),
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome 👋",
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              SizedBox(height: 6),
              Text(
                "Your Document Vault",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  );
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.notifications_outlined,
                    color: Color(0xFF4A00E0),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = 3;
                  });
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Color(0xFF4A00E0)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =================================================
  // 🔥 COMPONENTS
  // =================================================
  Widget _aiRecommendationCard() {
    final expiring = _expiringCount();

    if (expiring == 0) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.smart_toy, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "AI suggests reviewing $expiring expiring documents for renewal.",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedIndex = 2;
              });
            },
            child: const Text("Open AI", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _squareQuickAction(String title, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            height: 85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDE9FE),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: const Color(0xFF4A00E0)),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _miniStatCard(int number, String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4A00E0)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _animatedCounter(number),
              Text(title, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _recentDocumentCard(
    Map<String, dynamic> doc,
    DateTime expiry,
    int daysLeft,
  ) {
    Color statusColor;

    if (daysLeft < 0) {
      statusColor = Colors.red;
    } else if (daysLeft <= 30) {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => DocumentDetailScreen(
                    document: {
                      "title": doc["name"],
                      "expiry": expiry.toString().split(" ")[0],
                      "expiring": daysLeft <= 30,
                    },
                  ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.description, color: Color(0xFF4A00E0)),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc["name"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      doc["category"],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      daysLeft < 0
                          ? "Expired ${daysLeft.abs()} days ago"
                          : "$daysLeft days left",
                      style: TextStyle(
                        fontSize: 11,
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  int _expiringCount() {
    return documents.where((doc) {
      final days =
          (doc["expiry"] as DateTime).difference(DateTime.now()).inDays;
      return days <= 30 && days >= 0;
    }).length;
  }
}
