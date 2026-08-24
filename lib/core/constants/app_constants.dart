class AppConstants {
  AppConstants._();

  static const String appName = 'BenWo';
  static const String appVersion = '1.1.0';
  static const String appDescription = '本地优先的 AI 目标与任务应用';

  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const int maxGoalTitleLength = 100;

  static const List<String> goalCategories = [
    '学业',
    '职业',
    '健康',
    '关系',
    '个人成长',
    '财务',
    '其他',
  ];

  static const List<String> changeTimeframes = [
    '1个月',
    '3个月',
    '半年',
    '一年',
    '更长时间',
  ];
}
