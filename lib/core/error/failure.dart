import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  final String? message;

  ServerFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class JsonParseFailure extends Failure {
  JsonParseFailure();

  @override
  List<Object?> get props => [];
}

class TokenExpireFailure extends Failure {
  TokenExpireFailure();

  @override
  List<Object?> get props => [];
}

class IsNotLoggedInFailure extends Failure {
  IsNotLoggedInFailure();

  @override
  List<Object?> get props => [];
}
