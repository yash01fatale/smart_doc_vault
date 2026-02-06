import 'package:flutter/material.dart';

class DocumentDetailScreen extends StatelessWidget {
  final Map<String, String> document;

  const DocumentDetailScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(document["title"]!)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              document["title"]!,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text("Expiry Date: ${document["expiry"]}"),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Renew Document"),
            )
          ],
        ),
      ),
    );
  }
}
