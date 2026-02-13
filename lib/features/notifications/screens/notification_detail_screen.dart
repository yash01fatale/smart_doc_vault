import 'package:flutter/material.dart';

class NotificationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> notification;

  const NotificationDetailScreen({
    super.key,
    required this.notification,
  });

  IconData _iconByType(String type) {
    switch (type) {
      case "expiry":
        return Icons.warning_amber_rounded;
      case "upload":
        return Icons.file_upload_outlined;
      case "ai":
        return Icons.smart_toy_outlined;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String type = notification["type"];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4A00E0),
                Color(0xFF8E2DE2)
              ],
            ),
          ),
        ),
        title: const Text("Notification Details"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor: const Color(0xFFEDE9FE),
                child: Icon(
                  _iconByType(type),
                  size: 40,
                  color: const Color(0xFF4A00E0),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              notification["title"],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              notification["message"],
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                const Icon(Icons.access_time, size: 18),
                const SizedBox(width: 6),
                Text(
                  notification["date"]
                      .toString()
                      .substring(0, 16),
                ),
              ],
            ),

            const SizedBox(height: 40),

            if (type == "expiry")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.open_in_new),
                  label:
                      const Text("View Related Document"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
