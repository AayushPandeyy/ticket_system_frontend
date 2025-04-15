import 'package:ticketsystem/features/auth/domain/repository/LoginRepository.dart';

class LoginUseCase {
  final LoginRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<Map<String,dynamic>> login(String email, String password) async {
    return await authRepository.login(email, password);
  }
}