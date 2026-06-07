/// Application Constants for BenWo App
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'BenWo';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'AI驱动的自我探索与目标达成应用';

  // Database
  static const String isarDbName = 'benwo_db';

  // SharedPreferences Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyHasCompletedOnboarding = 'has_completed_onboarding';

  // API Configuration
  static const Duration apiTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 20;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
  static const int maxGoalTitleLength = 100;
  static const int maxTodoContentLength = 500;

  // Date Formats
  static const String dateFormatFull = 'yyyy年MM月dd日';
  static const String dateFormatShort = 'MM/dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';

  // Onboarding Steps
  static const int onboardingTotalSteps = 4;

  // Todo Limits
  static const int maxAIGeneratedTodosPerDay = 5;

  // MBTI Types
  static const List<String> mbtiTypes = [
    'INTJ', 'INTP', 'ENTJ', 'ENTP',
    'INFJ', 'INFP', 'ENFJ', 'ENFP',
    'ISTJ', 'ISFJ', 'ESTJ', 'ESFJ',
    'ISTP', 'ISFP', 'ESTP', 'ESFP',
  ];

  // Communication Styles
  static const List<String> communicationStyles = [
    '鼓励型',
    '直接型',
    '分析型',
  ];

  // Motivation Sensitivity
  static const List<String> motivationSensitivityLevels = [
    '高',
    '中',
    '低',
  ];

  // Work Time Preferences
  static const List<String> workTimePreferences = [
    '早起型',
    '夜猫型',
    '弹性',
  ];

  // Stress Response
  static const List<String> stressResponses = [
    '喜欢被推动',
    '需要缓冲空间',
  ];

  // Social Preferences
  static const List<String> socialPreferences = [
    '独立完成',
    '喜欢协作',
  ];

  // Occupations
  static const List<String> occupations = [
    '学生',
    '在职',
    '自由职业',
    '退休',
    '其他',
  ];

  // Life Status
  static const List<String> lifeStatuses = [
    '学生',
    '在职',
    '自由职业',
    '退休',
  ];

  // Challenges
  static const List<String> challenges = [
    '工作效率低',
    '时间管理差',
    '缺乏动力',
    '拖延症',
    '生活失衡',
    '健康问题',
    '人际关系',
    '其他',
  ];

  // Goal Categories
  static const List<String> goalCategories = [
    '学业',
    '职业',
    '健康',
    '关系',
    '个人成长',
    '财务',
    '其他',
  ];

  // Change Timeframes
  static const List<String> changeTimeframes = [
    '1个月',
    '3个月',
    '半年',
    '一年',
    '更长时间',
  ];

  // Default Goal Color (Morandi teal)
  static const String defaultGoalColor = '#7FA99B';
}
