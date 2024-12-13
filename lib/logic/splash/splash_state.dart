part of 'splash_bloc.dart';

sealed class SplashState {}

final class SplashInitial extends SplashState {}

class SplashStateLoading extends SplashState {}

class SplashStateComplete extends SplashState {}

class SplashStateError extends SplashState {
  SplashStateError(this.message);

  String message;
}
