abstract class LoginRepository {
  Future<Map<String,dynamic>> login(String email, String password,String role);
  Future<void> saveToken(String accessToken);
}