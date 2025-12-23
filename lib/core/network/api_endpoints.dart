/// Centralized API endpoints for the entire application
/// All endpoints should be defined here to maintain consistency
class ApiEndpoints {
  ApiEndpoints._();

  // Base API path
  static const String api = '/api';

  // Enterprise Structure endpoints
  static const String structureLevels = '$api/structure-levels';
  
  // Add more endpoints here as needed
  // Example:
  // static const String companies = '$api/companies';
  // static const String divisions = '$api/divisions';
  // static const String departments = '$api/departments';
}

