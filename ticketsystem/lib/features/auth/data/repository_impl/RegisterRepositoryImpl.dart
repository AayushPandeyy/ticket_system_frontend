import 'package:ticketsystem/core/service/SharedPreferenceService.dart';
import 'package:ticketsystem/features/auth/data/datasource/AuthDataSource.dart';
import 'package:ticketsystem/features/auth/domain/repository/RegisterRepository.dart';

class RegisterRepositoryImpl implements RegisterRepository{
  final AuthDataSource dataSource;

  RegisterRepositoryImpl({required this.dataSource});
  @override
  Future<Map<String, dynamic>> register(String email, String password, String fullname, String mobileNumber, DateTime birthdate, String username) async{
    return await dataSource.register(email, password, fullname, mobileNumber, birthdate, username);
  }

  @override
  Future<void> saveToken(String accessToken) async {
    await SharedPreferencesService.saveToken(accessToken);
  }

}