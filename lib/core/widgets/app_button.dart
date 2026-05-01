import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, outline }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = AppButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case AppButtonVariant.primary:
        return FilledButton(onPressed: onPressed, child: Text(label));
      case AppButtonVariant.secondary:
        return ElevatedButton(onPressed: onPressed, child: Text(label));
      case AppButtonVariant.outline:
        return OutlinedButton(onPressed: onPressed, child: Text(label));
    }
  }
}
