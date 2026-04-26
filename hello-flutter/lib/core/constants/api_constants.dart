/// MinMax API Configuration
/// AI Service API credentials for BenWo app

class ApiConstants {
  // MinMax API - Token Plan (中国版)
  // API Document: https://www.minimax.chat/document/ChatCompletionAPI
  
  static const String minmaxApiUrl = 'https://api.minimaxi.com/v1';
  static const String minmaxModel = 'minimax-2.7';
  
  // ⚠️ IMPORTANT: Replace with your actual API key
  // Get your API key from: https://minimaxi.com/
  static const String minmaxApiKey = 'sk-cp-K9ssLOVLXPddo44kjQ0xCHnXn60OpwqKxJs0WqUapSu2_WzsUwhW43iFVxoB-eS9SYvTSNenAiAawJXoHky1B1noBNc1QCogkGCAMQodcNZRua7hh02AE2s';
  
  // Request timeout settings
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);
  
  // Headers for MinMax API
  static Map<String, String> get minmaxHeaders => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $minmaxApiKey',
  };
}
