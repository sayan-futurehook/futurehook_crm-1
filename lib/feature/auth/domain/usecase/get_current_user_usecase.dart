import 'package:fpdart/fpdart.dart';
import 'package:futurehook_crm/core/error/failure.dart';
import 'package:futurehook_crm/core/usecase/usecase.dart';
import 'package:futurehook_crm/feature/auth/domain/entities/user.dart';
import 'package:futurehook_crm/feature/auth/domain/repository/auth_repository.dart';

class GetCurentUserUsecase extends Usecase<User, NoParams> {
  final AuthRepository authRepository;

  GetCurentUserUsecase(this.authRepository);
  @override
  Future<Either<Failure, User>> call(NoParams params) =>
      authRepository.getCurrentUser();
}
