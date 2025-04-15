abstract class LoginRepository {
  Future<Map<String,dynamic>> login(String email, String password);
  Future<void> saveToken(String accessToken);
}