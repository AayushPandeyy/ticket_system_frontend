import 'package:ticketsystem/features/auth/domain/repository/RegisterRepository.dart';

class RegisterUseCase{
  final RegisterRepository registerRepository;

  RegisterUseCase({required this.registerRepository});

  Future<Map<String,dynamic>> register(String email, String password, String fullname,
      String mobileNumber, DateTime birthdate, String username) async {
    return await registerRepository.register(email, password, fullname,
        mobileNumber, birthdate, username);
  }
}