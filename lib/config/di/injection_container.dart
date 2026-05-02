import 'package:clinic_management_system/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:clinic_management_system/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:clinic_management_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/get_current_user.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/sign_in.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/sign_out.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> setupInjection() async {
  _registerAuth();
}

void _registerAuth() {
  sl.registerLazySingleton<AuthRemoteDataSource>(() => InMemoryAuthRemoteDataSource());
  
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );
  
  sl.registerLazySingleton<SignIn>(() => SignIn(sl<AuthRepository>()));
  sl.registerLazySingleton<SignOut>(() => SignOut(sl<AuthRepository>()));
  sl.registerLazySingleton<GetCurrentUser>(() => GetCurrentUser(sl<AuthRepository>()));
  
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      signIn: sl<SignIn>(),
      signOut: sl<SignOut>(),
      getCurrentUser: sl<GetCurrentUser>(),
    ),
  );
}