import 'package:flutter/material.dart';
import '../../../core/utils/role_controller.dart';
import '../../../shared/widgets/document_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../auth/screens/document_detail_screen.dart';
import '../../auth/screens/upload_document_screen.dart';

class DashboardScreen extends StatelessWidget {
  final UserRole userRole;

  const DashboardScreen({super.key, required this.userRole});

  List<Map<String, dynamic>> _getDocuments() {
    if (userRole == UserRole.personal) {
      return [
        {
          "title": "Aadhaar Card",
          "expiry": "Never",
          "expiring": false,
        },
        {
          "title": "Passport",
          "expiry": "03 Nov 2025",
          "expiring": true,
        },
      ];
    } else {
      return [
        {
          "title": "GST Certificate",
          "expiry": "15 Apr 2025",
          "expiring": true,
        },
        {
          "title": "Shop Act License",
          "expiry": "20 Dec 2026",
          "expiring": false,
        },
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final documents = _getDocuments();
    final expiringCount =
        documents.where((d) => d["expiring"] == true).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          userRole == UserRole.personal
              ? "My Documents"
              : "Business Documents",
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Add Document"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const UploadDocumentScreen(),
            ),
          );
        },
      ),

      body: documents.isEmpty
          ? EmptyState(
              icon: Icons.folder_open,
              title: "No documents yet",
              subtitle: userRole == UserRole.personal
                  ? "Upload your personal or family documents to track expiry dates."
                  : "Upload business compliance documents to track renewals.",
              actionText: "Upload Document",
              onAction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UploadDocumentScreen(),
                  ),
                );
              },
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 SUMMARY (FIRST THING USER SEES)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: expiringCount > 0
                            ? Colors.orange.shade100
                            : Colors.green.shade100,
                        child: Icon(
                          expiringCount > 0
                              ? Icons.warning_amber_outlined
                              : Icons.check_circle_outline,
                          color: expiringCount > 0
                              ? Colors.orange
                              : Colors.green,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userRole == UserRole.personal
                                  ? "Document Status"
                                  : "Compliance Status",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              expiringCount > 0
                                  ? "$expiringCount document(s) expiring soon"
                                  : "All documents are valid",
                              style: TextStyle(
                                color: expiringCount > 0
                                    ? Colors.orange
                                    : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔹 SECTION TITLE
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Your Documents",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // 🔹 DOCUMENT LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final doc = documents[index];
                      return DocumentCard(
                        title: doc["title"],
                        expiry: doc["expiry"],
                        isExpiringSoon: doc["expiring"],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DocumentDetailScreen(document: doc),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
