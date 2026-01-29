import 'package:donate/Utilis/app_colors.dart';
import 'package:donate/Utilis/app_fonts.dart';
import 'package:donate/VIEWMODEL/SCREENS/SENDER/donor_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DonationHistoryView extends StatelessWidget {
  const DonationHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DonorViewModel()
        ..fetchUserDonations()
        ..updateBadges(),
      child: Consumer<DonorViewModel>(
        builder: (context, donorVM, _) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                'Donation History',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Column(
              children: [
                _buildBadgeHeader(donorVM),
                Expanded(child: _buildDonationList(donorVM)),
              ],
            ),
          );
        },
      ),
    );
  }

  // ===== Badge Header =====
  Widget _buildBadgeHeader(DonorViewModel donorVM) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rank & XP
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rank: ${donorVM.rank}',
                style: TextStyle(
                  fontSize: FontSizes.f16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                'XP: ${donorVM.xp}',
                style: TextStyle(
                  fontSize: FontSizes.f14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // XP Progress Bar
          Stack(
            children: [
              Container(
                height: 14.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                height: 14.h,
                width: (donorVM.xp.clamp(0, 500) / 500) * 1.sw,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Badges
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: donorVM.badges.map((badge) {
              return Chip(
                label: Text(
                  badge,
                  style: TextStyle(
                    fontSize: FontSizes.f12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.primary,
                elevation: 4,
                shadowColor: Colors.black45,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ===== Donation List =====
  Widget _buildDonationList(DonorViewModel donorVM) {
    if (donorVM.isFetchingDonations) {
      return const Center(child: CircularProgressIndicator());
    }

    if (donorVM.userDonations.isEmpty) {
      return const Center(
        child: Text('No donations yet', style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: donorVM.userDonations.length,
      itemBuilder: (context, index) {
        final donation = donorVM.userDonations[index];
        final category = donation.category;
        final orphanageName = donation.foundationName;
        final timestamp = donation.timestamp;

        final amountText = donation.amount != null
            ? 'Rs ${donation.amount!.toStringAsFixed(0)}'
            : 'Qty ${donation.quantity ?? 0}';

        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.volunteer_activism_rounded,
                size: 28.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orphanageName,
                      style: TextStyle(
                        fontSize: FontSizes.f16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '$category • $amountText',
                      style: TextStyle(
                        fontSize: FontSizes.f14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      DateFormat('dd MMM yyyy, hh:mm a').format(timestamp),
                      style: TextStyle(
                        fontSize: FontSizes.f12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
