import 'package:flutter/material.dart';
import 'document_detail_screen.dart';
import 'upload_document_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final List<Map<String, String>> documents = const [
    {"title": "Aadhaar Card", "expiry": "Never"},
    {"title": "Driving License", "expiry": "12-08-2027"},
    {"title": "PAN Card", "expiry": "Never"},
    {"title": "Passport", "expiry": "03-11-2030"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Documents")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UploadDocumentScreen()),
          );
        },
      ),
      body: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final doc = documents[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.description),
              title: Text(doc["title"]!),
              subtitle: Text("Expiry: ${doc["expiry"]}"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        DocumentDetailScreen(document: doc),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
