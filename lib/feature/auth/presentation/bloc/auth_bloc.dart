import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:futurehook_crm/core/error/failure.dart';
import 'package:futurehook_crm/core/usecase/usecase.dart';
import 'package:futurehook_crm/feature/auth/domain/entities/user.dart';
import 'package:futurehook_crm/feature/auth/domain/usecase/get_current_user_usecase.dart';
import 'package:futurehook_crm/feature/auth/domain/usecase/signin_with_usecase.dart';
import 'package:futurehook_crm/feature/auth/domain/usecase/signout_usecase.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  SignInWithZohoUsecase signInWithZohoUsecase;
  GetCurentUserUsecase getCurentUserUsecase;
  SignOutUsecase signOutUsecase;
  AuthBloc(this.signInWithZohoUsecase, this.getCurentUserUsecase,
      this.signOutUsecase)
      : super(AuthInitial()) {
    on<IsSighnedInAuthEvent>(
      (event, emit) async {
        emit(LoadingAuthState());
        final res = await getCurentUserUsecase.call(NoParams());
        emit(res.fold(
          (l) => l is IsNotLoggedInFailure
              ? AuthInitial()
              : const FailureAuthState("errorMessage"),
          (user) => SuccessAuthState(user),
        ));
      },
    );

    on<SignInWithZohoAuthEvent>(
      (event, emit) async {
        emit(LoadingAuthState());
        final res = await signInWithZohoUsecase.call(event.grantToken);

        emit(
          res.fold(
            (l) => FailureAuthState(l is ServerFailure ? l.message ?? '' : ''),
            (r) => SuccessAuthState(r),
          ),
        );
      },
    );

    on<SignOutEvent>((event, emit) async {
      final res = await signOutUsecase.call(NoParams());

      emit(
        res.fold(
          (l) => AuthInitial(),
          (r) => AuthInitial(),
        ),
      );
    });
  }
}
