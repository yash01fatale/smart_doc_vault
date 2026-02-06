import 'package:flutter/material.dart';

class DocumentDetailScreen extends StatelessWidget {
  final Map<String, dynamic> document;

  const DocumentDetailScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final bool isExpiring = document["expiring"];

    return Scaffold(
      appBar: AppBar(
        title: Text(document["title"]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DOCUMENT INFO CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document["title"],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _infoRow("Expiry Date", document["expiry"]),
                  const SizedBox(height: 10),

                  _infoRow(
                    "Status",
                    isExpiring ? "Expiring Soon" : "Valid",
                    valueColor:
                        isExpiring ? Colors.orange : Colors.green,
                  ),

                  const SizedBox(height: 10),
                  _infoRow("Category", "Government Document"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ACTIONS
            if (isExpiring)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh),
                  label: const Text("Start Renewal"),
                ),
              ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.visibility_outlined),
                label: const Text("View Uploaded File"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Text(
          "$label:",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
