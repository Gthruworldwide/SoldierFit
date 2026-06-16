import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../services/ai/coach_mode.dart';

class CoachPage extends StatefulWidget {
  const CoachPage({super.key});

  @override
  State<CoachPage> createState() => _CoachPageState();
}

class _CoachPageState extends State<CoachPage> {
  CoachMode _selectedMode = CoachMode.friendly;
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Welcome, soldier! I\'m your AI coach. Select your preferred coaching style and let\'s begin training.',
      isFromCoach: true,
      mode: CoachMode.friendly,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.tacticalBlack,
      appBar: AppBar(
        title: const Text('AI COACH'),
        backgroundColor: AppTheme.tacticalBlack,
      ),
      body: Column(
        children: [
          _buildModeSelector(),
          Expanded(
            child: _buildChatArea(),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildModeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        border: Border(
          bottom: BorderSide(color: AppTheme.militaryGreen, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'COACHING MODE',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppTheme.neonGreen,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: CoachMode.values.map((mode) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMode = mode;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      right: mode != CoachMode.values.last ? 8 : 0,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _selectedMode == mode
                          ? AppTheme.neonGreen
                          : AppTheme.tacticalBlack,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _selectedMode == mode
                            ? AppTheme.neonGreen
                            : AppTheme.militaryGreen,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          mode.emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mode.displayName,
                          style: TextStyle(
                            color: _selectedMode == mode
                                ? Colors.black
                                : Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: message.isFromCoach
            ? AppTheme.primaryDark
            : AppTheme.militaryGreen.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: message.isFromCoach
              ? AppTheme.militaryGreen
              : AppTheme.neonGreen,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.isFromCoach)
            Row(
              children: [
                Text(
                  message.mode.emoji,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  message.mode.displayName,
                  style: TextStyle(
                    color: AppTheme.gold,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
          Text(
            message.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        border: Border(
          top: BorderSide(color: AppTheme.militaryGreen, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Ask your coach...',
                filled: true,
                fillColor: AppTheme.tacticalBlack,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.militaryGreen),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.militaryGreen),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.neonGreen, width: 2),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.neonGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: _sendMessage,
              icon: const Icon(Icons.send, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isFromCoach: false,
        mode: _selectedMode,
      ));
      _messageController.clear();

      // Simulate coach response
      _simulateCoachResponse(message);
    });
  }

  void _simulateCoachResponse(String userMessage) {
    // In a real implementation, this would call the AI service
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: _getCoachResponse(userMessage),
            isFromCoach: true,
            mode: _selectedMode,
          ));
        });
      }
    });
  }

  String _getCoachResponse(String userMessage) {
    switch (_selectedMode) {
      case CoachMode.strict:
        return 'That\'s not good enough, soldier! Push harder or get left behind!';
      case CoachMode.elite:
        return 'Maintain tactical focus. Precision and discipline will lead to victory.';
      case CoachMode.friendly:
        return 'Great question! Keep that momentum going and you\'ll reach your goals!';
    }
  }
}

class ChatMessage {
  final String text;
  final bool isFromCoach;
  final CoachMode mode;

  ChatMessage({
    required this.text,
    required this.isFromCoach,
    required this.mode,
  });
}
