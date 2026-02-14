import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  UserModel? user;
  bool isLoading = true;
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  /// Default empty user
  UserModel _emptyUser() {
    return UserModel(
      name: "",
      email: "",
      address: "",
      village: "",
      taluka: "",
      district: "",
      state: "",
      country: "",
      signupDate: "",
      role: '',
    );
  }

  /// Load profile safely
  Future<void> loadProfile() async {
    try {
      String token = "YOUR_JWT_TOKEN";

      final result = await ProfileService.fetchProfile(token);

      if (!mounted) return; // ⭐ lifecycle fix

      setState(() {
        user = result ?? _emptyUser();
        isLoading = false;
      });

    } catch (e) {

      if (!mounted) return; // ⭐ lifecycle fix

      setState(() {
        user = _emptyUser();
        isLoading = false;
      });
    }
  }

  /// Pick image safely
  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);

    if (!mounted) return;

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  /// Edit profile sheet
  void _openEditSheet() {

    final nameController = TextEditingController(text: user?.name ?? "");
    final addressController = TextEditingController(text: user?.address ?? "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Container(
                  height: 4,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: nameController,
                  decoration: _inputDecoration("Name"),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: addressController,
                  decoration: _inputDecoration("Address"),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A00E0),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {

                    if (!mounted) return;

                    setState(() {
                      user = user!.copyWith(
                        name: nameController.text,
                        address: addressController.text,
                      );
                    });

                    Navigator.pop(context);
                  },
                  child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
            ),
          ),
        ),
        title: const Text("My Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  /// PROFILE HEADER
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      children: [

                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: const Color(0xFFEDE9FE),
                            backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                            child: _selectedImage == null
                                ? const Icon(Icons.person, size: 50, color: Color(0xFF4A00E0))
                                : null,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          user?.name.isNotEmpty == true ? user!.name : "Add Your Name",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),

                        Text(
                          user?.email.isNotEmpty == true ? user!.email : "Add Email",
                          style: const TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 12),

                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A00E0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          icon: const Icon(Icons.edit, color: Colors.white),
                          label: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
                          onPressed: _openEditSheet,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  _infoCard(),
                ],
              ),
            ),
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          _infoRow("Address", user?.address ?? ""),
          const Divider(),
          _infoRow("Village", user?.village ?? ""),
          const Divider(),
          _infoRow("Taluka", user?.taluka ?? ""),
          const Divider(),
          _infoRow("District", user?.district ?? ""),
          const Divider(),
          _infoRow("State", user?.state ?? ""),
          const Divider(),
          _infoRow("Country", user?.country ?? ""),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(color: Colors.grey))),
          Text(value.isNotEmpty ? value : "Not Added", style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
