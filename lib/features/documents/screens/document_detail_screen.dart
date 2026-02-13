import 'package:flutter/material.dart';

class DocumentDetailScreen extends StatelessWidget {
  final Map<String, dynamic> document;

  const DocumentDetailScreen({
    super.key,
    required this.document,
  });

  @override
  Widget build(BuildContext context) {

    final bool isExpiring =
        document["expiring"] ?? false;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration:
              const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4A00E0),
                Color(0xFF8E2DE2),
              ],
            ),
          ),
        ),
        title: Text(
          document["title"],
          style: const TextStyle(
              fontWeight:
                  FontWeight.bold),
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            /// 🔥 DOCUMENT CARD
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(20),
              decoration:
                  BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                        20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [

                  const Icon(
                    Icons.description,
                    size: 40,
                    color: Color(
                        0xFF4A00E0),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    document["title"],
                    style:
                        const TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _infoRow(
                    "Expiry Date",
                    document["expiry"],
                  ),

                  const SizedBox(height: 12),

                  _statusChip(
                      isExpiring),

                  const SizedBox(height: 12),

                  _infoRow(
                    "Category",
                    "Government Document",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// 🔥 ACTION BUTTONS

            if (isExpiring)
              SizedBox(
                width: double.infinity,
                child:
                    ElevatedButton.icon(
                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        const Color(
                            0xFF4A00E0),
                    padding:
                        const EdgeInsets
                            .symmetric(
                                vertical:
                                    14),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                                  14),
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(
                      Icons.refresh,
                      color:
                          Colors.white),
                  label: const Text(
                    "Start Renewal",
                    style: TextStyle(
                        color: Colors
                            .white),
                  ),
                ),
              ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style:
                    OutlinedButton
                        .styleFrom(
                  side: const BorderSide(
                      color: Color(
                          0xFF4A00E0)),
                  padding:
                      const EdgeInsets
                          .symmetric(
                              vertical:
                                  14),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                                14),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(
                  Icons
                      .visibility_outlined,
                  color:
                      Color(0xFF4A00E0),
                ),
                label: const Text(
                  "View Uploaded File",
                  style: TextStyle(
                      color: Color(
                          0xFF4A00E0)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(
    String label,
    String value,
  ) {
    return Row(
      children: [
        Text(
          "$label: ",
          style:
              const TextStyle(
            fontWeight:
                FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style:
                const TextStyle(
              color:
                  Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusChip(
      bool isExpiring) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6),
      decoration:
          BoxDecoration(
        color: isExpiring
            ? Colors.orange
                .withOpacity(0.15)
            : Colors.green
                .withOpacity(0.15),
        borderRadius:
            BorderRadius.circular(
                20),
      ),
      child: Text(
        isExpiring
            ? "Expiring Soon"
            : "Valid",
        style: TextStyle(
          color: isExpiring
              ? Colors.orange
              : Colors.green,
          fontWeight:
              FontWeight.w600,
        ),
      ),
    );
  }
}
