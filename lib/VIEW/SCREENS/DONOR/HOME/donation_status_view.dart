import 'package:donate/UTILIS/app_colors.dart';
import 'package:donate/Utilis/app_fonts.dart';
import 'package:donate/VIEWMODEL/SCREENS/SENDER/donor_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DonorStatsView extends StatelessWidget {
  const DonorStatsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DonorViewModel(),
      child: Consumer<DonorViewModel>(
        builder: (context, vm, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                // Total Donations Card
                Expanded(
                  child: _buildStatCard(
                    context: context,
                    title: 'Total Donations',

                    image: Image.asset(
                      'assets/icons/donate.png', // <-- correct path
                      width: 24.w,
                      height: 24.h,
                      color: AppColors.white,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                // Children Sponsored Card
                Expanded(
                  child: _buildStatCard(
                    context: context,
                    title: 'Children Sponsored',

                    image: Image.asset(
                      'assets/icons/kid.png',
                      width: 24.w,
                      height: 24.h,
                      color: AppColors.white,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.secondary,
                        AppColors.secondary.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String title,

    required Widget image, // changed from Image to Widget for flexibility
    required Gradient gradient,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: FontSizes.f12,
              fontWeight: FontWeight.w600,
              color: AppColors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: 4.h),
          // Main Value with Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: image,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
