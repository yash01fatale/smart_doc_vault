import 'package:flutter/material.dart';

class UploadDocumentScreen extends StatelessWidget {
  const UploadDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Document")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField(
              items: const [
                DropdownMenuItem(value: "Aadhaar", child: Text("Aadhaar")),
                DropdownMenuItem(value: "PAN", child: Text("PAN")),
                DropdownMenuItem(
                    value: "Driving License",
                    child: Text("Driving License")),
                DropdownMenuItem(
                    value: "Passport", child: Text("Passport")),
              ],
              onChanged: (value) {},
              decoration:
                  const InputDecoration(labelText: "Document Type"),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload),
              label: const Text("Choose File"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Save Document"),
            )
          ],
        ),
      ),
    );
  }
}
