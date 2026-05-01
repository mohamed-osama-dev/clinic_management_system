import 'package:clinic_management_system/core/constants/app_constants.dart';
import 'package:clinic_management_system/core/network/dio_client.dart';
import 'package:clinic_management_system/core/network/firebase_gateways.dart';
import 'package:clinic_management_system/core/network/network_info.dart';
import 'package:clinic_management_system/core/theme/theme_cubit.dart';
import 'package:clinic_management_system/features/auth/data/datasources/auth_firebase_data_source.dart';
import 'package:clinic_management_system/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:clinic_management_system/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:clinic_management_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/get_current_user.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/sign_in.dart';
import 'package:clinic_management_system/features/auth/domain/usecases/sign_out.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<Logger>(() => Logger());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  sl.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);
  sl.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: AppConstants.requestTimeout,
        receiveTimeout: AppConstants.requestTimeout,
      ),
    ),
  );

  sl.registerLazySingleton<DioClient>(() => DioClient(sl<Dio>()));
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<Connectivity>()),
  );
  sl.registerLazySingleton<FirebaseAuthGateway>(
    () => FirebaseAuthGatewayImpl(sl<FirebaseAuth>()),
  );
  sl.registerLazySingleton<FirestoreGateway>(
    () => FirestoreGatewayImpl(sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<StorageGateway>(
    () => StorageGatewayImpl(sl<FirebaseStorage>()),
  );
  sl.registerLazySingleton<MessagingGateway>(
    () => MessagingGatewayImpl(sl<FirebaseMessaging>()),
  );
  sl.registerLazySingleton<AuthFirebaseDataSource>(
    () => AuthFirebaseDataSource(sl<FirebaseAuthGateway>()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => InMemoryAuthRemoteDataSource(),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetCurrentUser>(
    () => GetCurrentUser(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignIn>(() => SignIn(sl<AuthRepository>()));
  sl.registerLazySingleton<SignOut>(() => SignOut(sl<AuthRepository>()));

  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      getCurrentUser: sl<GetCurrentUser>(),
      signIn: sl<SignIn>(),
      signOut: sl<SignOut>(),
    ),
  );
  sl.registerFactory<ThemeCubit>(ThemeCubit.new);
}
