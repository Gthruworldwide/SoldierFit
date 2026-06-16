import 'package:intl/intl.dart';

class Formatters {
  static String formatXP(int xp) {
    if (xp >= 1000) {
      return '${(xp / 1000).toStringAsFixed(1)}K';
    }
    return xp.toString();
  }
  
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
  
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
  
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
  
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, HH:mm').format(date);
  }
  
  static String formatStreak(int streak) {
    if (streak == 0) return 'No streak';
    if (streak == 1) return '1 day';
    return '$streak days';
  }
  
  static String getRankProgress(int currentXP, int nextRankXP) {
    final progress = (currentXP / nextRankXP * 100).clamp(0, 100);
    return '${progress.toStringAsFixed(0)}%';
  }
}
