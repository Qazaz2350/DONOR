import 'package:donate/Utilis/app_colors.dart';
import 'package:donate/Utilis/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: textColor ?? AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: FontSizes.f16,
            fontWeight: FontWeight.w600,
            color: textColor ?? AppColors.white,
          ),
        ),
      ),
    );
  }
}
