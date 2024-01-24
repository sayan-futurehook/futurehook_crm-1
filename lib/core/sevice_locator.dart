import 'package:dio/dio.dart';
import 'package:futurehook_crm/feature/auth/data/datasource/auth_remote_datasource.dart';
import 'package:futurehook_crm/feature/auth/data/repository/auth_repository_impl.dart';
import 'package:futurehook_crm/feature/auth/domain/repository/auth_repository.dart';
import 'package:futurehook_crm/feature/auth/domain/usecase/get_current_user_usecase.dart';
import 'package:futurehook_crm/feature/auth/domain/usecase/signin_with_usecase.dart';
import 'package:futurehook_crm/feature/auth/domain/usecase/signout_usecase.dart';
import 'package:futurehook_crm/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'route/go_router_provider.dart';
import '../utils/service/hive/hive.dart';

final getIt = GetIt.instance;

Future<void> serviceLocatorInit() async {
  getIt.registerFactory(() => GoRouterProvider());
  getIt.registerLazySingleton(() => Dio());

  _dataSources();
  _repositories();
  _useCase();
  _bloc();
  await _initHiveBoxes();
}

Future<void> _initHiveBoxes() async {
  await MainBoxMixin.initHive();
  getIt.registerSingleton<MainBoxMixin>(MainBoxMixin());
}

/// Register repositories
void _repositories() {
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt(), getIt()));
}

/// Register dataSources
void _dataSources() {
  getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(getIt()));
}

void _useCase() {
  /// Auth
  getIt.registerLazySingleton(
    () => SignInWithZohoUsecase(getIt()),
  );
  getIt.registerLazySingleton(
    () => GetCurentUserUsecase(getIt()),
  );
  getIt.registerLazySingleton(
    () => SignOutUsecase(getIt()),
  );

  /// Users
}

void _bloc() {
  /// Auth
  getIt.registerFactory(
    () => AuthBloc(
      getIt(),
      getIt(),
      getIt(),
    ),
  );

  /// Users
}
