import 'package:fpdart/fpdart.dart';
import 'package:futurehook_crm/core/error/failure.dart';
import 'package:futurehook_crm/core/usecase/usecase.dart';
import 'package:futurehook_crm/feature/auth/domain/entities/user.dart';
import 'package:futurehook_crm/feature/auth/domain/repository/auth_repository.dart';

class SignInWithZohoUsecase extends Usecase<User, String> {
  final AuthRepository authRepository;

  SignInWithZohoUsecase(this.authRepository);
  @override
  Future<Either<Failure, User>> call(String params) =>
      authRepository.signInWithZoho(params);
}
