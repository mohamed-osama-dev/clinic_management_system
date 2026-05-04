import 'package:clinic_management_system/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:clinic_management_system/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:clinic_management_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/check_email_verified_usecase.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/complete_doctor_profile_usecase.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/get_current_user.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/register_usecase.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/send_email_verification_usecase.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/send_password_reset_usecase.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/sign_in.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/sign_out.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> setupInjection() async {
  _registerAuth();
}

void _registerAuth() {
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => FirebaseAuthDataSource(
      firebaseAuth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
      storage: sl<FirebaseStorage>(),
    ),
  );
  
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );
  
  sl.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton<CompleteDoctorProfileUseCase>(
    () => CompleteDoctorProfileUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SendEmailVerificationUseCase>(
    () => SendEmailVerificationUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<CheckEmailVerifiedUseCase>(
    () => CheckEmailVerifiedUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SendPasswordResetUseCase>(
    () => SendPasswordResetUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignIn>(() => SignIn(sl<AuthRepository>()));
  sl.registerLazySingleton<SignOut>(() => SignOut(sl<AuthRepository>()));
  sl.registerLazySingleton<GetCurrentUser>(() => GetCurrentUser(sl<AuthRepository>()));
  
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      register: sl<RegisterUseCase>(),
      completeDoctorProfile: sl<CompleteDoctorProfileUseCase>(),
      sendEmailVerification: sl<SendEmailVerificationUseCase>(),
      checkEmailVerified: sl<CheckEmailVerifiedUseCase>(),
      sendPasswordReset: sl<SendPasswordResetUseCase>(),
      signIn: sl<SignIn>(),
      signOut: sl<SignOut>(),
      getCurrentUser: sl<GetCurrentUser>(),
    ),
  );
}
