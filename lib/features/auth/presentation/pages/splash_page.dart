import 'package:clinic_management_system/core/shared/widgets/app_loading.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppLoading(),
    );
  }
}
