import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_dimensions.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

enum ButtonVariant { primary, secondary, text }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    this.onTap,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.prefixIcon,
    this.width,
    this.height = AppDimensions.buttonHeight,
    super.key,
  });

  const AppButton.fullWidth({
    required this.label,
    this.onTap,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.prefixIcon,
    this.width,
    this.height = AppDimensions.buttonHeight,
    super.key,
  }) : isFullWidth = true;

  final String label;
  final VoidCallback? onTap;
  final ButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? prefixIcon;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onTap == null || isLoading;

    switch (variant) {
      case ButtonVariant.primary:
        return InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          child: Container(
            width: isFullWidth ? double.infinity : width,
            height: height,
            decoration: BoxDecoration(
              color: isDisabled ? AppColors.textHint : AppColors.primary,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (prefixIcon != null) ...[
                        Icon(prefixIcon, size: AppDimensions.iconM, color: Colors.white),
                        const SizedBox(width: 4.0),
                      ],
                      Text(label, style: AppTextStyles.buttonText.copyWith(color: Colors.white)),
                    ],
                  ),
          ),
        );
      case ButtonVariant.secondary:
        return InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          child: Container(
            width: isFullWidth ? double.infinity : width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: isDisabled ? AppColors.textHint : AppColors.primary,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            alignment: Alignment.center,
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDisabled ? AppColors.textHint : AppColors.primary,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (prefixIcon != null) ...[
                        Icon(
                          prefixIcon,
                          size: AppDimensions.iconM,
                          color: isDisabled ? AppColors.textHint : AppColors.primary,
                        ),
                        const SizedBox(width: 4.0),
                      ],
                      Text(
                        label,
                        style: AppTextStyles.buttonText.copyWith(
                          color: isDisabled ? AppColors.textHint : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      case ButtonVariant.text:
        return InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          child: Container(
            width: isFullWidth ? double.infinity : width,
            height: height,
            alignment: Alignment.center,
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDisabled ? AppColors.textHint : AppColors.primary,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (prefixIcon != null) ...[
                        Icon(
                          prefixIcon,
                          size: AppDimensions.iconM,
                          color: isDisabled ? AppColors.textHint : AppColors.primary,
                        ),
                        const SizedBox(width: 4.0),
                      ],
                      Text(
                        label,
                        style: AppTextStyles.buttonText.copyWith(
                          color: isDisabled ? AppColors.textHint : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
          ),
        );
    }
  }
}