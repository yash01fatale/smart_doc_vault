import 'package:flutter/material.dart';
import '../../../core/utils/role_controller.dart';
import 'document_detail_screen.dart';

class DocumentListScreen extends StatefulWidget {
  final UserRole role;
  final String? category;

  const DocumentListScreen({
    super.key,
    required this.role,
    this.category,
  });

  @override
  State<DocumentListScreen> createState() =>
      _DocumentListScreenState();
}

class _DocumentListScreenState
    extends State<DocumentListScreen>
    with TickerProviderStateMixin {

  String searchQuery = "";
  String selectedFilter = "All";

  final List<Map<String, dynamic>> documents = [
    {
  "name": "PAN Card",
  "category": "PAN",
  "expiry": DateTime(2030, 12, 31),
  "role": UserRole.personal,
},
{
  "name": "Driving License",
  "category": "License",
  "expiry": DateTime(2027, 6, 15),
  "role": UserRole.personal,
},
{
  "name": "Passport",
  "category": "Passport",
  "expiry": DateTime(2032, 9, 20),
  "role": UserRole.personal,
},
{
  "name": "Voter ID Card",
  "category": "Voter ID",
  "expiry": DateTime(2029, 4, 10),
  "role": UserRole.personal,
},
{
  "name": "Health Insurance Policy",
  "category": "Insurance",
  "expiry": DateTime(2026, 11, 30),
  "role": UserRole.personal,
},
{
  "name": "Vehicle Insurance",
  "category": "Insurance",
  "expiry": DateTime(2025, 7, 18),
  "role": UserRole.personal,
},
{
  "name": "Shop Establishment Certificate",
  "category": "Business Registration",
  "expiry": DateTime(2026, 2, 28),
  "role": UserRole.business,
},
{
  "name": "MSME Registration Certificate",
  "category": "MSME",
  "expiry": DateTime(2028, 1, 15),
  "role": UserRole.business,
},
{
  "name": "Food License (FSSAI)",
  "category": "Food License",
  "expiry": DateTime(2025, 12, 5),
  "role": UserRole.business,
},
{
  "name": "Import Export Code",
  "category": "IEC",
  "expiry": DateTime(2031, 3, 12),
  "role": UserRole.business,
},
{
  "name": "Professional Tax Certificate",
  "category": "Tax",
  "expiry": DateTime(2025, 9, 30),
  "role": UserRole.business,
},
{
  "name": "Property Registration Document",
  "category": "Property",
  "expiry": DateTime(2040, 1, 1),
  "role": UserRole.personal,
},
{
  "name": "Birth Certificate",
  "category": "Identity",
  "expiry": DateTime(2099, 1, 1),
  "role": UserRole.personal,
},
{
  "name": "Marriage Certificate",
  "category": "Legal",
  "expiry": DateTime(2099, 1, 1),
  "role": UserRole.personal,
},
{
  "name": "Company Incorporation Certificate",
  "category": "Company Registration",
  "expiry": DateTime(2035, 5, 22),
  "role": UserRole.business,
},
{
  "name": "Bank Account Statement 2025",
  "category": "Banking",
  "expiry": DateTime(2026, 4, 1),
  "role": UserRole.personal,
},
{
  "name": "Employee Contract Agreement",
  "category": "HR",
  "expiry": DateTime(2027, 10, 10),
  "role": UserRole.business,
},
{
  "name": "Rent Agreement",
  "category": "Legal",
  "expiry": DateTime(2026, 6, 30),
  "role": UserRole.personal,
},
{
  "name": "Electricity Bill",
  "category": "Utility",
  "expiry": DateTime(2025, 3, 31),
  "role": UserRole.personal,
},
{
  "name": "Fire Safety Certificate",
  "category": "Safety",
  "expiry": DateTime(2026, 8, 25),
  "role": UserRole.business,
},
{
  "name": "Pollution Control Certificate",
  "category": "Compliance",
  "expiry": DateTime(2025, 5, 14),
  "role": UserRole.business,
},
{
  "name": "ISO Certification",
  "category": "Quality",
  "expiry": DateTime(2027, 11, 11),
  "role": UserRole.business,
},

  ];

  List<Map<String, dynamic>> get filteredDocs {
    return documents.where((doc) {
      final expiry = doc["expiry"] as DateTime;
      final days =
          expiry.difference(DateTime.now()).inDays;

      final matchesRole =
          doc["role"] == widget.role;

      final matchesSearch = doc["name"]
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      bool matchesFilter = true;

      if (selectedFilter == "Expired") {
        matchesFilter = days < 0;
      } else if (selectedFilter == "Expiring") {
        matchesFilter = days >= 0 && days <= 30;
      } else if (selectedFilter == "Active") {
        matchesFilter = days > 30;
      }

      return matchesRole &&
          matchesSearch &&
          matchesFilter;
    }).toList();
  }

  Color _expiryColor(DateTime date) {
    final days =
        date.difference(DateTime.now()).inDays;

    if (days < 0) return Colors.red;
    if (days <= 30) return Colors.orange;
    return Colors.green;
  }

  String _expiryStatus(DateTime date) {
    final days =
        date.difference(DateTime.now()).inDays;

    if (days < 0) return "Expired";
    if (days <= 30) return "Expiring Soon";
    return "Active";
  }

  Future<void> _refresh() async {
    await Future.delayed(
        const Duration(seconds: 1));
    setState(() {});
  }

  void _editDocument(Map doc) {
    final nameController =
        TextEditingController(text: doc["name"]);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Text(
                  "Edit Document",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Document Name",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF4A00E0),
                    minimumSize:
                        const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    setState(() {
                      doc["name"] =
                          nameController.text;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Save Changes",
                    style:
                        TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FB),

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
        title: const Text(
          "Documents",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          children: [

            Padding(
              padding:
                  const EdgeInsets.all(16),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText:
                      "Search documents...",
                  prefixIcon:
                      const Icon(Icons.search),
                  filled: true,
                  fillColor:
                      Colors.white,
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                    borderSide:
                        BorderSide.none,
                  ),
                ),
              ),
            ),

            Expanded(
              child:
                  filteredDocs.isEmpty
                      ? const Center(
                          child: Text(
                              "No documents found"),
                        )
                      : ListView.builder(
                          padding:
                              const EdgeInsets.all(16),
                          itemCount:
                              filteredDocs.length,
                          itemBuilder:
                              (context, index) {

                            final doc =
                                filteredDocs[index];
                            final expiry =
                                doc["expiry"]
                                    as DateTime;

                            final daysLeft =
                                expiry
                                    .difference(
                                        DateTime.now())
                                    .inDays;

                            return Dismissible(
                              key: Key(doc["name"]),
                              direction:
                                  DismissDirection
                                      .endToStart,
                              background:
                                  Container(
                                alignment:
                                    Alignment.centerRight,
                                padding:
                                    const EdgeInsets.only(
                                        right: 20),
                                decoration:
                                    BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.circular(
                                          20),
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color:
                                      Colors.white,
                                ),
                              ),
                              onDismissed:
                                  (_) {
                                setState(() {
                                  documents
                                      .remove(doc);
                                });
                              },
                              child:
                                  AnimatedContainer(
                                duration:
                                    const Duration(
                                        milliseconds:
                                            300),
                                margin:
                                    const EdgeInsets.only(
                                        bottom:
                                            16),
                                child:
                                    InkWell(
                                  borderRadius:
                                      BorderRadius.circular(
                                          20),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            DocumentDetailScreen(
                                          document: {
                                            "title":
                                                doc["name"],
                                            "expiry":
                                                expiry
                                                    .toString()
                                                    .split(
                                                        " ")[0],
                                            "expiring":
                                                daysLeft <=
                                                    30,
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  onLongPress: () =>
                                      _editDocument(
                                          doc),
                                  child:
                                      Container(
                                    padding:
                                        const EdgeInsets.all(
                                            18),
                                    decoration:
                                        BoxDecoration(
                                      color:
                                          Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(
                                              20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors
                                              .black
                                              .withOpacity(
                                                  0.05),
                                          blurRadius:
                                              10,
                                        ),
                                      ],
                                    ),
                                    child:
                                        Row(
                                      children: [

                                        Container(
                                          padding:
                                              const EdgeInsets.all(
                                                  12),
                                          decoration:
                                              BoxDecoration(
                                            color:
                                                const Color(
                                                    0xFFEDE9FE),
                                            borderRadius:
                                                BorderRadius.circular(
                                                    12),
                                          ),
                                          child:
                                              const Icon(
                                            Icons
                                                .description,
                                            color:
                                                Color(
                                                    0xFF4A00E0),
                                          ),
                                        ),

                                        const SizedBox(
                                            width:
                                                14),

                                        Expanded(
                                          child:
                                              Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                            children: [

                                              Text(
                                                doc["name"],
                                                style:
                                                    const TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              ),

                                              const SizedBox(
                                                  height:
                                                      4),

                                              Text(
                                                doc["category"],
                                                style:
                                                    TextStyle(
                                                  fontSize:
                                                      13,
                                                  color: Colors
                                                      .grey
                                                      .shade600,
                                                ),
                                              ),

                                              const SizedBox(
                                                  height:
                                                      8),

                                              Row(
                                                children: [

                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal:
                                                            8,
                                                        vertical:
                                                            4),
                                                    decoration:
                                                        BoxDecoration(
                                                      color: _expiryColor(
                                                              expiry)
                                                          .withOpacity(
                                                              0.15),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child:
                                                        Text(
                                                      _expiryStatus(
                                                          expiry),
                                                      style:
                                                          TextStyle(
                                                        color: _expiryColor(
                                                            expiry),
                                                        fontSize:
                                                            11,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),

                                                  const SizedBox(
                                                      width:
                                                          8),

                                                  Text(
                                                    daysLeft <
                                                            0
                                                        ? "Expired ${daysLeft.abs()} days ago"
                                                        : "$daysLeft days left",
                                                    style:
                                                        TextStyle(
                                                      fontSize:
                                                          11,
                                                      color: Colors
                                                          .grey
                                                          .shade600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        const Icon(
                                          Icons
                                              .arrow_forward_ios,
                                          size: 16,
                                          color:
                                              Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
