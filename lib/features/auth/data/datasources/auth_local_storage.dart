abstract class AuthLocalStorage {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();

  Future<bool> getRememberMe();
  Future<void> setRememberMe(bool value);
  Future<String?> getSavedEmail();
  Future<void> setSavedEmail(String? email);
}
