import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/role_controller.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, String>> messages = [];

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
              ? "👋 Hi! I’m your Business Compliance Assistant.\n\nI can help you with:\n• GST & license renewals\n• Compliance deadlines\n• Penalty risks"
              : "👋 Hi! I’m your Personal Document Assistant.\n\nI can help you with:\n• Aadhaar, PAN, Passport\n• Expiry reminders\n• Renewal steps"
        });
      });
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final role =
        Provider.of<RoleController>(context, listen: false).role;

    setState(() {
      messages.add({"role": "user", "text": text});
    });

    _controller.clear();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        messages.add({
          "role": "ai",
          "text": _getAIResponse(text, role),
        });
      });
    });
  }

  String _getAIResponse(String query, UserRole? role) {
    if (role == UserRole.business) {
      return
          "📊 Based on your business documents:\n\n"
          "• GST Certificate expires soon\n"
          "• Shop Act License is valid\n\n"
          "⚠️ Delayed renewals may cause penalties.\n\n"
          "Would you like step-by-step compliance guidance?";
    } else {
      return
          "📄 Based on your personal documents:\n\n"
          "• Passport expires soon\n"
          "• Aadhaar & PAN are valid\n\n"
          "🕒 I recommend starting renewal early.\n\n"
          "Would you like renewal steps?";
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<RoleController>(context).role;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          role == UserRole.business
              ? "Business AI Assistant"
              : "Personal AI Assistant",
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg["role"] == "user";

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(14),
                    constraints: BoxConstraints(
                      maxWidth:
                          MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.indigo
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg["text"]!,
                      style: TextStyle(
                        color: isUser
                            ? Colors.white
                            : Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // QUICK PROMPTS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 8,
              children: role == UserRole.business
                  ? [
                      _quickPrompt("Which compliance is expiring soon?"),
                      _quickPrompt("GST renewal process"),
                    ]
                  : [
                      _quickPrompt("Which documents expire soon?"),
                      _quickPrompt("How to renew passport?"),
                    ],
            ),
          ),

          const SizedBox(height: 10),

          // INPUT
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Ask something...",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickPrompt(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () => _sendMessage(text),
    );
  }
}
