import 'package:ticketsystem/core/service/SharedPreferenceService.dart';
import 'package:ticketsystem/features/auth/data/datasource/AuthDataSource.dart';
import 'package:ticketsystem/features/auth/domain/repository/LoginRepository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final AuthDataSource remoteDataSource;
  final SharedPreferencesService localDataSource;

  LoginRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Map<String,dynamic>> login(String email, String password) async {
    return await remoteDataSource.login(email, password);
  }

  @override
  Future<void> saveToken(String accessToken) async {
    await SharedPreferencesService.saveToken(accessToken);
  }
}