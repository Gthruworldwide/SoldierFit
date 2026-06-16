import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class MilitaryCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? borderColor;
  final double? borderWidth;
  final bool isGlowing;

  const MilitaryCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderColor,
    this.borderWidth,
    this.isGlowing = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.primaryDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor ?? AppTheme.militaryGreen,
            width: borderWidth ?? 1,
          ),
          boxShadow: isGlowing
              ? [
                  BoxShadow(
                    color: (borderColor ?? AppTheme.neonGreen).withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: child,
      ),
    );
  }
}
