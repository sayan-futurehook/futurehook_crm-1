part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class SuccessAuthState extends AuthState {
  final User user;

  const SuccessAuthState(this.user);
}

class LoadingAuthState extends AuthState {}

class FailureAuthState extends AuthState {
  final String errorMessage;
  const FailureAuthState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
