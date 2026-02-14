import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/role_controller.dart';

/// ⚠ IMPORTANT:
/// Android Emulator → 10.0.2.2
/// Real Device → Use your PC local IP
final Uri url = Uri.parse("http://127.0.0.1:8000/api/ai/ask");


class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> messages = [];
  bool isTyping = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final role =
          Provider.of<RoleController>(context, listen: false).role;

      setState(() {
        messages.add({
          "role": "ai",
          "text": role == UserRole.business
              ? "👋 Welcome! I’m your Business Compliance AI.\n\nI help with:\n• GST & License renewals\n• Compliance alerts\n• Penalty prevention"
              : "👋 Welcome! I’m your Personal Document AI.\n\nI help with:\n• Passport, Aadhaar, PAN\n• Expiry reminders\n• Renewal guidance"
        });
      });
    });
  }

  // ==============================
  // 🔥 SEND MESSAGE
  // ==============================
  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": text});
      isTyping = true;
    });

    _controller.clear();
    _scrollToBottom();

    await _callAIBackend(text);

    setState(() {
      isTyping = false;
    });

    _scrollToBottom();
  }

  // ==============================
  // 🔥 CALL BACKEND API
  // ==============================
  Future<void> _callAIBackend(String question) async {
    try {
      final role =
          Provider.of<RoleController>(context, listen: false).role;

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "question": question,
          "role": role.toString(), // optional: send role to backend
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          messages.add({
            "role": "ai",
            "text": data["answer"] ?? "No response from AI",
          });
        });
      } else {
        setState(() {
          messages.add({
            "role": "ai",
            "text": "⚠ Server error. Please try again.",
          });
        });
      }
    } catch (e) {
      setState(() {
        messages.add({
          "role": "ai",
          "text": "⚠ Unable to connect to server.",
        });
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<RoleController>(context).role;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      // 🌈 Gradient AppBar
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
            ),
          ),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.smart_toy, color: Colors.deepPurple),
            ),
            const SizedBox(width: 10),
            Text(
              role == UserRole.business
                  ? "Business AI"
                  : "Personal AI",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),

      body: Column(
        children: [

          // ================= CHAT AREA =================
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {

                if (isTyping && index == messages.length) {
                  return _typingIndicator();
                }

                final msg = messages[index];
                final isUser = msg["role"] == "user";

                return _chatBubble(msg["text"]!, isUser);
              },
            ),
          ),

          _quickPromptSection(role),
          _inputBar(),
        ],
      ),
    );
  }

  Widget _chatBubble(String text, bool isUser) {
    return Align(
      alignment:
          isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF4A00E0) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _typingIndicator() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("AI is typing..."),
      ),
    );
  }

  Widget _quickPromptSection(UserRole? role) {
    final prompts = role == UserRole.business
        ? [
            "Which compliance expires soon?",
            "GST renewal process"
          ]
        : [
            "Which documents expire soon?",
            "How to renew passport?"
          ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Wrap(
        spacing: 8,
        children:
            prompts.map((text) => ActionChip(
              backgroundColor: Colors.deepPurple.shade50,
              label: Text(text),
              onPressed: () => _sendMessage(text),
            )).toList(),
      ),
    );
  }

  Widget _inputBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black12,
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Ask your AI assistant...",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: const Color(0xFF4A00E0),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _sendMessage(_controller.text),
            ),
          ),
        ],
      ),
    );
  }
}
