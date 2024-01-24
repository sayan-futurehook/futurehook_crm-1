import 'package:fpdart/fpdart.dart';
import 'package:futurehook_crm/core/error/failure.dart';
import 'package:futurehook_crm/core/usecase/usecase.dart';
import 'package:futurehook_crm/feature/auth/domain/repository/auth_repository.dart';

class SignOutUsecase extends Usecase<Unit, NoParams> {
  final AuthRepository authRepository;

  SignOutUsecase(this.authRepository);
  @override
  Future<Either<Failure, Unit>> call(NoParams params) =>
      authRepository.signOut();
}
