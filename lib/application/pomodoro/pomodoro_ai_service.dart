import 'dart:convert';

import '../../core/di/injection.dart';

class AiPomodoroTaskDraft {
  const AiPomodoroTaskDraft({
    required this.title,
    this.estimatedMinutes,
    this.scheduledTime,
    this.steps = const [],
  });

  final String title;
  final int? estimatedMinutes;
  final String? scheduledTime;
  final List<String> steps;
}

class AiPomodoroPlanDraft {
  const AiPomodoroPlanDraft({
    required this.title,
    required this.tasks,
    this.availableMinutes,
  });

  final String title;
  final int? availableMinutes;
  final List<AiPomodoroTaskDraft> tasks;
}

class PomodoroAiParseException implements Exception {
  const PomodoroAiParseException(this.message);

  final String message;

  @override
  String toString() => message;
}

class PomodoroAiService {
  PomodoroAiService(this._client);

  final DeepSeekApiClient _client;

  Future<AiPomodoroPlanDraft> generatePlanDraft(String input) async {
    final content = await _client.simplePrompt(
      _buildPlanPrompt(input),
      jsonMode: true,
    );
    return parsePlanDraft(content);
  }

  Stream<String> streamPlanDraftText(String input) {
    return _client.streamPrompt(_buildPlanPrompt(input));
  }

  AiPomodoroPlanDraft parsePlanDraft(String raw) {
    final jsonText = _extractJsonObject(raw);
    final decoded = jsonDecode(jsonText);
    if (decoded is! Map<String, dynamic>) {
      throw const PomodoroAiParseException('AI 返回不是 JSON 对象。');
    }

    final title = _readString(decoded['title']) ?? 'AI 番茄计划建议';
    final tasksRaw = decoded['tasks'];
    if (tasksRaw is! List) {
      throw const PomodoroAiParseException('AI 返回缺少 tasks 数组。');
    }

    final tasks = <AiPomodoroTaskDraft>[];
    final seenTitles = <String>{};
    for (final item in tasksRaw) {
      if (item is! Map<String, dynamic>) continue;
      final taskTitle = _readString(item['title']);
      if (taskTitle == null || taskTitle.isEmpty) continue;
      if (!seenTitles.add(taskTitle)) continue;

      final scheduledTime = _readString(item['scheduledTime']);
      if (scheduledTime != null && !_isValidTime(scheduledTime)) {
        throw PomodoroAiParseException('AI 返回了无效时间：$scheduledTime');
      }

      tasks.add(
        AiPomodoroTaskDraft(
          title: taskTitle,
          estimatedMinutes: _readPositiveInt(item['estimatedMinutes']),
          scheduledTime: scheduledTime,
          steps: _readStringList(item['steps']),
        ),
      );
    }

    if (tasks.isEmpty) {
      throw const PomodoroAiParseException('AI 没有返回可用任务。');
    }

    return AiPomodoroPlanDraft(
      title: title,
      availableMinutes: _readPositiveInt(decoded['availableMinutes']),
      tasks: tasks,
    );
  }

  String _extractJsonObject(String raw) {
    final trimmed = raw.trim();
    if (trimmed.startsWith('{') && trimmed.endsWith('}')) return trimmed;

    final start = trimmed.indexOf('{');
    final end = trimmed.lastIndexOf('}');
    if (start < 0 || end <= start) {
      throw const PomodoroAiParseException('AI 返回中没有 JSON 对象。');
    }
    return trimmed.substring(start, end + 1);
  }

  String? _readString(Object? value) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) return null;
    return text;
  }

  int? _readPositiveInt(Object? value) {
    if (value is int && value > 0) return value;
    final parsed = int.tryParse(value?.toString() ?? '');
    if (parsed == null || parsed <= 0) return null;
    return parsed;
  }

  List<String> _readStringList(Object? value) {
    if (value is! List) return const [];
    return value
        .map((item) => item?.toString().trim() ?? '')
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  bool _isValidTime(String value) {
    final parts = value.split(':');
    if (parts.length != 2) return false;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    return hour != null &&
        minute != null &&
        hour >= 0 &&
        hour <= 23 &&
        minute >= 0 &&
        minute <= 59;
  }

  String _buildPlanPrompt(String input) {
    return '你是本我 BenWo 的番茄计划助手。请只返回 JSON，不要 Markdown。'
        '把用户的一句话拆成今天可执行的番茄任务。字段：title, availableMinutes, tasks；'
        'tasks 每项包含 title, estimatedMinutes, scheduledTime(HH:mm 可空), steps。'
        'estimatedMinutes 表示专注分钟数，不含休息。'
        '用户输入：$input';
  }
}
