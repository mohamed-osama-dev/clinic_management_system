import 'package:clinic_management_system/config/di/injection_container.dart';
import 'package:clinic_management_system/config/routes/app_router.dart';
import 'package:clinic_management_system/core/constants/app_strings.dart';
import 'package:clinic_management_system/core/theme/app_theme.dart';
import 'package:clinic_management_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

class ClinicEaseApp extends StatelessWidget {
  const ClinicEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>()..checkAuthStatus(),
      child: Builder(builder: (context) {
        final GoRouter router = createRouter(context.read<AuthCubit>());
        return MaterialApp.router(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: router,
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },
        );
      }),
    );
  }
}

class ClinicManagementApp extends ClinicEaseApp {
  const ClinicManagementApp({super.key});
}