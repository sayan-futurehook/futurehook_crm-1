import 'package:fpdart/fpdart.dart';
import 'package:futurehook_crm/core/error/failure.dart';
import 'package:futurehook_crm/feature/auth/data/model/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> signInWithZoho(String grantToken);
  Future<Either<Failure, UserModel>> getCurrentUser();
  Future<Either<Failure, Unit>> refreshToken();
  Future<Either<Failure, Unit>> signOut();
}
