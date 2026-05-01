import 'package:clinic_management_system/core/usecases/usecase.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/get_current_user.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/sign_in.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/sign_out.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required GetCurrentUser getCurrentUser,
    required SignIn signIn,
    required SignOut signOut,
  }) : _getCurrentUser = getCurrentUser,
       _signIn = signIn,
       _signOut = signOut,
       super(const AuthInitial());

  final GetCurrentUser _getCurrentUser;
  final SignIn _signIn;
  final SignOut _signOut;

  Future<void> checkAuthStatus() async {
    final result = await _getCurrentUser(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(
        user == null ? const AuthUnauthenticated() : AuthAuthenticated(user),
      ),
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    final result = await _signIn(SignInParams(email: email, password: password));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> signOut() async {
    emit(const AuthLoading());
    final result = await _signOut(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }
}
