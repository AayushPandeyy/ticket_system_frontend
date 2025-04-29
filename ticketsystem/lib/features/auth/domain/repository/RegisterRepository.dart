abstract class RegisterRepository {
  Future<Map<String,dynamic>> register(String email, String password, String fullname,
      String mobileNumber, DateTime birthdate, String username);
  Future<void> saveToken(String accessToken);
}
