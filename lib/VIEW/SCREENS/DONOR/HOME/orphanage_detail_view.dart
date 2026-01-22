import 'package:donate/UTILIS/app_colors.dart';
import 'package:donate/Utilis/app_fonts.dart';
import 'package:donate/Utilis/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrphanageFoundationDetail extends StatelessWidget {
  final Map<String, dynamic> orphanage;

  const OrphanageFoundationDetail({super.key, required this.orphanage});

  @override
  Widget build(BuildContext context) {
    // Combine all images (if any)
    List<String> allImages = [];
    if (orphanage['cnicImage'] != null) allImages.add(orphanage['cnicImage']);
    if (orphanage['signBoardImage'] != null)
      allImages.add(orphanage['signBoardImage']);
    if (orphanage['orphanageImage'] != null)
      allImages.add(orphanage['orphanageImage']);
    if (orphanage['additionalImages'] != null)
      allImages.addAll(List<String>.from(orphanage['additionalImages']));

    final needsList = (orphanage['needs'] ?? []) as List<dynamic>;
    final storiesList = (orphanage['stories'] ?? []) as List<dynamic>;
    final eventsList = (orphanage['volunteeringEvents'] ?? []) as List<dynamic>;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: CustomScrollView(
        slivers: [
          // ---------------- Modern App Bar with Image ----------------
          SliverAppBar(
            expandedHeight: 280.h,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primary,
            leading: Container(
              margin: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.white,
                  size: 24.sp,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.share_rounded,
                    color: AppColors.white,
                    size: 22.sp,
                  ),
                  onPressed: () {},
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 8.w, top: 8.h, bottom: 8.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.favorite_border_rounded,
                    color: AppColors.white,
                    size: 22.sp,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Main Image
                  if (allImages.isNotEmpty)
                    Image.network(
                      allImages[0],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.primary, AppColors.blue],
                            ),
                          ),
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 64.sp,
                            color: AppColors.white.withOpacity(0.5),
                          ),
                        );
                      },
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.primary, AppColors.blue],
                        ),
                      ),
                      child: Icon(
                        Icons.home_work_outlined,
                        size: 64.sp,
                        color: AppColors.white.withOpacity(0.5),
                      ),
                    ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Verified Badge
                  if (orphanage['verified'] == true)
                    Positioned(
                      bottom: 20.h,
                      right: 20.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.secondary.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              color: AppColors.white,
                              size: 18.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Verified',
                              style: TextStyle(
                                fontSize: FontSizes.f12,
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ---------------- Content ----------------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  // ---------------- Header Card ----------------
                  Transform.translate(
                    offset: Offset(0, -20.h),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: context.colors.surface,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orphanage['orphanagename'] ??
                                orphanage['name'] ??
                                'No Name',
                            style: TextStyle(
                              fontSize: FontSizes.f20,
                              fontWeight: FontWeight.bold,
                              color: context.colors.onSurface,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          _buildInfoRow(
                            context,
                            Icons.location_on_rounded,
                            orphanage['orphanageaddress'] ??
                                orphanage['address'] ??
                                'Address not available',
                          ),
                          SizedBox(height: 8.h),
                          _buildInfoRow(
                            context,
                            Icons.phone_rounded,
                            orphanage['phone'] ?? 'Not provided',
                          ),
                          SizedBox(height: 8.h),
                          _buildInfoRow(
                            context,
                            Icons.email_rounded,
                            orphanage['email'] ?? 'Not provided',
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ---------------- Image Gallery ----------------
                  if (allImages.length > 1)
                    Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Text(
                              'Gallery',
                              style: TextStyle(
                                fontSize: FontSizes.f16,
                                fontWeight: FontWeight.bold,
                                color: context.colors.onSurface,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          SizedBox(
                            height: 120.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              itemCount: allImages.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(right: 12.w),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.r),
                                    child: Image.network(
                                      allImages[index],
                                      width: 160.w,
                                      height: 120.h,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 160.w,
                                          height: 120.h,
                                          color: AppColors.primary.withOpacity(
                                            0.1,
                                          ),
                                          child: Icon(
                                            Icons.image_not_supported_outlined,
                                            size: 32.sp,
                                            color: context.colors.onSurface
                                                .withOpacity(0.3),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                  // ---------------- Needs Section ----------------
                  if (needsList.isNotEmpty)
                    _buildSection(
                      context,
                      title: 'Current Needs',
                      icon: Icons.inventory_2_outlined,
                      child: Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: needsList.map((need) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              need.toString(),
                              style: TextStyle(
                                fontSize: FontSizes.f12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                  // ---------------- Stories Section ----------------
                  if (storiesList.isNotEmpty)
                    _buildSection(
                      context,
                      title: 'Stories',
                      icon: Icons.auto_stories_outlined,
                      child: Column(
                        children: storiesList.map((story) {
                          final s = story as Map<String, dynamic>;
                          return Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: context.colors.surface,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: context.colors.onSurface.withOpacity(
                                  0.1,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s['title'] ?? 'Untitled',
                                  style: TextStyle(
                                    fontSize: FontSizes.f14,
                                    fontWeight: FontWeight.bold,
                                    color: context.colors.onSurface,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  s['description'] ?? 'No description',
                                  style: TextStyle(
                                    fontSize: FontSizes.f12,
                                    color: context.colors.onSurface.withOpacity(
                                      0.7,
                                    ),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                  // ---------------- Events Section ----------------
                  if (eventsList.isNotEmpty)
                    _buildSection(
                      context,
                      title: 'Volunteering Events',
                      icon: Icons.event_outlined,
                      child: Column(
                        children: eventsList.map((event) {
                          final v = event as Map<String, dynamic>;
                          return Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.secondary.withOpacity(0.1),
                                  AppColors.primary.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: AppColors.secondary.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    Icons.calendar_month_rounded,
                                    color: AppColors.white,
                                    size: 24.sp,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        v['name'] ?? 'Unnamed Event',
                                        style: TextStyle(
                                          fontSize: FontSizes.f14,
                                          fontWeight: FontWeight.bold,
                                          color: context.colors.onSurface,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        v['date'] ?? 'Date TBA',
                                        style: TextStyle(
                                          fontSize: FontSizes.f12,
                                          color: context.colors.onSurface
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                  // ---------------- Donate Button ----------------
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: () {
                          // Donate action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          elevation: 4,
                          shadowColor: AppColors.primary.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.volunteer_activism_rounded, size: 24.sp),
                            SizedBox(width: 8.w),
                            Text(
                              'Donate Now',
                              style: TextStyle(
                                fontSize: FontSizes.f16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 18.sp, color: AppColors.primary),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              text,
              style: TextStyle(
                fontSize: FontSizes.f12,
                color: context.colors.onSurface.withOpacity(0.7),
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, size: 20.sp, color: AppColors.primary),
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: FontSizes.f16,
                  fontWeight: FontWeight.bold,
                  color: context.colors.onSurface,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}
