import 'package:flutter/material.dart';
import '../../../core/utils/role_controller.dart';

class AddDocumentScreen extends StatefulWidget {
  final UserRole role;

  const AddDocumentScreen({
    super.key,
    required this.role,
  });

  @override
  State<AddDocumentScreen> createState() =>
      _AddDocumentScreenState();
}

class _AddDocumentScreenState
    extends State<AddDocumentScreen> {

  final _formKey =
      GlobalKey<FormState>();

  final nameController =
      TextEditingController();
  final notesController =
      TextEditingController();

  DateTime? selectedDate;
  String? selectedCategory;

  List<String> get categories {
    if (widget.role ==
        UserRole.business) {
      return [
        "GST",
        "Trade License",
        "Company Documents",
        "Compliance",
      ];
    } else {
      return [
        "Aadhaar",
        "PAN",
        "Driving License",
        "Certificates",
      ];
    }
  }

  Future<void> _pickDate() async {
    final picked =
        await showDatePicker(
      context: context,
      initialDate:
          DateTime.now(),
      firstDate:
          DateTime(2000),
      lastDate:
          DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate =
            picked;
      });
    }
  }

  void _saveDocument() {
    if (!_formKey
            .currentState!
            .validate() ||
        selectedDate == null ||
        selectedCategory == null) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
              "Please complete all fields"),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
            "Document added successfully ✅"),
        backgroundColor:
            Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    final isBusiness =
        widget.role ==
            UserRole.business;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FB),

      /// 🌈 GRADIENT APPBAR
      appBar: AppBar(
        elevation: 0,
        flexibleSpace:
            Container(
          decoration:
              const BoxDecoration(
            gradient:
                LinearGradient(
              colors: [
                Color(
                    0xFF4A00E0),
                Color(
                    0xFF8E2DE2),
              ],
            ),
          ),
        ),
        title: Text(
          isBusiness
              ? "Add Business Document"
              : "Add Personal Document",
          style:
              const TextStyle(
                  fontWeight:
                      FontWeight
                          .bold),
        ),
      ),

      body: SafeArea(
        child:
            SingleChildScrollView(
          padding:
              const EdgeInsets.all(
                  20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [

                /// 🔥 MAIN FORM CARD
                Container(
                  padding:
                      const EdgeInsets
                          .all(20),
                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white,
                    borderRadius:
                        BorderRadius
                            .circular(
                                20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors
                            .black
                            .withOpacity(
                                0.05),
                        blurRadius:
                            10,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [

                      /// DOCUMENT NAME
                      const Text(
                        "Document Name",
                        style: TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold),
                      ),
                      const SizedBox(
                          height: 8),

                      TextFormField(
                        controller:
                            nameController,
                        validator: (v) =>
                            v == null ||
                                    v
                                        .isEmpty
                                ? "Required"
                                : null,
                        decoration:
                            _inputDecoration(
                          "Enter document name",
                        ),
                      ),

                      const SizedBox(
                          height: 20),

                      /// CATEGORY
                      const Text(
                        "Category",
                        style: TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold),
                      ),
                      const SizedBox(
                          height: 12),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: categories
                            .map(
                              (cat) =>
                                  ChoiceChip(
                                label:
                                    Text(cat),
                                selected:
                                    selectedCategory ==
                                        cat,
                                selectedColor:
                                    const Color(
                                        0xFFEDE9FE),
                                onSelected:
                                    (_) {
                                  setState(() {
                                    selectedCategory =
                                        cat;
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),

                      const SizedBox(
                          height: 20),

                      /// EXPIRY DATE
                      const Text(
                        "Expiry Date",
                        style: TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold),
                      ),
                      const SizedBox(
                          height: 8),

                      InkWell(
                        onTap:
                            _pickDate,
                        borderRadius:
                            BorderRadius
                                .circular(
                                    14),
                        child:
                            Container(
                          padding:
                              const EdgeInsets.symmetric(
                                  vertical:
                                      14,
                                  horizontal:
                                      12),
                          decoration:
                              BoxDecoration(
                            color: Colors
                                .grey
                                .shade100,
                            borderRadius:
                                BorderRadius.circular(
                                    14),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons
                                    .calendar_today,
                                size: 18,
                                color:
                                    Color(
                                        0xFF4A00E0),
                              ),
                              const SizedBox(
                                  width:
                                      10),
                              Text(
                                selectedDate ==
                                        null
                                    ? "Select expiry date"
                                    : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(
                          height: 20),

                      /// NOTES
                      const Text(
                        "Notes (Optional)",
                        style: TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold),
                      ),
                      const SizedBox(
                          height: 8),

                      TextFormField(
                        controller:
                            notesController,
                        maxLines: 3,
                        decoration:
                            _inputDecoration(
                                "Add additional notes"),
                      ),

                      const SizedBox(
                          height: 20),

                      /// FILE UPLOAD PLACEHOLDER
                      Container(
                        padding:
                            const EdgeInsets.all(
                                16),
                        decoration:
                            BoxDecoration(
                          border:
                              Border.all(
                                  color: Colors
                                      .grey
                                      .shade300),
                          borderRadius:
                              BorderRadius.circular(
                                  14),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons
                                  .upload_file,
                              color: Color(
                                  0xFF4A00E0),
                            ),
                            SizedBox(
                                width: 10),
                            Text(
                                "Upload Document (Coming Soon)"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                    height: 30),

                /// SAVE BUTTON
                SizedBox(
                  width:
                      double.infinity,
                  height: 50,
                  child:
                      ElevatedButton(
                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          const Color(
                              0xFF4A00E0),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                16),
                      ),
                    ),
                    onPressed:
                        _saveDocument,
                    child:
                        const Text(
                      "Save Document",
                      style: TextStyle(
                          color: Colors
                              .white,
                          fontWeight:
                              FontWeight
                                  .bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
      String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor:
          Colors.grey.shade100,
      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
                14),
        borderSide:
            BorderSide.none,
      ),
    );
  }
}
