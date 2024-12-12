part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthStateLogin extends AuthState {}

final class AuthStateLoading extends AuthState {}

final class AuthStateLogout extends AuthState {}

final class AuthStateError extends AuthState {
  AuthStateError(this.message);

  final String message;
}
