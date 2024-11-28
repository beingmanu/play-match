import '../core/cache_manager.dart';

class AppCache {
  String tokenKey = "Token";
  bool doLogin(String token) {
    try {
      CacheManeger.saveData(tokenKey, token);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getToken() async {
    try {
      final tokenCache = await CacheManeger.readData(tokenKey) ?? "";
      return tokenCache;
    } catch (e) {
      return "";
    }
  }

  bool doLogout() {
    try {
      CacheManeger.deleteData(tokenKey);
      return true;
    } catch (e) {
      return false;
    }
  }
}
