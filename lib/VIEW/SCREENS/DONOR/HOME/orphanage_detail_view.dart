import 'package:donate/UTILIS/app_colors.dart';
import 'package:donate/Utilis/app_fonts.dart';
import 'package:donate/Utilis/extention.dart';
import 'package:donate/Utilis/nav.dart';
import 'package:donate/VIEW/SCREENS/DONOR/HOME/donation_page_view.dart';
import 'package:donate/VIEW/SCREENS/DONOR/VIDEOCALL/videocall_request_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrphanageFoundationDetail extends StatelessWidget {
  final String username;
  final String useremail;
  final String userphone;
  final Map<String, dynamic> orphanage;

  const OrphanageFoundationDetail({
    super.key,
    required this.orphanage,
    required this.username,
    required this.useremail,
    required this.userphone,
  });

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
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ---------------- Modern Header with Image ----------------
              SliverAppBar(
                expandedHeight: 280.h,
                pinned: true,
                elevation: 0,
                backgroundColor: AppColors.primary,
                leading: Container(
                  margin: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.white,
                      size: 20.sp,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Container(
                    margin: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
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
                  SizedBox(width: 4.w),
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
                                  colors: [
                                    AppColors.primary,
                                    AppColors.secondary,
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 64.sp,
                                  color: AppColors.white.withOpacity(0.5),
                                ),
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
                              colors: [AppColors.primary, AppColors.secondary],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.home_work_outlined,
                              size: 64.sp,
                              color: AppColors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                      // Dark Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.2),
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      // Bottom fade
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 60.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                context.colors.background,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ---------------- Content ----------------
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------------- Title & Info Card ----------------
                    Container(
                      margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
                      padding: EdgeInsets.all(24.w),
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
                          // Verified Badge
                          if (orphanage['verified'] == true)
                            Container(
                              margin: EdgeInsets.only(bottom: 12.h),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: AppColors.secondary.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified_rounded,
                                    color: AppColors.secondary,
                                    size: 16.sp,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    'Verified Organization',
                                    style: TextStyle(
                                      fontSize: FontSizes.f12,
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Title
                          Text(
                            orphanage['orphanagename'] ??
                                orphanage['name'] ??
                                'No Name',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: context.colors.onSurface,
                              height: 1.2,
                              letterSpacing: -0.5,
                            ),
                          ),

                          SizedBox(height: 20.h),

                          // Contact Info
                          _buildInfoItem(
                            context,
                            Icons.location_on_rounded,
                            orphanage['orphanageaddress'] ??
                                orphanage['address'] ??
                                'Address not available',
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoItem(
                                  context,
                                  Icons.phone_rounded,
                                  orphanage['phone'] ?? 'N/A',
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _buildInfoItem(
                                  context,
                                  Icons.email_rounded,
                                  orphanage['email'] ?? 'N/A',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ---------------- Photo Gallery ----------------
                    if (allImages.length > 1)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: _buildSectionHeader(
                              context,
                              'Photo Gallery',
                              Icons.photo_library_rounded,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          SizedBox(
                            height: 180.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              itemCount: allImages.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(right: 12.w),
                                  width: 260.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 15,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.r),
                                    child: Image.network(
                                      allImages[index],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: AppColors.primary.withOpacity(
                                            0.1,
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons
                                                  .image_not_supported_outlined,
                                              size: 40.sp,
                                              color: context.colors.onSurface
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 32.h),
                        ],
                      ),

                    // ---------------- Needs Section ----------------
                    if (needsList.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader(
                              context,
                              'What We Need',
                              Icons.volunteer_activism_rounded,
                            ),
                            SizedBox(height: 16.h),
                            ...needsList.map((need) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 10.h),
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 2.h),
                                      width: 20.w,
                                      height: 20.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check_rounded,
                                        size: 12.sp,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Text(
                                        need.toString(),
                                        style: TextStyle(
                                          fontSize: FontSizes.f14,
                                          color: context.colors.onSurface,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            SizedBox(height: 32.h),
                          ],
                        ),
                      ),

                    // ---------------- Success Stories ----------------
                    if (storiesList.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader(
                              context,
                              'Success Stories',
                              Icons.auto_stories_rounded,
                            ),
                            SizedBox(height: 16.h),
                            ...storiesList.map((story) {
                              final storyData = story as Map<String, dynamic>;
                              return Container(
                                margin: EdgeInsets.only(bottom: 16.h),
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  color: context.colors.surface,
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: AppColors.secondary.withOpacity(
                                      0.15,
                                    ),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(10.w),
                                          decoration: BoxDecoration(
                                            color: AppColors.secondary
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.format_quote_rounded,
                                            size: 20.sp,
                                            color: AppColors.secondary,
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                storyData['title'] ??
                                                    'Untitled',
                                                style: TextStyle(
                                                  fontSize: FontSizes.f16,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      context.colors.onSurface,
                                                  height: 1.3,
                                                ),
                                              ),
                                              SizedBox(height: 8.h),
                                              Text(
                                                storyData['description'] ??
                                                    'No description',
                                                style: TextStyle(
                                                  fontSize: FontSizes.f14,
                                                  color: context
                                                      .colors
                                                      .onSurface
                                                      .withOpacity(0.7),
                                                  height: 1.6,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            SizedBox(height: 32.h),
                          ],
                        ),
                      ),

                    // ---------------- Upcoming Events ----------------
                    if (eventsList.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader(
                              context,
                              'Upcoming Events',
                              Icons.event_available_rounded,
                            ),
                            SizedBox(height: 16.h),
                            ...eventsList.asMap().entries.map((entry) {
                              final index = entry.key;
                              final eventData =
                                  entry.value as Map<String, dynamic>;
                              final isLast = index == eventsList.length - 1;

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Timeline
                                  Column(
                                    children: [
                                      Container(
                                        width: 44.w,
                                        height: 44.w,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.primary,
                                              AppColors.secondary,
                                            ],
                                          ),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.primary
                                                  .withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.event_rounded,
                                          color: AppColors.white,
                                          size: 20.sp,
                                        ),
                                      ),
                                      if (!isLast)
                                        Container(
                                          width: 2.w,
                                          height: 70.h,
                                          margin: EdgeInsets.symmetric(
                                            vertical: 4.h,
                                          ),
                                          color: AppColors.primary.withOpacity(
                                            0.2,
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(width: 16.w),
                                  // Event Card
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        bottom: isLast ? 0 : 16.h,
                                      ),
                                      padding: EdgeInsets.all(16.w),
                                      decoration: BoxDecoration(
                                        color: context.colors.surface,
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                        border: Border.all(
                                          color: AppColors.primary.withOpacity(
                                            0.1,
                                          ),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.05,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            eventData['name'] ??
                                                'Unnamed Event',
                                            style: TextStyle(
                                              fontSize: FontSizes.f16,
                                              fontWeight: FontWeight.bold,
                                              color: context.colors.onSurface,
                                              height: 1.3,
                                            ),
                                          ),
                                          if (eventData['description'] !=
                                                  null &&
                                              eventData['description']
                                                  .toString()
                                                  .isNotEmpty) ...[
                                            SizedBox(height: 8.h),
                                            Text(
                                              eventData['description'],
                                              style: TextStyle(
                                                fontSize: FontSizes.f14,
                                                color: context.colors.onSurface
                                                    .withOpacity(0.7),
                                                height: 1.5,
                                              ),
                                            ),
                                          ],
                                          SizedBox(height: 12.h),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.access_time_rounded,
                                                size: 14.sp,
                                                color: AppColors.primary,
                                              ),
                                              SizedBox(width: 6.w),
                                              Expanded(
                                                child: Text(
                                                  eventData['date'] ??
                                                      'Date TBA',
                                                  style: TextStyle(
                                                    fontSize: FontSizes.f12,
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.w600,
                                                    height: 1.4,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                            // ---------------- Video Call Button ----------------
                            SizedBox(height: 20.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Material(
                                elevation: 4,
                                borderRadius: BorderRadius.circular(16.r),
                                shadowColor: AppColors.blue.withOpacity(0.3),
                                child: InkWell(
                                  onTap: () {
                                    Nav.push(
                                      context,
                                      VideoCallScheduleUI(
                                        orphanagename: orphanage['fullName'],
                                        orphanage: orphanage,
                                        useremail: useremail,
                                        username: username,
                                        userphone: userphone,
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(16.r),
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.h,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.blue,
                                          AppColors.blue.withOpacity(0.8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.video_call_rounded,
                                          size: 24.sp,
                                          color: AppColors.white,
                                        ),
                                        SizedBox(width: 12.w),
                                        Text(
                                          'Schedule Video Call',
                                          style: TextStyle(
                                            fontSize: FontSizes.f16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.white,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 120.h),
                  ],
                ),
              ),
            ],
          ),

          // ---------------- Bottom Donate Button ----------------
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    context.colors.background,
                    context.colors.background.withOpacity(0.95),
                    context.colors.background.withOpacity(0),
                  ],
                ),
              ),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(20.r),
                shadowColor: AppColors.primary.withOpacity(0.4),
                child: InkWell(
                  onTap: () {
                    Nav.push(
                      context,
                      DonationPageView(
                        orphanagedata: orphanage,
                        useremail: useremail,
                        username: username,
                        userphone: userphone,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    height: 60.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_rounded,
                          size: 26.sp,
                          color: AppColors.white,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Make a Donation',
                          style: TextStyle(
                            fontSize: FontSizes.f20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 16.sp, color: AppColors.primary),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: FontSizes.f14,
              color: context.colors.onSurface.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.15),
                AppColors.primary.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, size: 20.sp, color: AppColors.primary),
        ),
        SizedBox(width: 12.w),
        Text(
          title,
          style: TextStyle(
            fontSize: FontSizes.f20,
            fontWeight: FontWeight.bold,
            color: context.colors.onSurface,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
