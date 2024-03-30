part of 'auth_bloc.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoginInitial extends AuthState {
  final String email;
  final String password;

  AuthLoginInitial({required this.email, required this.password});
}

class AuthLoginInProgress extends AuthState {}

class AuthLoginSuccess extends AuthState {}

class AuthLoginFailure extends AuthState {
  final String message;

  AuthLoginFailure({required this.message});
}

class AuthRegisterInProgress extends AuthState {}

class AuthRegisterSuccess extends AuthState {}

class AuthRegisterFailure extends AuthState {
  final String message;

  AuthRegisterFailure({required this.message});
}

class AuthAuthenticateSuccess extends AuthState {
  final String role;

  AuthAuthenticateSuccess(this.role);
}

class AuthAuthenticateFailure extends AuthState {
  final String message;
  AuthAuthenticateFailure(this.message);
}

class AuthLogoutSuccess extends AuthState {}

class AuthLogoutFailure extends AuthState {
  final String message;
  AuthLogoutFailure(this.message);
}


class AuthAuthenticateUnauthenticated extends AuthState {}