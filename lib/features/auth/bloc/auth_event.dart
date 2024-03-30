part of 'auth_bloc.dart';

sealed class AuthEvent {}

class AuthStarted extends AuthEvent {}

class AuthLoginStarted extends AuthEvent {
  final String email;
  final String password;

  AuthLoginStarted({required this.email, required this.password});
}

class AuthRegisterStarted extends AuthEvent {
  final String username;
  final String email;
  final String password;

  AuthRegisterStarted(
      {required this.username, required this.email, required this.password});
}

class AuthLoginPrefilled extends AuthEvent {
  final String email;
  final String password;

  AuthLoginPrefilled({required this.email, required this.password});
}

class AuthAuthenticateStarted extends AuthEvent {}

class AuthLogoutStarted extends AuthEvent {}
