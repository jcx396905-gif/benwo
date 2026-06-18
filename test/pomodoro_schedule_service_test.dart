import 'package:benwo/application/pomodoro/pomodoro_schedule_service.dart';
import 'package:benwo/data/models/pomodoro_task_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const service = PomodoroScheduleService();

  PomodoroTaskModel task({
    required String title,
    required int order,
    int? estimatedMinutes,
    String? scheduledTime,
    bool locked = false,
  }) {
    return PomodoroTaskModel()
      ..id = order + 1
      ..planId = 1
      ..userId = 1
      ..title = title
      ..orderIndex = order
      ..estimatedMinutes = estimatedMinutes
      ..scheduledTime = scheduledTime
      ..isTimeLocked = locked
      ..focusMinutes = 25
      ..breakMinutes = 5
      ..longBreakMinutes = 20
      ..longBreakInterval = 4
      ..plannedFocusSegments = 1
      ..createdAt = DateTime(2026, 6, 18);
  }

  test('calculates local start and end times without AI', () {
    final result = service.buildSchedule(
      planDate: DateTime(2026, 6, 18),
      earliestStart: DateTime(2026, 6, 18, 9),
      tasks: [
        task(title: 'Task A', order: 0, estimatedMinutes: 40),
        task(title: 'Task B', order: 1, estimatedMinutes: 20),
      ],
    );

    expect(result.hasConflicts, isFalse);
    expect(result.tasks.first.startAt, DateTime(2026, 6, 18, 9));
    expect(result.tasks.first.endAt, DateTime(2026, 6, 18, 9, 45));
    expect(result.tasks.last.startAt, DateTime(2026, 6, 18, 9, 45));
  });

  test('detects fixed time overlap locally', () {
    final result = service.buildSchedule(
      planDate: DateTime(2026, 6, 18),
      tasks: [
        task(
          title: 'Fixed A',
          order: 0,
          estimatedMinutes: 60,
          scheduledTime: '19:00',
          locked: true,
        ),
        task(
          title: 'Fixed B',
          order: 1,
          estimatedMinutes: 25,
          scheduledTime: '19:30',
          locked: true,
        ),
      ],
    );

    expect(result.hasConflicts, isTrue);
    expect(result.conflicts.single, contains('Fixed B'));
  });
}
