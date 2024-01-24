part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class IsSighnedInAuthEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class SignInWithZohoAuthEvent extends AuthEvent {
  final String grantToken;
  const SignInWithZohoAuthEvent(this.grantToken);
  @override
  List<Object> get props => [grantToken];
}

class SignOutEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}
