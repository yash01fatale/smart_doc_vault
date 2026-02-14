import 'package:flutter/material.dart';

class RenewalGuideScreen extends StatefulWidget {
  final String documentName;

  const RenewalGuideScreen({
    super.key,
    required this.documentName,
  });

  @override
  State<RenewalGuideScreen> createState() =>
      _RenewalGuideScreenState();
}

class _RenewalGuideScreenState
    extends State<RenewalGuideScreen> {

  bool showRequiredDocs = false;

  Map<String, dynamic> _getRenewalData() {

    /// GST
    if (widget.documentName.contains("GST")) {
      return {
        "steps": [
          "Login to www.gst.gov.in",
          "Navigate to Services → Registration",
          "Select Amendment / Renewal",
          "Upload required documents",
          "Submit with DSC/EVC",
          "Download updated certificate"
        ],
        "requiredDocs": [
          "PAN Card of Business",
          "Business Registration Certificate",
          "Address Proof",
          "Authorized Signatory ID",
        ],
        "fees": "No government fee (may vary if consultant involved)",
        "processing": "3-7 working days",
      };
    }

    /// PASSPORT
    if (widget.documentName.contains("Passport")) {
      return {
        "steps": [
          "Visit passportindia.gov.in",
          "Login & select Re-issue Passport",
          "Fill application form",
          "Pay renewal fees",
          "Book appointment",
          "Visit Passport Seva Kendra"
        ],
        "requiredDocs": [
          "Old Passport",
          "Aadhaar Card",
          "Address Proof",
          "Passport Size Photos"
        ],
        "fees": "₹1500 - ₹2000 (Normal Service)",
        "processing": "7-21 working days",
      };
    }

    /// DRIVING LICENSE
    if (widget.documentName.contains("Driving")) {
      return {
        "steps": [
          "Visit parivahan.gov.in",
          "Select Driving License Services",
          "Apply for DL Renewal",
          "Upload documents",
          "Pay fees",
          "Visit RTO if required"
        ],
        "requiredDocs": [
          "Old Driving License",
          "Medical Certificate (Form 1A)",
          "Address Proof",
          "Passport Size Photo"
        ],
        "fees": "₹200 - ₹500",
        "processing": "7-14 days",
      };
    }

    /// DEFAULT
    return {
      "steps": [
        "Visit official website",
        "Login to your account",
        "Go to renewal section",
        "Upload required documents",
        "Pay applicable fees",
        "Submit application"
      ],
      "requiredDocs": [
        "Identity Proof",
        "Address Proof",
        "Old Document Copy",
      ],
      "fees": "Varies by authority",
      "processing": "5-15 working days",
    };
  }

  @override
  Widget build(BuildContext context) {

    final data = _getRenewalData();
    final List steps = data["steps"];
    final List requiredDocs = data["requiredDocs"];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      /// 🌈 GRADIENT APPBAR
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4A00E0),
                Color(0xFF8E2DE2),
              ],
            ),
          ),
        ),
        title: const Text("Renewal Guide"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            /// TITLE
            Text(
              "Renew ${widget.documentName}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// FEES + PROCESSING INFO
            _infoBox(
              "Fees",
              data["fees"],
              Icons.currency_rupee,
            ),

            const SizedBox(height: 12),

            _infoBox(
              "Processing Time",
              data["processing"],
              Icons.schedule,
            ),

            const SizedBox(height: 20),

            /// REQUIRED DOCUMENT BUTTON
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: Color(0xFF4A00E0)),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    showRequiredDocs =
                        !showRequiredDocs;
                  });
                },
                icon: const Icon(
                  Icons.folder_open,
                  color: Color(0xFF4A00E0),
                ),
                label: const Text(
                  "Required Documents",
                  style: TextStyle(
                      color:
                          Color(0xFF4A00E0)),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// SHOW REQUIRED DOCS
            if (showRequiredDocs)
              ...requiredDocs.map(
                (doc) => _requiredDocCard(doc),
              ),

            const SizedBox(height: 20),

            const Text(
              "Renewal Steps",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  return _stepCard(
                    index + 1,
                    steps[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// INFO BOX
  Widget _infoBox(
      String title,
      String value,
      IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE9FE),
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon,
              color:
                  const Color(0xFF4A00E0)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$title: $value",
              style: const TextStyle(
                  fontWeight:
                      FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  /// REQUIRED DOC CARD
  Widget _requiredDocCard(String text) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 8),
      padding:
          const EdgeInsets.all(12),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
                12),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.05),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color:
                Color(0xFF4A00E0),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  /// STEP CARD
  Widget _stepCard(
      int number,
      String text) {
    return Container(
      margin:
          const EdgeInsets.only(
              bottom: 12),
      padding:
          const EdgeInsets.all(
              14),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
                16),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor:
                const Color(
                    0xFFEDE9FE),
            child: Text(
              number.toString(),
              style:
                  const TextStyle(
                color:
                    Color(0xFF4A00E0),
                fontWeight:
                    FontWeight
                        .bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
