import 'package:fpdart/fpdart.dart';
import 'package:futurehook_crm/core/error/failure.dart';
import 'package:futurehook_crm/feature/auth/data/datasource/auth_remote_datasource.dart';
import 'package:futurehook_crm/feature/auth/data/model/user_model.dart';
import 'package:futurehook_crm/feature/auth/domain/repository/auth_repository.dart';

import '../../../../utils/service/hive/hive.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource authremoteDataSource;
  final MainBoxMixin mainBoxMixin;
  AuthRepositoryImpl(this.authremoteDataSource, this.mainBoxMixin);

  @override
  Future<Either<Failure, UserModel>> signInWithZoho(String grantToken) async {
    try {
      final accessToken =
          await authremoteDataSource.getAccessTokens(grantToken);
      return accessToken.fold(
        (failure) => left(failure),
        (accessTokensModel) async {
          mainBoxMixin.addData<String>(
              MainBoxKeys.accessToken, accessTokensModel.accessToken);
          mainBoxMixin.addData<String>(
              MainBoxKeys.refreshToken, accessTokensModel.refreshToken);
          mainBoxMixin.addData<bool>(MainBoxKeys.isLogin, true);
          final user =
              await authremoteDataSource.getuser(accessTokensModel.accessToken);
          return user.fold(
            (failure) => left(failure),
            (user) => right(user),
          );
        },
      );
    } catch (e) {
      return left(ServerFailure("Authentication eror $e"));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getCurrentUser() async {
    final isLoggedIn = mainBoxMixin.getData<bool?>(MainBoxKeys.isLogin);
    if (isLoggedIn case bool _ when true) {
      final user = await authremoteDataSource
          .getuser(mainBoxMixin.getData<String>(MainBoxKeys.accessToken));
      return user.fold(
        (failure) async {
          if (failure is TokenExpireFailure) {
            final refreshTokenRes = await refreshToken();
            return refreshTokenRes.fold(
              (failure) => left(failure),
              (success) => getCurrentUser(),
            );
          } else {
            return left(failure);
          }
        },
        (user) => right(user),
      );
    } else {
      return left(IsNotLoggedInFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> refreshToken() async {
    final token = mainBoxMixin.getData<String>(MainBoxKeys.refreshToken);
    final refreshToken = await authremoteDataSource.refreshToken(token);
    return refreshToken.fold((failure) => left(failure), (refreshToken) {
      mainBoxMixin.addData<String>(
          MainBoxKeys.accessToken, refreshToken.accessToken);
      return right(unit);
    });
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    mainBoxMixin.logoutBox();
    return right(unit);
  }
}
