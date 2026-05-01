import 'package:clinic_management_system/config/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Registration flow placeholder'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => context.go(AppRoutes.login),
              child: const Text('Back to login'),
            ),
          ],
        ),
      ),
    );
  }
}
