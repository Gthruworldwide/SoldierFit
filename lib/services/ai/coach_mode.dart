enum CoachMode {
  strict,
  elite,
  friendly,
}

extension CoachModeExtension on CoachMode {
  String get displayName {
    switch (this) {
      case CoachMode.strict:
        return 'Drill Instructor';
      case CoachMode.elite:
        return 'Elite Commander';
      case CoachMode.friendly:
        return 'Motivational Coach';
    }
  }

  String get emoji {
    switch (this) {
      case CoachMode.strict:
        return '🪖';
      case CoachMode.elite:
        return '⭐';
      case CoachMode.friendly:
        return '💪';
    }
  }
}
