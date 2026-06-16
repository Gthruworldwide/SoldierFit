import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_memory_model.dart';
import 'memory_builder.dart';
import 'adaptive_personality_engine.dart';
import '../firebase/firebase_service.dart';

class EnhancedAICoachService {
  final FirebaseService _firebaseService;
  final String _apiKey;
  
  static const String baseUrl = 'https://api.openai.com/v1/chat/completions';

  EnhancedAICoachService(this._firebaseService, {required String apiKey}) 
      : _apiKey = apiKey;

  Future<UserMemoryModel> loadUserMemory(String userId) async {
    try {
      final doc = await _firebaseService.getCoachMemory(userId);
      if (doc.docs.isEmpty) {
        return _createDefaultMemory(userId);
      }

      final memoryData = doc.docs.first.data() as Map<String, dynamic>;
      return UserMemoryModel.fromJson(memoryData);
    } catch (e) {
      return _createDefaultMemory(userId);
    }
  }

  UserMemoryModel _createDefaultMemory(String userId) {
    return UserMemoryModel(
      userId: userId,
      profile: UserProfile(
        rank: 'Recruit',
        xp: 0,
        streak: 0,
        weakAreas: [],
        strongAreas: [],
        averagePerformance: 0.5,
        totalWorkouts: 0,
      ),
      history: [],
      personalityMode: CoachMode.friendly,
      lastUpdated: DateTime.now(),
    );
  }

  Future<void> saveUserMemory(UserMemoryModel memory) async {
    await _firebaseService.saveCoachMemory(
      memory.userId,
      memory.toJson(),
    );
  }

  Future<void> updateWorkoutHistory(
    String userId,
    String workoutType,
    String performance,
    int duration,
    int xpEarned,
    Map<String, dynamic> metrics,
  ) async {
    final memory = await loadUserMemory(userId);
    
    final newHistory = WorkoutHistory(
      date: DateTime.now().toIso8601String(),
      workoutType: workoutType,
      performance: performance,
      duration: duration,
      xpEarned: xpEarned,
      metrics: metrics,
    );

    // Update history
    memory.history.add(newHistory);
    
    // Keep only last 30 workouts
    if (memory.history.length > 30) {
      memory.history = memory.history.sublist(memory.history.length - 30);
    }

    // Update profile
    memory.profile.totalWorkouts++;
    memory.profile.xp += xpEarned;
    
    // Recalculate average performance
    final performanceScores = memory.history.map((h) {
      switch (h.performance) {
        case 'excellent': return 1.0;
        case 'good': return 0.75;
        case 'average': return 0.5;
        case 'poor': return 0.25;
        default: return 0.5;
      }
    });
    memory.profile.averagePerformance = 
        performanceScores.reduce((a, b) => a + b) / performanceScores.length;

    // Update weak/strong areas based on performance
    _updatePerformanceAreas(memory, newHistory);

    // Adaptive personality adjustment
    final newMode = AdaptivePersonalityEngine.determineMode(memory);
    if (newMode != memory.personalityMode) {
      memory.personalityMode = newMode;
    }

    memory.lastUpdated = DateTime.now();
    await saveUserMemory(memory);
  }

  void _updatePerformanceAreas(UserMemoryModel memory, WorkoutHistory workout) {
    // Simple logic: if performance is poor, add to weak areas
    // if performance is excellent, add to strong areas
    final workoutType = workout.workoutType.toLowerCase();

    if (workout.performance == 'poor' || workout.performance == 'average') {
      if (!memory.profile.weakAreas.contains(workoutType)) {
        memory.profile.weakAreas.add(workoutType);
      }
      // Remove from strong areas if present
      memory.profile.strongAreas.remove(workoutType);
    } else if (workout.performance == 'excellent') {
      if (!memory.profile.strongAreas.contains(workoutType)) {
        memory.profile.strongAreas.add(workoutType);
      }
      // Remove from weak areas if present
      memory.profile.weakAreas.remove(workoutType);
    }
  }

  Future<String> getPersonalizedResponse({
    required String userId,
    required String userMessage,
    required String userContext,
  }) async {
    final memory = await loadUserMemory(userId);
    
    // Build comprehensive context
    final context = MemoryBuilder.buildContext(memory);
    final performanceInsight = MemoryBuilder.buildPerformanceInsight(memory);
    final motivationalContext = MemoryBuilder.buildMotivationalContext(memory);

    final prompt = _buildEnhancedPrompt(
      memory.personalityMode,
      context,
      performanceInsight,
      motivationalContext,
      userContext,
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
          'max_tokens': 150,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        
        // Save interaction to memory
        await _saveInteraction(userId, userMessage, content, memory.personalityMode);
        
        return content;
      } else {
        throw Exception('Failed to get AI response: ${response.statusCode}');
      }
    } catch (e) {
      return _getFallbackResponse(memory.personalityMode);
    }
  }

  String _buildEnhancedPrompt(
    CoachMode mode,
    String context,
    String performanceInsight,
    String motivationalContext,
    String userContext,
  ) {
    String tone = switch (mode) {
      CoachMode.strict => """
You are a harsh military drill instructor. You demand excellence and accept nothing less. 
Your responses should be intense, demanding, and focused on discipline. 
Use military terminology and be direct. No excuses accepted.
Focus on weak areas and push for improvement.
""",
      CoachMode.elite => """
You are a special forces elite commander. You speak with authority and strategic wisdom.
Your responses should be professional, tactical, and focused on peak performance.
Emphasize precision, mental toughness, and elite mindset.
Acknowledge strengths while maintaining high standards.
""",
      CoachMode.friendly => """
You are a motivating friendly coach. You encourage and support while maintaining military standards.
Your responses should be uplifting, positive, and focused on building confidence.
Use encouraging language and celebrate progress.
Be patient with beginners while guiding them toward excellence.
""",
    };

    return """
$tone

$context

$performanceInsight

$motivationalContext

Current Context: $userContext

Guidelines:
- Respond in maximum 2-3 sentences
- Be specific and actionable
- Maintain the personality tone
- Focus on military fitness excellence
- Reference user's performance history when relevant
- Provide clear next steps
""";
  }

  Future<void> _saveInteraction(
    String userId,
    String userMessage,
    String coachResponse,
    CoachMode mode,
  ) async {
    await _firebaseService.saveCoachMemory(
      userId,
      {
        'type': 'interaction',
        'user_message': userMessage,
        'coach_response': coachResponse,
        'mode': mode.name,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
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

  Future<Map<String, dynamic>> getPersonalityAnalysis(String userId) async {
    final memory = await loadUserMemory(userId);
    final currentMode = memory.personalityMode;
    final suggestedMode = AdaptivePersonalityEngine.determineMode(memory);
    
    return {
      'currentMode': currentMode.name,
      'suggestedMode': suggestedMode.name,
      'modeChanged': currentMode != suggestedMode,
      'transitionReason': currentMode != suggestedMode
          ? AdaptivePersonalityEngine.getModeTransitionReason(
              currentMode,
              suggestedMode,
              memory,
            )
          : 'No change needed',
      'adjustmentSuggestions': AdaptivePersonalityEngine.getModeAdjustmentSuggestions(memory),
    };
  }

  Future<String> getMotivationalMessage(String userId) async {
    final memory = await loadUserMemory(userId);
    final motivationalContext = MemoryBuilder.buildMotivationalContext(memory);
    
    return await getPersonalizedResponse(
      userId: userId,
      userMessage: 'Give me motivation for my workout today',
      userContext: motivationalContext,
    );
  }
}
