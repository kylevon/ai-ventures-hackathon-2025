class AppConfig {
  // API Configuration
  static const String apiBaseUrl = 'http://10.0.2.2:8080';
  static const String apiVersion = '/v1';

  // Authentication Endpoints
  static const String authLoginEndpoint = '/auth/login';
  static const String authRegisterEndpoint = '/auth/register';

  // User Management Endpoints
  static const String userGoalsEndpoint = '/users/goals';
  static const String userMedicationsEndpoint = '/users/medications';
  static const String userRestrictionsEndpoint = '/users/restrictions';

  // Nutrition Endpoints
  static const String nutritionDataEndpoint = '/nutrition/data';

  // Food Management Endpoints
  static const String foodsEndpoint = '/api/foods';
  static String foodByIdEndpoint(String id) => '/api/foods/$id';
  static const String foodConsumptionEndpoint = '/api/food-consumption';

  // Security
  static const String jwtSecret = 'your_jwt_secret_key';

  // Helper methods
  static String getFullUrl(String endpoint) {
    return apiBaseUrl + apiVersion + endpoint;
  }

  // API URLs
  static String get loginUrl => getFullUrl(authLoginEndpoint);
  static String get registerUrl => getFullUrl(authRegisterEndpoint);
  static String get userGoalsUrl => getFullUrl(userGoalsEndpoint);
  static String get userMedicationsUrl => getFullUrl(userMedicationsEndpoint);
  static String get userRestrictionsUrl => getFullUrl(userRestrictionsEndpoint);
  static String get nutritionDataUrl => getFullUrl(nutritionDataEndpoint);
  static String get foodsUrl => getFullUrl(foodsEndpoint);
  static String getFoodByIdUrl(String id) => getFullUrl(foodByIdEndpoint(id));
  static String get foodConsumptionUrl => getFullUrl(foodConsumptionEndpoint);
} 