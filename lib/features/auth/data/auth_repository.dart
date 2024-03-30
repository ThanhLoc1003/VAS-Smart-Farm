import 'dart:developer';

import 'package:vas_farm/features/auth/dtos/login_dto.dart';
import 'package:vas_farm/features/auth/dtos/register_dto.dart';
import '../../result_type.dart';
import 'auth_api_client.dart';
import 'auth_local_data_source.dart';

class AuthRepository {
  final AuthApiClient authApiClient;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepository(
      {required this.authApiClient, required this.authLocalDataSource});

  Future<Result<void>> login(String email, String password) async {
    try {
      final loginSuccessDto =
          await authApiClient.login(LoginDto(email: email, password: password));
      await authLocalDataSource.saveRole(loginSuccessDto.role);
    } catch (e) {
      log('$e');
      return Failure(e.toString());
    }
    return Success(null);
  }

  Future<Result<void>> register(
      String username, String email, String password) async {
    try {
      await authApiClient.register(
          RegisterDto(email: email, password: password, username: username));
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
    return Success(null);
  }

  Future<Result<String?>> getRole() async {
    try {
      final role = await authLocalDataSource.getRole();
      if (role == null) {
        return Success(null);
      }
      return Success(role);
    } catch (e) {
      return Failure('$e');
    }
  }

  Future<Result<void>> logout() async {
    try {
      await authLocalDataSource.clearRole();
      return Success(null);
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
  }
}
