enum PomodoroSegmentType { focus, shortBreak, longBreak }

class PomodoroSegment {
  const PomodoroSegment({
    required this.type,
    required this.minutes,
    required this.index,
    this.isEstimated = false,
  });

  final PomodoroSegmentType type;
  final int minutes;
  final int index;
  final bool isEstimated;

  bool get isFocus => type == PomodoroSegmentType.focus;
}

class PomodoroSplitResult {
  const PomodoroSplitResult({
    required this.segments,
    required this.focusSegments,
    required this.usedDefaultEstimate,
  });

  final List<PomodoroSegment> segments;
  final List<PomodoroSegment> focusSegments;
  final bool usedDefaultEstimate;

  int get focusMinutes =>
      focusSegments.fold(0, (sum, item) => sum + item.minutes);
}

class PomodoroSplitService {
  const PomodoroSplitService();

  PomodoroSplitResult split({
    int? estimatedMinutes,
    int focusMinutes = 25,
    int shortBreakMinutes = 5,
    int longBreakMinutes = 20,
    int longBreakInterval = 4,
    int completedFocusCountBeforeTask = 0,
  }) {
    final safeFocus = focusMinutes <= 0 ? 25 : focusMinutes;
    final safeShortBreak = shortBreakMinutes < 0 ? 5 : shortBreakMinutes;
    final safeLongBreak = longBreakMinutes < 0 ? 20 : longBreakMinutes;
    final safeLongBreakInterval = longBreakInterval <= 0
        ? 4
        : longBreakInterval;
    final usedDefaultEstimate =
        estimatedMinutes == null || estimatedMinutes <= 0;
    var remaining = usedDefaultEstimate ? safeFocus : estimatedMinutes;

    final focusSegments = <PomodoroSegment>[];
    var focusIndex = 0;
    while (remaining > 0) {
      final minutes = remaining >= safeFocus ? safeFocus : remaining;
      focusSegments.add(
        PomodoroSegment(
          type: PomodoroSegmentType.focus,
          minutes: minutes,
          index: focusIndex,
          isEstimated: usedDefaultEstimate,
        ),
      );
      remaining -= minutes;
      focusIndex++;
    }

    final timeline = <PomodoroSegment>[];
    for (var i = 0; i < focusSegments.length; i++) {
      timeline.add(focusSegments[i]);
      final hasNextFocus = i < focusSegments.length - 1;
      if (!hasNextFocus) continue;

      final completedCount = completedFocusCountBeforeTask + i + 1;
      final useLongBreak = completedCount % safeLongBreakInterval == 0;
      timeline.add(
        PomodoroSegment(
          type: useLongBreak
              ? PomodoroSegmentType.longBreak
              : PomodoroSegmentType.shortBreak,
          minutes: useLongBreak ? safeLongBreak : safeShortBreak,
          index: i,
        ),
      );
    }

    return PomodoroSplitResult(
      segments: timeline,
      focusSegments: focusSegments,
      usedDefaultEstimate: usedDefaultEstimate,
    );
  }
}
