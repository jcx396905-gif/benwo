/// DeepSeek API configuration.
/// Uses DeepSeek's OpenAI-compatible endpoint.
///
/// To use this file:
/// 1. Copy this file to `api_constants.dart` (in the same directory)
/// 2. Replace `YOUR_DEEPSEEK_API_KEY` with your actual API key
/// 3. Alternatively, pass it via --dart-define=DEEPSEEK_API_KEY=your_key
class ApiConstants {
  static const String deepseekApiUrl = 'https://api.deepseek.com';
  static const String deepseekModel = 'deepseek-v4-flash';

  // Override for local or CI runs:
  // --dart-define=DEEPSEEK_API_KEY=your_key
  static const String deepseekApiKey = String.fromEnvironment(
    'DEEPSEEK_API_KEY',
    defaultValue: 'YOUR_DEEPSEEK_API_KEY',
  );

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);

  static Map<String, String> get deepseekHeaders => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $deepseekApiKey',
      };

  // Backward-compatible aliases used by the current API client naming.
  static const String minmaxApiUrl = deepseekApiUrl;
  static const String minmaxModel = deepseekModel;
  static Map<String, String> get minmaxHeaders => deepseekHeaders;
}
