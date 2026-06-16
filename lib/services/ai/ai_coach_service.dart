import 'dart:convert';
import 'package:http/http.dart' as http;
import 'coach_mode.dart';
import '../firebase/firebase_service.dart';

class AICoachService {
  final FirebaseService _firebaseService;
  final String _apiKey;
  
  static const String baseUrl = 'https://api.openai.com/v1/chat/completions';

  AICoachService(this._firebaseService, {required String apiKey}) : _apiKey = apiKey;

  String buildPrompt({
    required CoachMode mode,
    required String rank,
    required int xp,
    required int streak,
    required String userContext,
  }) {
    String tone = switch (mode) {
      CoachMode.strict => """
You are a harsh military drill instructor. You demand excellence and accept nothing less. 
Your responses should be intense, demanding, and focused on discipline. 
Use military terminology and be direct. No excuses accepted.
""",
      CoachMode.elite => """
You are a special forces elite commander. You speak with authority and strategic wisdom.
Your responses should be professional, tactical, and focused on peak performance.
Emphasize precision, mental toughness, and elite mindset.
""",
      CoachMode.friendly => """
You are a motivating friendly coach. You encourage and support while maintaining military standards.
Your responses should be uplifting, positive, and focused on building confidence.
Use encouraging language and celebrate progress.
""",
    };

    return """
$tone

Soldier Profile:
- Rank: $rank
- XP: $xp
- Streak: $streak days
- Context: $userContext

Guidelines:
- Respond in maximum 2 sentences
- Be specific and actionable
- Maintain the personality tone
- Focus on military fitness excellence
""";
  }

  Future<String> getCoachResponse({
    required CoachMode mode,
    required String rank,
    required int xp,
    required int streak,
    required String userMessage,
    required String userContext,
  }) async {
    final prompt = buildPrompt(
      mode: mode,
      rank: rank,
      xp: xp,
      streak: streak,
      userContext: userContext,
    );

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': prompt},
            {'role': 'user', 'content': userMessage},
          ],
          'max_tokens': 100,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        
        // Save to coach memory
        await _saveToMemory(mode, userMessage, content);
        
        return content;
      } else {
        throw Exception('Failed to get AI response: ${response.statusCode}');
      }
    } catch (e) {
      return _getFallbackResponse(mode);
    }
  }

  Future<void> _saveToMemory(CoachMode mode, String userMessage, String response) async {
    if (_firebaseService.currentUser != null) {
      await _firebaseService.saveCoachMemory(
        _firebaseService.currentUser!.uid,
        {
          'mode': mode.name,
          'user_message': userMessage,
          'coach_response': response,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    }
  }

  String _getFallbackResponse(CoachMode mode) {
    switch (mode) {
      case CoachMode.strict:
        return 'Push harder! No excuses, soldier!';
      case CoachMode.elite:
        return 'Maintain focus. Precision is key.';
      case CoachMode.friendly:
        return 'You\'ve got this! Keep pushing forward!';
    }
  }

  CoachMode determineCoachMode({
    required int streak,
    required int totalXP,
    required int daysSinceLastWorkout,
  }) {
    // Weak user (inactive) -> strict mode
    if (daysSinceLastWorkout >= 3) {
      return CoachMode.strict;
    }
    
    // Consistent user -> elite mode
    if (streak >= 7) {
      return CoachMode.elite;
    }
    
    // Beginner -> friendly mode
    if (totalXP < 500) {
      return CoachMode.friendly;
    }
    
    // Default to friendly for moderate users
    return CoachMode.friendly;
  }

  Future<String> getMotivationalMessage({
    required CoachMode mode,
    required String rank,
    required int streak,
  }) async {
    final userMessage = 'Give me motivation for my workout today';
    final userContext = 'Starting a new workout session';

    return await getCoachResponse(
      mode: mode,
      rank: rank,
      xp: 0,
      streak: streak,
      userMessage: userMessage,
      userContext: userContext,
    );
  }

  Future<String> getWorkoutFeedback({
    required CoachMode mode,
    required String rank,
    required int xp,
    required String workoutType,
    required int duration,
  }) async {
    final userMessage = 'I completed a $workoutType workout for $duration minutes';
    final userContext = 'Post-workout feedback request';

    return await getCoachResponse(
      mode: mode,
      rank: rank,
      xp: xp,
      streak: 0,
      userMessage: userMessage,
      userContext: userContext,
    );
  }
}
