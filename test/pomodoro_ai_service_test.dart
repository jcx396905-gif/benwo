import 'package:benwo/application/pomodoro/pomodoro_ai_service.dart';
import 'package:benwo/core/di/injection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PomodoroAiService service;

  setUp(() {
    service = PomodoroAiService(DeepSeekApiClient(Dio()));
  });

  test('parses valid AI pomodoro plan JSON', () {
    final draft = service.parsePlanDraft('''
{
  "title": "今晚学习计划",
  "availableMinutes": 120,
  "tasks": [
    {
      "title": "完成数学试卷",
      "estimatedMinutes": 50,
      "scheduledTime": "19:00",
      "steps": ["完成选择题", "完成大题"]
    }
  ]
}
''');

    expect(draft.title, '今晚学习计划');
    expect(draft.availableMinutes, 120);
    expect(draft.tasks.single.title, '完成数学试卷');
    expect(draft.tasks.single.steps, hasLength(2));
  });

  test('extracts JSON from markdown wrapped response', () {
    final draft = service.parsePlanDraft('''
```json
{"title":"计划","tasks":[{"title":"背英语单词","estimatedMinutes":25}]}
```
''');

    expect(draft.tasks.single.title, '背英语单词');
  });

  test('rejects invalid scheduled time', () {
    expect(
      () => service.parsePlanDraft(
        '{"title":"计划","tasks":[{"title":"任务","scheduledTime":"29:00"}]}',
      ),
      throwsA(isA<PomodoroAiParseException>()),
    );
  });
}
