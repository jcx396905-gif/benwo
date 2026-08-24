import 'package:benwo/application/pomodoro/pomodoro_split_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const service = PomodoroSplitService();

  List<int> focusMinutes(PomodoroSplitResult result) {
    return result.focusSegments.map((segment) => segment.minutes).toList();
  }

  test('splits 60 minutes into 25, 25, 10 without trailing break', () {
    final result = service.split(estimatedMinutes: 60);

    expect(focusMinutes(result), [25, 25, 10]);
    expect(result.segments.last.type, PomodoroSegmentType.focus);
  });

  test('splits 40 minutes into 25, 15', () {
    final result = service.split(estimatedMinutes: 40);

    expect(focusMinutes(result), [25, 15]);
  });

  test('splits 75 minutes into three full pomodoros', () {
    final result = service.split(estimatedMinutes: 75);

    expect(focusMinutes(result), [25, 25, 25]);
  });

  test('keeps a 20 minute short focus as 20 minutes', () {
    final result = service.split(estimatedMinutes: 20);

    expect(focusMinutes(result), [20]);
  });

  test('empty duration uses one default estimated pomodoro', () {
    final result = service.split();

    expect(focusMinutes(result), [25]);
    expect(result.usedDefaultEstimate, isTrue);
  });

  test('uses long break after every fourth completed focus', () {
    final result = service.split(estimatedMinutes: 125);

    expect(result.segments[7].type, PomodoroSegmentType.longBreak);
    expect(result.segments[7].minutes, 20);
  });
}
