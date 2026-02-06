import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final List<Map<String, dynamic>> notifications = const [
    {
      "title": "Passport Expiring Soon",
      "message": "Your passport expires on 03 Nov 2025. Start renewal now.",
      "type": "urgent",
      "date": "Today",
    },
    {
      "title": "Driving License Validity",
      "message": "Your driving license is valid till 12 Aug 2027.",
      "type": "info",
      "date": "Yesterday",
    },
    {
      "title": "Caste Certificate Renewal",
      "message": "Your caste certificate expires in 30 days.",
      "type": "warning",
      "date": "2 days ago",
    },
  ];

  Color _typeColor(String type) {
    switch (type) {
      case "urgent":
        return Colors.red;
      case "warning":
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case "urgent":
        return Icons.error_outline;
      case "warning":
        return Icons.warning_amber_outlined;
      default:
        return Icons.info_outline;
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case "urgent":
        return "Urgent";
      case "warning":
        return "Expiring Soon";
      default:
        return "Info";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final n = notifications[index];
          final color = _typeColor(n["type"]);

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.15),
                  child: Icon(
                    _typeIcon(n["type"]),
                    color: color,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        n["title"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        n["message"],
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _typeLabel(n["type"]),
                              style: TextStyle(
                                color: color,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            n["date"],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      if (n["type"] != "info") ...[
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text("Renew Now"),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
