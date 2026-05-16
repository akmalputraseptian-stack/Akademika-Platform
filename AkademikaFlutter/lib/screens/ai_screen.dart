import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

import 'package:google_generative_ai/google_generative_ai.dart';
import '../services/gemini_service.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final List<Content> _chatHistory = [];
  bool _isTyping = false;
  final GeminiService _geminiService = GeminiService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      setState(() {
        final welcomeMsg = 'Halo ${user?.nama.split(' ')[0]}! Saya Akademika. Tanya aja apa pun soal kuliahmu, saya siap bantu cari solusinya!';
        _messages.add({
          'role': 'ai',
          'content': welcomeMsg
        });
        _chatHistory.add(Content.model([TextPart(welcomeMsg)]));
      });
    });
  }

  Future<void> _handleSend(String text) async {
    if (text.trim().isEmpty) return;
    
    final userMessage = text.trim();
    setState(() {
      _messages.add({'role': 'user', 'content': userMessage});
      _controller.clear();
      _isTyping = true;
    });

    final response = await _geminiService.getChatResponse(
      userMessage, 
      history: _chatHistory
    );

    if (!mounted) return;

    setState(() {
      _isTyping = false;
      _messages.add({'role': 'ai', 'content': response});
      _chatHistory.add(Content.multi([TextPart(userMessage)])); // User part
      _chatHistory.add(Content.model([TextPart(response)]));    // Model part
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), // Kembali ke warna terang elegan
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDCE3EB)),
            ),
            child: const Icon(LucideIcons.arrowLeft, size: 20, color: Color(0xFF316483)),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F8),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFDCE3EB)),
              ),
              child: Image.asset(
                'assets/images/logo.png',
                width: 28,
                height: 28,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Akademika Tanya Aja', 
                  style: GoogleFonts.poppins(
                    fontSize: 15, 
                    fontWeight: FontWeight.bold, 
                    color: const Color(0xFF2C3339)
                  )
                ),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    const Text('Sistem Aktif', style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFEAEEF4), height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return _buildTypingIndicator(colorScheme);
                }

                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!isUser) _buildAiAvatar(colorScheme),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          decoration: BoxDecoration(
                            color: isUser ? colorScheme.primary : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: Radius.circular(isUser ? 20 : 4),
                              bottomRight: Radius.circular(isUser ? 4 : 20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                            border: isUser ? null : Border.all(color: const Color(0xFFEAEEF4)),
                          ),
                          child: Text(
                            msg['content']!,
                            style: GoogleFonts.inter(
                              color: isUser ? Colors.white : const Color(0xFF2C3339),
                              fontSize: 14,
                              height: 1.5,
                              fontWeight: isUser ? FontWeight.w500 : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (isUser) _buildUserAvatar(),
                    ],
                  ),
                );
              },
            ),
          ),
          _buildMessageInput(colorScheme),
        ],
      ),
    );
  }

  Widget _buildAiAvatar(ColorScheme colorScheme) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFDCE3EB)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
      ),
      child: CircleAvatar(
        radius: 18,
        backgroundImage: NetworkImage(user?.profilePic ?? 'https://picsum.photos/seed/user/200'),
      ),
    );
  }

  Widget _buildTypingIndicator(ColorScheme colorScheme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 48, bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEAEEF4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.primary.withOpacity(0.5)),
            ),
            const SizedBox(width: 10),
            Text('Menyusun jawaban...', style: TextStyle(fontSize: 11, color: Colors.grey[400], fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FD),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFEAEEF4)),
                ),
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF2C3339)),
                  decoration: const InputDecoration(
                    hintText: 'Tulis pertanyaan di sini...',
                    hintStyle: TextStyle(color: Color(0xFFACB3BA), fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  onSubmitted: _handleSend,
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => _handleSend(_controller.text),
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.3), 
                      blurRadius: 12, 
                      offset: const Offset(0, 6)
                    )
                  ],
                ),
                child: const Icon(LucideIcons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
