import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_dimensions.dart';
import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    this.imageUrl,
    this.name,
    this.size = AppDimensions.avatarM,
    this.showOnlineIndicator = false,
    this.backgroundColor,
    super.key,
  });

  final String? imageUrl;
  final String? name;
  final double size;
  final bool showOnlineIndicator;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.background,
                      child: const Icon(Icons.person, color: AppColors.textSecondary),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.background,
                      child: const Icon(Icons.person, color: AppColors.textSecondary),
                    ),
                  )
                : _buildInitialAvatar(),
          ),
        ),
        if (showOnlineIndicator)
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xFF22C55E),
                shape: BoxShape.circle,
                border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 2)),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInitialAvatar() {
    final initial = name?.isNotEmpty == true ? name![0].toUpperCase() : '';
    return Container(
      color: backgroundColor ?? AppColors.primary,
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}